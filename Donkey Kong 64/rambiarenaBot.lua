addresses = {
	current_map = 0x76A0A8,
	actor_count = 0x7FC3F0,
	pointer_list = 0x7FBFF0,
	obj_model2_timer = 0x76A064,
	player_pointer = 0x7FBB4C,
	camera_pointer = 0x7FB968,
};

RDRAMBase = 0x80000000;
RDRAMSize = 0x800000; 
RAMBase = RDRAMBase;
RAMSize = RDRAMSize;

function isRDRAM(value)
	return type(value) == "number" and value >= 0 and value < RDRAMSize;
end

function isPointer(value)
		return type(value) == "number" and value >= RDRAMBase and value < RDRAMBase + RDRAMSize;
end

function dereferencePointer(address)
	if type(address) == "number" and address >= 0 and address < (RDRAMSize - 4) then
		address = mainmemory.read_u32_be(address);
		if isPointer(address) then
			return address - RDRAMBase;
		end
	end
end

function getActorPointers(actor_value)
	pointers = {};
	count = 0;
	object_m1_count = math.min(255, mainmemory.read_u16_be(addresses.actor_count)); -- Actor Count
	for object_no = 0, object_m1_count do
		local pointer = dereferencePointer(addresses.pointer_list + (object_no * 4));
		if isRDRAM(pointer) then
			actor_type = mainmemory.read_u32_be(pointer + 0x58);
			if actor_type == actor_value then
				count = count + 1;
				pointers[count] = pointer;
			end
		end
	end
	return pointers
end

function getBeaversList()
	blue_beavers = getActorPointers(178);
	gold_beavers = getActorPointers(212);
	all_beavers = {};
	all_beavers_count = 0;
	if #blue_beavers > 0 then
		for i = 1, #blue_beavers do
			all_beavers_count = all_beavers_count + 1;
			all_beavers[all_beavers_count] = blue_beavers[i];
		end
	end
	if #gold_beavers > 0 then
		for i = 1, #gold_beavers do
			all_beavers_count = all_beavers_count + 1;
			all_beavers[all_beavers_count] = gold_beavers[i];
		end
	end
	return all_beavers;
end

function isLoading()
	return mainmemory.read_u32_be(addresses.obj_model2_timer) == 0;
end

function getPlayerObject() -- TODO: Cache this
	if isLoading() then
		return;
	end
	return dereferencePointer(addresses.player_pointer);
end

function getPositionArray()
	local playerObject = getPlayerObject();
	player_pos_array = {0,0,0};
	if isRDRAM(playerObject) then
		for i = 1, 3 do
			player_pos_array[i] = mainmemory.readfloat(playerObject + 0x78 + (4 * i), true);
		end
	end
	return player_pos_array;
end

function lineLength(p1_x,p1_y,p2_x,p2_y)
	return math.sqrt(((p1_x - p2_x)^2) + ((p1_y - p2_y)^2));
end

function getNearest(actor_pointer_list,position_array)
	if #actor_pointer_list > 0 then
		current_min = 10000;
		current_min_pointer = 0;
		for i = 1, #actor_pointer_list do
			actor_pos = {};
			distance = {};
			health = mainmemory.read_s16_be(actor_pointer_list[i] + 0x134);
			y_velo = mainmemory.readfloat(actor_pointer_list[i] + 0xC0, true);
			if health > 0 and y_velo == -10 then
				for j = 1, 3 do
					actor_pos[j] = mainmemory.readfloat(actor_pointer_list[i] + 0x78 + (4 * j),true);
					distance[j] = math.abs(position_array[j] - actor_pos[j]);
				end
				pythag_xz = math.sqrt((distance[1] ^ 2) + (distance[3] ^ 2));
				pythag_xyz = math.sqrt((pythag_xz ^ 2) + (distance[2] ^ 2));
				if current_min > pythag_xyz then
					current_min = pythag_xyz;
					current_min_pointer = actor_pointer_list[i];
				end
			end
		end
		return current_min_pointer;
	else
		return 0;
	end
end

function getCameraRotation()
	camera = dereferencePointer(addresses.camera_pointer);
	if isRDRAM(camera) then
		return mainmemory.read_u16_be(camera + 0x22A) / 4096 * 360;
	end
	return 0;
end

function vect_x(p1_x,p1_y,p2_x,p2_y)
	return p2_x - p1_x;
end

function vect_y(p1_x,p1_y,p2_x,p2_y)
	return p2_y - p1_y
end

function dot(p1_x,p1_y,p2_x,p2_y)
	return (p1_x * p2_x) + (p1_y * p2_y);
end

enable_rambibot = 1;

function setinputs()
	map = mainmemory.read_u32_be(addresses.current_map);
	if map == 0xBF and enable_rambibot == 1 then
		beaver_list = getBeaversList();
		player_position_array = getPositionArray();
		nearest_beaver = getNearest(beaver_list,player_position_array);
		if nearest_beaver > 0 then -- Beaver Exists
			target_x = mainmemory.readfloat(nearest_beaver + 0x7C,true);
			target_z = mainmemory.readfloat(nearest_beaver + 0x84,true);
			player_x = player_position_array[1];
			player_z = player_position_array[3];
			distance_to_target = lineLength(player_x,player_z,target_x,target_z);
			camera_rot = getCameraRotation();
			--angle_pointing_up = (360 - camera_rot) % 360;
			angle_pointing_up = camera_rot;
			camera_up_x = player_x + (distance_to_target * math.sin(angle_pointing_up * (math.pi / 180)));-- 90 +
			camera_up_z = player_z + (distance_to_target * math.cos(angle_pointing_up * (math.pi / 180)));-- 0 +
			for i = 0, 4095 do
				potential_x = player_x + (distance_to_target * math.sin((i / 4096) * 360 * (math.pi / 180)));
				potential_z = player_z + (distance_to_target * math.cos((i / 4096) * 360 * (math.pi / 180)));
			end
			--lineNT = lineLength(camera_up_x,camera_up_z,target_x,target_z);
			--playerToBeaver_angle = math.acos(((linePN ^ 2) + (linePT ^ 2) - (lineNT ^ 2)) / (2 * linePN * linePT));
			--angle_to_point = ((playerToBeaver_angle + 3600) - angle_pointing_up) % 360;
			angle_to_point = playerToBeaver_angle;
			angle_to_point_deg = angle_to_point * (180 / math.pi);
			input_x = 128 * math.sin(angle_to_point);
			input_y = 128 * math.cos(angle_to_point);
			joypad.setanalog({["X Axis"] = input_x, ["Y Axis"] = input_y}, 1)
		end
	end
end

function printData()
	print("Player: "..math.floor(player_x)..", "..math.floor(player_z))
	print("Camera Up: "..math.floor(camera_up_x)..", "..math.floor(camera_up_z))
	print("Target: "..math.floor(target_x)..", "..math.floor(target_z))
end

event.onframestart(setinputs, "Sets inputs");
emu.yield();