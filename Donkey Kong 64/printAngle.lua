-- For Bismuth69

script_running = false;
previous_frame = -1;

function start()
	previous_frame = -1;
	script_running = true;
end

function finish()
	script_running = false;
end

function getPlayerObject()
	obj_m2_timer_value = mainmemory.read_u32_be(0x76A064)
	if obj_m2_timer_value == 0 then
		return;
	end
	return mainmemory.read_u32_be(0x7FBB4C) - 0x80000000;
end

function run_script()
	lag_present = emu.islagged();
	if script_running and not lag_present then
		inSubgame = false;
		current_map = mainmemory.read_u32_be(0x76A0A8);
		if current_map == 2 then
			inSubgame = true;
		elseif current_map == 9 then
			inSubgame = true;
		end
		if not inSubgame then
			local playerObject = getPlayerObject();
			if playerObject < 0x80800000 then
				print(360 * (mainmemory.read_u16_be(playerObject + 0xE6) / 4096));
			end
		end
	end
end

event.onframestart(run_script, "Runs process");