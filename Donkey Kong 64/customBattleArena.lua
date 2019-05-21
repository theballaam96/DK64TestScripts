memory = {
	actor_count = 0x7FC3F0,
	pointer_list = 0x7FBFF0,
	num_enemies = 0x7FDC88,
	enemy_respawn_object = 0x7FDC8C,
};

-- Set Enemies
	-- Set the 0x44 bytes of information
	-- Same movement box as all
-- Set Crown Name
	-- Find Text Overlay actor
	-- Pointer (u32) at 0x178
	-- Convert text to hex
	-- Write text byte by byte
	-- Centre
-- Set Crown Timer
	-- Find Timer Actor
	-- u8 (+0x187)
-- Set Respawn Rate
	-- Spawner Objects
	-- Detect Death of associated actor
	-- Set respawn timer (+0x24, u16)

CrownNames = {
	"Beaver Brawl!",
	"Kritter Karnage!",
	"Arena Ambush!", -- 13 Chars, 220
	"Bish Bash Brawl!",
	"More Kritter Karnage!", -- 21 Chars, 10
	"Kamikaze Kremlings!",
	"Plinth Panic!",
	"Forest Fracas!",
	"Pinnacle Palaver!",
	"Shockwave Showdown!", -- 19 Chars, -22
};	

crown_name = "2DOS'S MINIOVEN CASTLE",

enemyTypes = {
	[0x0] = {"Beaver", permissable = true},
	[0x1] = {"Giant Clam", permissable = false},
	[0x2] = {"Krash", permissable = false},
	[0x3] = {"Book", permissable = true},
	[0x4] = {"0", permissable = false}, -- Beta Jack
	[0x5] = {"Zinger (Charger)", permissable = true, y = 250},
	[0x6] = {"Klobber", permissable = false},
	[0x7] = {"Snide", permissable = false},
	[0x8] = {"Army Dillo", permissable = false},
	[0x9] = {"Klump", permissable = true},
	[0xA] = {"0", permissable = false}, -- Beta Army
	[0xB] = {"Cranky", permissable = false},
	[0xC] = {"Funky", permissable = false},
	[0xD] = {"Candy", permissable = false},
	[0xE] = {"Beetle", permissable = false},
	[0xF] = {"Mermaid", permissable = false},
	[0x10] = {"Kabooom", permissable = false},
	[0x11] = {"Vulture", permissable = false},
	[0x12] = {"Squawks", permissable = false},
	[0x13] = {"Cutscene DK", permissable = false},
	[0x14] = {"Cutscene Diddy", permissable = false},
	[0x15] = {"Cutscene Lanky", permissable = false},
	[0x16] = {"Cutscene Tiny", permissable = false},
	[0x17] = {"Cutscene Chunky", permissable = false},
	[0x18] = {"Padlock (T&S)", permissable = false},
	[0x19] = {"Llama", permissable = false},
	[0x1A] = {"Mad Jack", permissable = false},
	[0x1B] = {"Klaptrap (Green)", permissable = true},
	[0x1C] = {"Zinger (Bomber)", permissable = true, y = 250},
	[0x1D] = {"Vulture (Race)", permissable = true},
	[0x1E] = {"Klaptrap (Purple)", permissable = true},
	[0x1F] = {"Klaptrap (Red)", permissable = true},
	[0x20] = {"Get Out Controller", permissable = true, controller = true},
	[0x21] = {"Beaver (Gold)", permissable = true},
	[0x22] = {"0", permissable = false}, -- Beta Re-Koil
	[0x23] = {"Fire Column Spawner", permissable = true},
	[0x24] = {"Minecart (TNT)", permissable = false},
	[0x25] = {"Minecart (TNT)", permissable = false},
	[0x26] = {"Pufftoss", permissable = false},
	[0x27] = {"Cannon (Seasick)", permissable = true},
	[0x28] = {"K Rool's Foot", permissable = false},
	[0x29] = {"0", permissable = false},
	[0x2A] = {"Fireball Spawner", permissable = true},
	[0x2B] = {"0", permissable = false}, -- Beta Boxing Glove
	[0x2C] = {"Mushroom Man", permissable = true},
	[0x2D] = {"0", permissable = false}, -- Beta Rareware Logo
	[0x2E] = {"Troff", permissable = false},
	[0x2F] = {"0", permissable = false},
	[0x30] = {"Bad Hit Detection Man", permissable = true},
	[0x31] = {"0", permissable = false},
	[0x32] = {"0", permissable = false},
	[0x33] = {"Ruler", permissable = true},
	[0x34] = {"Toy Box", permissable = false},
	[0x35] = {"Squawks", permissable = false},
	[0x36] = {"Seal", permissable = false},
	[0x37] = {"Scoff", permissable = false},
	[0x38] = {"Robo-Kremling", permissable = true},
	[0x39] = {"Dogadon", permissable = false},
	[0x3A] = {"0", permissable = false},
	[0x3B] = {"Kremling", permissable = true},
	[0x3C] = {"Spotlight Fish", permissable = false},
	[0x3D] = {"Kasplat (DK)", permissable = true},
	[0x3E] = {"Kasplat (Diddy)", permissable = true},
	[0x3F] = {"Kasplat (Lanky)", permissable = true},
	[0x40] = {"Kasplat (Tiny)", permissable = true},
	[0x41] = {"Kasplat (Chunky)", permissable = true},
	[0x42] = {"Mechanical Fish", permissable = false},
	[0x43] = {"Seal", permissable = false},
	[0x44] = {"Banana Fairy", permissable = false},
	[0x45] = {"Squawks (w/ Spotlight)", permissable = false},
	[0x46] = {"0", permissable = false},
	[0x47] = {"0", permissable = false},
	[0x48] = {"Rabbit", permissable = false},
	[0x49] = {"Owl", permissable = false},
	[0x4A] = {"Nintendo Logo", permissable = false},
	[0x4B] = {"Fire Breath Spawner", permissable = true},
	[0x4C] = {"Minigame Controller", permissable = false, controller = true},
	[0x4D] = {"Battle Crown Controller", permissable = false, controller = true},
	[0x4E] = {"Toy Car", permissable = false},
	[0x4F] = {"Minecart (TNT)", permissable = false},
	[0x50] = {"Cutscene Object", permissable = false},
	[0x51] = {"Guard", permissable = false},
	[0x52] = {"Rareware Logo", permissable = false},
	[0x53] = {"Robo-Zinger", permissable = true, y = 250},
	[0x54] = {"Krossbones", permissable = true},
	[0x55] = {"Shuri", permissable = true},
	[0x56] = {"Gimpfish", permissable = true},
	[0x57] = {"Mr. Dice", permissable = true},
	[0x58] = {"Sir Domino", permissable = true},
	[0x59] = {"Mr. Dice", permissable = true},
	[0x5A] = {"Rabbit", permissable = false},
	[0x5B] = {"0", permissable = false},
	[0x5C] = {"Fireball (w/ Glasses)", permissable = true},
	[0x5D] = {"K. Lumsy", permissable = false},
	[0x5E] = {"Spider (Boss)", permissable = false},
	[0x5F] = {"Spider (Spiderling)", permissable = true},
	[0x60] = {"Squawks", permissable = false},
	[0x61] = {"K Rool (DK Phase)", permissable = false},
	[0x62] = {"Skeleton Head", permissable = false},
	[0x63] = {"Bat", permissable = true},
	[0x64] = {"Tomato (Fungi)", permissable = true},
	[0x65] = {"Kritter-in-a-Sheet", permissable = true},
	[0x66] = {"Pufftup", permissable = false},
	[0x67] = {"Kosha", permissable = true},
	[0x68] = {"0", permissable = false},
	[0x69] = {"Enemy Car", permissable = false},
	[0x6A] = {"K. Rool (Diddy Phase)", permissable = false},
	[0x6B] = {"K. Rool (Lanky Phase)", permissable = false},
	[0x6C] = {"K. Rool (Tiny Phase)", permissable = false},
	[0x6D] = {"K. Rool (Chunky Phase)", permissable = false},
	[0x6E] = {"Bug", permissable = false},
	[0x6F] = {"Banana Fairy (BFI)", permissable = false},
	[0x70] = {"Tomato (Ice)", permissable = false},
};

