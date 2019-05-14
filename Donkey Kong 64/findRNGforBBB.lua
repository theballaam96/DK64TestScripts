addresses = {
	[1] = 0x4B2290,
	[2] = 0x4AB8B0,
	[3] = 0x4AAD70,
	[4] = 0x4AA230,
};

rotation_z = 0xE8;

function getSlotPositionFromRotation(rotation)
	rotation_degrees = (rotation / 4096) * 360;
	rotation_slot = 0;
	if rotation_degrees > 330 or rotation_degrees < 30 then
		rotation_slot = 6;
	end
	for i = 1, 5 do
		lower_bound = (60 * i) - 30;
		upper_bound = (60 * i) + 30;
		if rotation_degrees > lower_bound and rotation_degrees < upper_bound then
			rotation_slot = i;
		end
	end
	return rotation_slot
end

-- Slot 1: coconut > 120
		-- GB > 180
-- Slot 2: grape > 0
		-- Coconut > 60
-- Slot 3: watermelon > 300
		-- Coconut > 0
-- Slot 4: grape > 300
		-- watermelon > 0

goals = {
	[1] = {2,4,1,4},
	[2] = {2,4,4,4},
	[3] = {5,4,1,4},
	[4] = {5,4,4,4},
};
		
reels = {
	[1] = {"Pineapple", "Coconut", "GB", "Watermelon", "Grape", "GB"},
	[2] = {"Grape", "Coconut", "Watermelon", "GB", "Pineapple", "GB"},
	[3] = {"GB", "Pineapple", "Grape", "GB", "Watermelon", "Coconut"},
	[4] = {"Pineapple", "GB", "Coconut", "GB", "Grape", "Watermelon"},
};

function detectSuccess()
	slot = {};
	for i = 1, 4 do
		noted_address = addresses[i];
		rot_z = mainmemory.read_u16_be(noted_address + rotation_z);
		slot_position = getSlotPositionFromRotation(rot_z);
		slot[i] = slot_position;
	end
	goal_match = 0;
	for i = 1, #goals do
		different = false;
		for j = 1, 4 do
			if goals[i][j] ~= slot[j] then
				different = true;
			end
		end
		if not different then
			goal_match = i;
		end
	end
	if goal_match > 0 then
		return true;
	end
	return false;
end
start_rng = 300;
rng_value = start_rng;
client.unpause();
savestate.loadslot(3);

function eventCycle()
	if rng_value < (start_rng + 5000) then
		frame = emu.framecount();
		--print("State Loaded");
		if frame < 3861 then
			mainmemory.write_u32_be(0x746a40,rng_value);
			--print("RNG Written");
		elseif frame == 3861 then -- 3859
			mainmemory.write_u32_be(0x746a40,rng_value);
			successful = detectSuccess();
			--print("Success checked");
			if successful then
				print("RNG Value: "..rng_value..", SUCCESSFUL");
			else
				print("RNG Value: "..rng_value..", Not successful, Slots: "..slot[1]..","..slot[2]..","..slot[3]..","..slot[4]);
			end
			savestate.loadslot(3);
			rng_value = rng_value + 1;
			--print("State Loaded");
		end
	end
end

event.onframestart(eventCycle, "Event Cycle");