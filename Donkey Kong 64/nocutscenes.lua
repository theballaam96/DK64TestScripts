function killCutscene()
	mainmemory.writebyte(0x7444EC,0);
	map_state_byte = mainmemory.readbyte(0x76A0B1) % 32;
	if map_state_byte > 15 then
		mainmemory.writebyte(0x76A0B1,(map_state_byte - 16));
	end
end

function killCutscenePartially()
	map_state_byte = mainmemory.readbyte(0x76A0B1) % 32;
	if map_state_byte > 15 then
		mainmemory.writebyte(0x76A0B1,(map_state_byte - 16));
	end
end

while (1 == 1) do
	gamemode = mainmemory.readbyte(0x755314);
	cutscene = mainmemory.read_u16_be(0x7476F4);
	if gamemode > 3 and gamemode ~= 9 and gamemode ~= 11 then -- Allow the game to progress to the main menu
		if mainmemory.readbyte(0x7444EC) == 1 then
			if mainmemory.read_u32_be(0x7476FC) == 0x807F5B10 then
				killCutscene();
			else -- Kong Cutscene, can crash
				if cutscene == 5 or cutscene == 21 or cutscene == 31 then -- GB dance
					killCutscenePartially();
				end
			end
		end
	end
	emu.frameadvance()
end