textChars = {
	[0x20] = {" ",9},
	[0x21] = {"!",2},
	[0x25] = {"%",9},
	[0x27] = {"'",2},
	[0x28] = {"(",2},
	[0x29] = {")",2},
	[0x2C] = {",",9},
	[0x2D] = {"-",9},
	[0x2E] = {".",9},
	[0x30] = {"0",9},
	[0x31] = {"1",9},
	[0x32] = {"2",9},
	[0x33] = {"3",9},
	[0x34] = {"4",9},
	[0x35] = {"5",9},
	[0x36] = {"6",9},
	[0x37] = {"7",9},
	[0x38] = {"8",9},
	[0x39] = {"9",9},
	[0x3A] = {":",2},
	[0x3B] = {";",2},
	[0x3F] = {"?",9},
	[0x41] = {"A",9},
	[0x42] = {"B",9},
	[0x43] = {"C",9},
	[0x44] = {"D",9},
	[0x45] = {"E",9},
	[0x46] = {"F",9},
	[0x47] = {"G",9},
	[0x48] = {"H",9},
	[0x49] = {"I",9},
	[0x4A] = {"J",9},
	[0x4B] = {"K",9},
	[0x4C] = {"L",9},
	[0x4D] = {"M",9},
	[0x4E] = {"N",9},
	[0x4F] = {"O",9},
	[0x50] = {"P",9},
	[0x51] = {"Q",9},
	[0x52] = {"R",9},
	[0x53] = {"S",9},
	[0x54] = {"T",9},
	[0x55] = {"U",9},
	[0x56] = {"V",9},
	[0x57] = {"W",9},
	[0x58] = {"X",9},
	[0x59] = {"Y",9},
	[0x5A] = {"Z",9},
	[0xEF] = {"?",9},
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
	object_m1_count = math.min(255, mainmemory.read_u16_be(memory.actor_count)); -- Actor Count
	for object_no = 0, object_m1_count do
		local pointer = dereferencePointer(memory.pointer_list + (object_no * 4));
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

function returnFirst(array)
	if #array > 0 then
		return array[1];
	end
	return nil;
end

function textToHex(character)
	for i = 1, 0xEF do
		if textChars[i] ~= nil then
			if textChars[i][1] == character then
				return i;
			end
		end
	end
	return 0x20;
end

function writeCrownName(text)
	-- Find Text Overlay actor
		text_overlays = getActorPointers(232);
		text_overlay = returnFirst(text_overlays);
	-- Pointer (u32) at 0x178
		if text_overlay ~= nil then
			text_header = dereferencePointer(text_overlay + 0x178);
		end
	-- Convert text to hex
		crown_name_length = string.len(crown_name);
		if crown_name_length == 0 then
			crown_name = " ";
		end
		crown_name_length = string.len(crown_name);
	-- Write text byte by byte
		for i = 1, crown_name_length do
			charToConvert = string.sub(crown_name, i, i);
			hex_value = textToHex(charToConvert);
			text_offset = i - 1;
			mainmemory.writebyte(text_header + text_offset, hex_value);
		end
	-- Centre
		text_centring_value = 623 - (31 * crown_name_length); -- 623-31x
		mainmemory.writefloat(text_overlay + 0x7C, text_centring_value, true);
end

function setCrownTimer(timer_value)
	-- Find Timer Actor
		timers = getActorPointers(176);
		timer = returnFirst(timers);
	-- u8 (+0x187)
		mainmemory.writebyte(timer + 0x187, timer_value);
end

function generatePermissableEnemyTypes()
	enemyTypes_permissable = {};
	for i = 1, #enemyTypes do
		if enemyTypes[i].permissable then
			enemyTypes_permissable[#enemyTypes_permissable + 1] = enemyTypes[i][1];
		end
	end
end

generatePermissableEnemyTypes();

function spawnerValFromName(enemyName)
	for i = 1, #enemyTypes do
		if enemyTypes[i][1] == enemyName then
			return i;
		end
	end
	return 0;
end

generic_movement_box_pointer = 0x80000000;
generic_chunk = 0;
generic_spawn_state = 2;

function setSpawnerStats(spawnerHeader, enemyType, scale, coordsArray, speed)
	-- Custom
	mainmemory.writebyte(spawnerHeader, enemyType);
	mainmemory.writebyte(spawnerHeader + 0x44, enemyType);
	mainmemory.write_s16_be(spawnerHeader + 0x4, coordsArray[1]);
	mainmemory.write_s16_be(spawnerHeader + 0x6, coordsArray[2]);
	mainmemory.write_s16_be(spawnerHeader + 0x8, coordsArray[3]);
	mainmemory.writebyte(spawnerHeader + 0xD, speed);
	mainmemory.writebyte(spawnerHeader + 0xF, scale);
	-- Generic
	mainmemory.write_u32_be(spawnerHeader + 0x1C, generic_movement_box_pointer);
	mainmemory.write_s16_be(spawnerHeader + 0x40, generic_chunk);
	mainmemory.writebyte(spawnerHeader + 0x42, generic_spawn_state);
end

spawnersList = {
	-- [1] = {enemyType, scale, speed};
};

function getCountOfNonControllers()
	modelEnemies = 0;
	for i = 1, #spawnersList do
		if enemyTypes[spawnersList[i][1]].controller then
			modelEnemies = modelEnemies + 1;
		end
	end
	return modelEnemies;
end

function getListOfNonControllers()
	listOfModelEnemies = {};
	for i = 1, #spawnersList do
		if enemyTypes[spawnersList[i][1]].controller then
			listOfModelEnemies[#listOfModelEnemies + 1] = spawnersList[i];
		end
	end
	return listOfModelEnemies;
end

radius = math.sqrt(2 * (55 ^ 2));
centre = {586,586};

function getXZSpawners()
	count = getCountOfNonControllers();
	list = getListOfNonControllers();
	if count == 1 then
		spawnerLocations[1] = {646,637};
	elseif count > 1 then
		spawnerLocations[1] = {646,535};
		spawnerLocations[2] = {531,643};
		divisor = count - 1;
		if count > 2 then
			for i = 3, count do
				angular_offset = 0
				angle = angular_offset + ((i - 2) * (math.pi / divisor));
			end
		end
	end
end

function generateSpawners()
	mainmemory.write_u16_be(memory.num_enemies, #spawnersList + 1);
	spawnersHeader = dereferencePointer(memory.enemy_respawn_object);
	spawner_size = 0x48;
	for i = 1, #spawnersList do
		spawnerRDRAMLocation = spawnersHeader + (spawner_size * (i - 1));
		y_height = 205;
		if enemyTypes[spawnersList[i][1]].y ~= nil then
			y_height = enemyTypes[spawnersList[i][1]].y;
		end
		arrayForCoords = {205, y_height, 205};
		setSpawnerStats(spawnerRDRAMLocation, spawnersList[i][1], spawnersList[i][2], arrayForCoords, spawnersList[i][3]); 
	end
end