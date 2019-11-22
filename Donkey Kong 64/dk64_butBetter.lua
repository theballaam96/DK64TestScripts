addresses = {
	character = 0x74E77C,
	playerPointer = 0x7FBB4C,
	currentMap = 0x76A0A8,
	mapState = 0x76A0B1,
	spawnPointer = 0x7FDC8C,
	spawnCount = 0x7FDC88,
	moveBase = 0x7FC950,
	file = 0x7467CB,
	music = 0x7458DD,
	frames_real = 0x76AF10,
	frames_lag = 0x7F0560,
};

boss_maps = {
	0x8,
	0xC5,
	0x9A,
	0x6F,
	0x53,
	0xC4,
	0xC7,
	0xCB, 
	0xCC,
	0xCD,
	0xCE,
	0xCF
};

boss_values = {0x8, 0x39, 0x1A, 0x26, 0x61, 0x6A, 0x6B, 0x6C, 0x6D};
boss_default_size = {50,200,167,75,200,200,200,200,200}

previous_character = 0;
previous_velocity = 0;

function cancelDanceSkip()
	mainmemory.write_u32_be(0x6EFB9C, 0xA1EE0154) -- Movement Write
	mainmemory.write_u32_be(0x6EFC1C, 0x0C189E52) -- CS Play Function Call
	mainmemory.write_u32_be(0x6EFB88, 0x0C18539E) -- Animation Write Function Call
	mainmemory.write_u32_be(0x6EFC0C, 0xA58200E6) -- Change Rotation Write
end

function autoDanceSkip()
	mainmemory.write_u32_be(0x6EFB9C, 0x0) -- Cancel Movement Write
	mainmemory.write_u32_be(0x6EFC1C, 0x0) -- Cancel CS Play Function Call
	mainmemory.write_u32_be(0x6EFB88, 0x0) -- Cancel Animation Write Function Call
	mainmemory.write_u32_be(0x6EFC0C, 0x0) -- Cancel Change Rotation Write
end
autoDanceSkip();

function preventLanky()
	val_character = mainmemory.readbyte(addresses.character);
	if val_character == 2 then
		mainmemory.writebyte(addresses.character, previous_character)
		val_mapState = mainmemory.readbyte(addresses.mapState);
		reload_state = val_mapState % 2;
		mainmemory.writebyte(addresses.mapState, val_mapState + (1 - reload_state));
	else
		previous_character = val_character;
	end
end

lag_factor = 2;
function superChargeVelocity()
	frames_visual = mainmemory.read_u32_be(0x7F0560);
	mainmemory.write_u32_be(0x76AF10, frames_visual - lag_factor);
end

function biggerBosses()
	val_currentMap = mainmemory.read_u32_be(addresses.currentMap);
	val_spawnPointer = mainmemory.read_u32_be(addresses.spawnPointer);
	in_boss = false;
	for i = 1, #boss_maps do
		if val_currentMap == boss_maps[i] then
			in_boss = true;
		end
	end
	if in_boss then
		if val_spawnPointer > 0 then
			spawnPointer_location = val_spawnPointer - 0x80000000;
			val_spawnCount = mainmemory.read_u16_be(addresses.spawnCount);
			if val_spawnCount > 0 then
				for i = 1, val_spawnCount do
					spawner_object = spawnPointer_location + (i - 1) * 0x48;
					spawner_enemy = mainmemory.readbyte(spawner_object);
					is_boss = false;
					stored_boss_value = 0;
					for i = 1, #boss_values do
						if spawner_enemy == boss_values[i] then
							is_boss = true;
							stored_boss_value = i;
						end
					end
					if is_boss then
						new_size = 1.5 * boss_default_size[stored_boss_value];
						if new_size > 255 then
							new_size = 255;
						end
						mainmemory.writebyte(spawner_object + 0xF,new_size);
					end
				end
			end
		end
	end
end

size = 0.10;
function smallerKong()
	val_playerPointer = mainmemory.read_u32_be(addresses.playerPointer);
	if val_playerPointer > 0 then
		playerPointer_location = val_playerPointer - 0x80000000;
		for i = 1, 5 do
			mainmemory.writefloat(playerPointer_location + 0x340 + (4 * i), size, true)
		end
	end
end

move_values = {3, 3, 7, 2, 15};

function unlockMoves()
	for i = 0, 4 do
		for j = 1, #move_values do
			mainmemory.writebyte(addresses.moveBase + (i * 0x5E) + (j - 1), move_values[j]);
		end
	end
end

kong_flags = {
	{0x30,1},
	{0x00,6},
	{0x08,6},
	{0x08,2},
	{0x0E,5},
};

function unlockKongs()
	for j = 1, #kong_flags do
		flagByte = kong_flags[j][1];
		flagBit = kong_flags[j][2];
		fileIndex = mainmemory.readbyte(addresses.file);
		for i = 0, 3 do
			EEPROMMap = mainmemory.readbyte(0x7EDEA8 + i);
			if EEPROMMap == fileIndex then
				eeprom_slot = i;
			end
		end
		eeprom_slot = 0;
		flags = 0x7ECEA8 + eeprom_slot * 0x1AC;
		if type(flagByte) == "number" and type(flagBit) == "number" and flagBit >= 0 and flagBit < 8 then
			currentValue = mainmemory.readbyte(flags + flagByte);
			mainmemory.writebyte(flags + flagByte, bit.set(currentValue, flagBit));
		end
	end
end

function setDKRap()
	mainmemory.writebyte(addresses.music, 75);
end

function eventCycle()
	preventLanky();
	superChargeVelocity();
	biggerBosses();
	smallerKong();
	unlockMoves();
	unlockKongs();
	setDKRap();
end

event.onframestart(eventCycle, "The Event Cycle");