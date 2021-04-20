function isValidPointer(addr)
	if addr >= 0x80000000 and addr < 0x80800000 then
		return true
	end
	return false
end

function derefPtr(addr)
	ptr = mainmemory.read_u32_be(addr)
	if isValidPointer(ptr) then
		return ptr - 0x80000000
	end
	return 0
end

focused_slotBase = 0

command_struct = {
	command = 0x0,
	command_param_1 = 0x2,
	command_param_2 = 0x4,
	command_param_3 = 0x6,
}

trigger_types = {
	-- 0x02 - In Castle Minecart/MJ/Fungi
	[0x03] = "Boss Door Trigger", -- Also sets boss fadeout type as fade instead of spin. In toolshed too??
	-- 0x04 - In Fungi Minecart
	[0x05] = "Cutscene Trigger",
	-- 0x06 - In Treehouse/m/fungi. Not phase reset plane
	-- 0x07 - In Fungi/Fungi Minecart
	-- 0x08 - In Fungi/Fungi Minecart
	[0x09] = "Loading Zone",
	[0x0A] = "Cutscene Trigger",
	-- 0xB - In Minecart Mayhem
	[0x0C] = "Loading Zone + Objects", -- Alows objects through
	[0x0D] = "Loading Zone",
	[0x0F] = "Warp Trigger", -- Factory Poles
	[0x10] = "Loading Zone",
	[0x11] = "Loading Zone", -- Snide's, Return to Parent Map?
	[0x13] = "Detransform Trigger",
	[0x14] = "Boss Loading Zone", -- Takes you to the boss of that level
	[0x15] = "Cutscene Trigger",
	-- 0x16 - In Az Beetle Slide
	[0x17] = "Cutscene Trigger",
	--0x18 - In Fungi Minecart
	-- [0x19] = "Trigger", -- Seal Race
	-- 0x1A - In Caves Beetle Slide
	[0x1B] = "Slide Trigger", -- Beetle Slides
	-- 0x1C - In Beetle Slides
	[0x20] = "Cutscene Trigger",
	[0x24] = "Detransform Trigger",
	-- 0x25 - In Factory
	[0x26] = "K. Lumsy Code Activator", -- In BFI too, but seems like functionality in BFI has been stripped from final
}

songs = {
	[0] = "Silence",
	[1] = "Jungle Japes (Starting Area)",
	[2] = "Cranky's Lab",
	[3] = "Jungle Japes (Minecart)",
	[4] = "Jungle Japes (Army Dillo)",
	[5] = "Jungle Japes (Caves/Underground)",
	[6] = "Funky's Hut",
	[7] = "Unused Coin Pickup",
	[8] = "Bonus Minigames",
	[9] = "Triangle Trample",
	[10] = "Guitar Gazump",
	[11] = "Bongo Blast",
	[12] = "Trombone Tremor",
	[13] = "Saxaphone Slam",
	[14] = "Angry Aztec",
	[15] = "Transformation",
	[16] = "Mini Monkey",
	[17] = "Hunky Chunky",
	[18] = "GB/Key Get",
	[19] = "Angry Aztec (Beetle Slide)",
	[20] = "Oh Banana",
	[21] = "Angry Aztec (Temple)",
	[22] = "Company Coin Get",
	[23] = "Banana Coin Get",
	[24] = "Going through Vulture Ring",
	[25] = "Angry Aztec (Dogadon)",
	[26] = "Angry Aztec (5DT)",
	[27] = "Frantic Factory (Car Race)",
	[28] = "Frantic Factory",
	[29] = "Snide's HQ",
	[30] = "Jungle Japes (Tunnels)",
	[31] = "Candy's Music Shop",
	[32] = "Minecart Coin Get",
	[33] = "Melon Slice Get",
	[34] = "Pause Menu",
	[35] = "Crystal Coconut Get",
	[36] = "Rambi",
	[37] = "Angry Aztec (Tunnels)",
	[38] = "Water Droplets",
	[39] = "Frantic Factory (Mad Jack)",
	[40] = "Success",
	[41] = "Start (To pause game)",
	[42] = "Failure",
	[43] = "DK Transition (Opening)",
	[44] = "DK Transition (Closing)",
	[45] = "Unused High-Pitched Japes",
	[46] = "Fairy Tick",
	[47] = "Melon Slice Drop",
	[48] = "Angry Aztec (Chunky Klaptraps)",
	[49] = "Frantic Factory (Crusher Room)",
	[50] = "Jungle Japes (Baboon Blast)",
	[51] = "Frantic Factory (R&D)",
	[52] = "Frantic Factory (Production Room)",
	[53] = "Troff 'n' Scoff",
	[54] = "Boss Defeat",
	[55] = "Angry Aztec (Baboon Blast)",
	[56] = "Gloomy Galleon (Outside)",
	[57] = "Boss Unlock",
	[58] = "Awaiting Entering the Boss",
	[59] = "Generic Twinkly Sounds",
	[60] = "Gloomy Galleon (Pufftoss)",
	[61] = "Gloomy Galleon (Seal Race)",
	[62] = "Gloomy Galleon (Tunnels)",
	[63] = "Gloomy Galleon (Lighthouse)",
	[64] = "Battle Arena",
	[65] = "Drop Coins (Minecart)",
	[66] = "Fairy Nearby",
	[67] = "Checkpoint",
	[68] = "Fungi Forest (Day)",
	[69] = "Blueprint Get",
	[70] = "Fungi Forest (Night)",
	[71] = "Strong Kong",
	[72] = "Rocketbarrel Boost",
	[73] = "Orangstand Sprint",
	[74] = "Fungi Forest (Minecart)",
	[75] = "DK Rap",
	[76] = "Blueprint Drop",
	[77] = "Gloomy Galleon (2DS)",
	[78] = "Gloomy Galleon (5DS/Submarine)",
	[79] = "Gloomy Galleon (Pearls Chest)",
	[80] = "Gloomy Galleon (Mermaid Palace)",
	[81] = "Fungi Forest (Dogadon)",
	[82] = "Mad Maze Maul",
	[83] = "Crystal Caves",
	[84] = "Crystal Caves (Giant Kosha Tantrum)",
	[85] = "Nintendo Logo (Old?)",
	[86] = "Success (Races)",
	[87] = "Failure (Races & Try Again)",
	[88] = "Bonus Barrel Introduction",
	[89] = "Stealthy Snoop",
	[90] = "Minecart Mayhem",
	[91] = "Gloomy Galleon (Mechanical Fish)",
	[92] = "Gloomy Galleon (Baboon Blast)",
	[93] = "Fungi Forest (Anthill)",
	[94] = "Fungi Forest (Barn)",
	[95] = "Fungi Forest (Mill)",
	[96] = "Generic Seaside Sounds",
	[97] = "Fungi Forest (Spider)",
	[98] = "Fungi Forest (Mushroom Top Rooms)",
	[99] = "Fungi Forest (Giant Mushroom)",
	[100] = "Boss Introduction",
	[101] = "Tag Barrel (All of them)",
	[102] = "Crystal Caves (Beetle Race)",
	[103] = "Crystal Caves (Igloos)",
	[104] = "Mini Boss",
	[105] = "Creepy Castle",
	[106] = "Creepy Castle (Minecart)",
	[107] = "Baboon Balloon",
	[108] = "Gorilla Gone",
	[109] = "DK Isles",
	[110] = "DK Isles (K Rool's Ship)",
	[111] = "DK Isles (Banana Fairy Island)",
	[112] = "DK Isles (K-Lumsy's Prison)",
	[113] = "Hideout Helm (Blast-O-Matic On)",
	[114] = "Move Get",
	[115] = "Gun Get",
	[116] = "Hideout Helm (Blast-O-Matic Off)",
	[117] = "Hideout Helm (Bonus Barrels)",
	[118] = "Crystal Caves (Cabins)",
	[119] = "Crystal Caves (Rotating Room)",
	[120] = "Crystal Caves (Tile Flipping)",
	[121] = "Creepy Castle (Tunnels)",
	[122] = "Intro Story Medley",
	[123] = "Training Grounds",
	[124] = "Enguarde",
	[125] = "K-Lumsy Celebration",
	[126] = "Creepy Castle (Crypt)",
	[127] = "Headphones Get",
	[128] = "Pearl Get",
	[129] = "Creepy Castle (Dungeon w/ Chains)",
	[130] = "Angry Aztec (Lobby)",
	[131] = "Jungle Japes (Lobby)",
	[132] = "Frantic Factory (Lobby)",
	[133] = "Gloomy Galleon (Lobby)",
	[134] = "Main Menu",
	[135] = "Creepy Castle (Inner Crypts)",
	[136] = "Creepy Castle (Ballroom)",
	[137] = "Creepy Castle (Greenhouse)",
	[138] = "K Rool's Theme",
	[139] = "Fungi Forest (Winch)",
	[140] = "Creepy Castle (Wind Tower)",
	[141] = "Creepy Castle (Tree)",
	[142] = "Creepy Castle (Museum)",
	[143] = "BBlast Final Star",
	[144] = "Drop Rainbow Coin",
	[145] = "Rainbow Coin Get",
	[146] = "Normal Star",
	[147] = "Bean Get",
	[148] = "Crystal Caves (Army Dillo)",
	[149] = "Creepy Castle (Kut Out)",
	[150] = "Creepy Castle (Dungeon w/out Chains)",
	[151] = "Banana Medal Get",
	[152] = "K Rool's Battle",
	[153] = "Fungi Forest (Lobby)",
	[154] = "Crystal Caves (Lobby)",
	[155] = "Creepy Castle (Lobby)",
	[156] = "Hideout Helm (Lobby)",
	[157] = "Creepy Castle (Trash Can)",
	[158] = "End Sequence",
	[159] = "K-Lumsy Ending",
	[160] = "Jungle Japes",
	[161] = "Jungle Japes (Cranky's Area)",
	[162] = "K Rool Takeoff",
	[163] = "Crystal Caves (Baboon Blast)",
	[164] = "Fungi Forest (Baboon Blast)",
	[165] = "Creepy Castle (Baboon Blast)",
	[166] = "DK Isles (Snide's Room)",
	[167] = "K Rool's Entrance",
	[168] = "Monkey Smash",
	[169] = "Fungi Forest (Rabbit Race)",
	[170] = "Game Over",
	[171] = "Wrinkly Kong",
	[172] = "100th CB Get",
	[173] = "K Rool's Defeat",
	[174] = "Nintendo Logo"
}

function getTriggerTypeName(index)
	return trigger_types[index] or "Type 0x"..bizstring.hex(index)
end

function getSongName(index)
	return songs[index] or "Song 0x"..bizstring.hex(index)
end

function getTOrF(value)
	if value == 0 then
		return "False"
	end
	return "True"
end

function parseObjectScript(objectAddr)
	behaviour_pointer = derefPtr(objectAddr + 0x7C)
	if behaviour_pointer ~= 0 then
		behaviour_script = derefPtr(behaviour_pointer + 0xA0)
		if behaviour_script ~= 0 then
			conditional_count = mainmemory.readbyte(behaviour_script)
			master_loop_control = true
			while master_loop_control do
				if conditional_count ~= 0 then
					scriptCommandAddr = behaviour_script + 2
					for i = 1, conditional_count do
						grabConditional(0, scriptCommandAddr,behaviour_pointer,0)
						scriptCommandAddr = scriptCommandAddr + 8
					end
				end
				execution_count = mainmemory.readbyte(behaviour_script + 0x2A)
				if execution_count ~= 0 then
					scriptCommandAddr = behaviour_script + 0x2C
					for i = 1, execution_count do
						grabExecutional(0, scriptCommandAddr, behaviour_pointer, 0)
						scriptCommandAddr = scriptCommandAddr + 8
					end
				end
				if conditional_count ~= 0 then
					for i = 1, conditional_count do
						display("}")
					end
				end
				behaviour_script = derefPtr(behaviour_script + 0x4C)
				if behaviour_script == 0 then
					master_loop_control = false
				end
				conditional_count = mainmemory.readbyte(behaviour_script)
				emu.yield();
			end
		end
	end
end

function display(str)
	print(str)
end

function grabConditional(param_1, ScriptCommand,behaviour,param_3)
	-- Seem to be if statements
	functionType = bit.band(mainmemory.read_u16_be(ScriptCommand + command_struct.command),0x7FFF)
	inverseFlag = bit.band(mainmemory.read_u16_be(ScriptCommand + command_struct.command),0x8000)
	inverseFlagChar = ""
	inverseFlagInvertedChar = "!"
	if inverseFlag ~= 0 then
		inverseFlag = 1;
		inverseFlagChar = "!"
		inverseFlagInvertedChar = ""
	else
		inverseFlagChar = ""
		inverseFlagInvertedChar = "!"
	end
	if functionType == 0 then
		display(
			"if ("
			..inverseFlagChar
			.."true) {"
		)
	elseif functionType == 1 then
		display(
			"if (*(byte *)(behaviour + 0x"
			..bizstring.hex(mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2) + 0x48)
			..") "
			..inverseFlagChar
			.."== "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..") {"
		)
	elseif functionType == 2 then
		display("x2_successful = 0")
		display("x2_focusedPlayerNumber = 0")
		display("if (player_count != 0) {")
		display("do {")
		display("x2_focusedPlayerNumber_ = x2_focusedPlayerNumber")
		display("x2_focusedPlayerNumber = (x2_focusedPlayerNumber_ + 1) & 0xFF")
		display("if (*(byte *)(character_change_pointer[x2_focusedPlayerNumber_]->does_player_exist) != 0) {")
		display("x2_focusedPlayerPointer = *(int *)(character_change_pointer[x2_focusedPlayerNumber_)]->character_pointer)")
		display("if (*(byte *)(x2_focusedPlayerPointer->locked_to_pad) == 1) {")
		display("if (param_4 == *(short *)(x2_focusedPlayerPointer->standingOnObjectM2Index)) {")
		display("x2_successful = 1")
		display("}")
		display("}")
		display("}")
		display("} while x2_focusedPlayerNumber < player_count")
		display("}")
		display("if (x2_successful "..inverseFlagChar.."== 1) {")
	elseif functionType == 3 then
		display("if (1 == 0) {")
	elseif functionType == 4 then
		display(
			"if (*(ushort *)(behaviour + 0x"
			..bizstring.hex((mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2) * 2) + 0x44)
			..") "
			..inverseFlagChar
			.."== "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..") {"
		)
	elseif functionType == 5 then
		display(
			"if (FUN_806425FC("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..") "
			..inverseFlagInvertedChar
			.."== 0) {"
		)
	elseif functionType == 6 then
		display(
			"if (FUN_"
			..bizstring.hex(0x80748048 + (mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1) * 4))
			.."(behaviour,param_4,"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3)
			..") "
			..inverseFlagInvertedChar
			.."== 0) {"
		)
	elseif functionType == 7 then
		display(
			"if (FUN_80642500(behaviour + 0x14,"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..") "
			..inverseFlagInvertedChar
			.."== 0) {"
		)
	elseif functionType == 8 then
		display(
			"if (*(byte *)(behaviour + 0x51) "
			..inverseFlagInvertedChar
			.."== 0) {"
		)
	elseif functionType == 9 then
		display(
			"if (*(byte *)(behaviour + 0x52) "
			..inverseFlagInvertedChar
			.."== 0) {"
		)
	elseif functionType == 10 then
		display("xA_successful = 0")
		display("xA_focusedPlayerNumber = 0")
		display("if (player_count != 0) {")
		display("do {")
		display("xA_focusedPlayerNumber_ = xA_focusedPlayerNumber")
		display("xA_focusedPlayerNumber = (xA_focusedPlayerNumber_ + 1) & 0xFF")
		display("if (*(byte *)(character_change_pointer[xA_focusedPlayerNumber_]->does_player_exist) != 0) {")
		display("xA_focusedPlayerPointer = *(int *)(character_change_pointer[xA_focusedPlayerNumber_]->character_pointer)")
		display("xA_successful = 0")
		display("if (*(byte *)(xA_focusedPlayerPointer->locked_to_pad) == 2) {")
		display("if (param_4 == *(short *)(xA_focusedPlayerPointer->standingOnObjectM2Index)) {")
		display("xA_successful = 1")
		display("}")
		display("}")
		display("}")
		display("} while (xA_focusedPlayerNumber < player_count)")
		display("}")
		display("if (xA_successful "..inverseFlagChar.."== 1) {")
	elseif functionType == 11 then
		display("xB_successful = 0")
		display("xB_focusedPlayerNumber = 0")
		display("if (player_count != 0) {")
		display("do {")
		display("xB_focusedPlayerNumber_ = xB_focusedPlayerNumber")
		display("xB_focusedPlayerNumber = (xB_focusedPlayerNumber_ + 1) & 0xFF")
		display("if (*(byte *)(character_change_pointer[xB_focusedPlayerNumber_]->does_player_exist) != 0) {")
		display("xB_focusedPlayerPointer = *(int *)(character_change_pointer[xB_focusedPlayerNumber_]->character_pointer)")
		display("if (*(byte *)(xB_focusedPlayerPointer->locked_to_pad) == 3) {")
		display(
			"if (*(byte *)(xB_focusedPlayerPointer->unk0x12F == "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..")) {"
		)
		display("if (param_4 == *(short *)(xB_focusedPlayerPointer->standingOnObjectM2Index)) {")
		display("xB_successful = 1")
		display("}")
		display("}")
		display("}")
		display("}")
		display("} while (xB_focusedPlayerNumber < player_count)")
		display("}")
		display("if (xB_successful "..inverseFlagChar.."== 1) {")
	elseif functionType == 12 then
		display(
			"if ("
			..inverseFlagInvertedChar
			.."(((((FLOAT_807F621C == FLOAT_807F61FC) && (FLOAT_807F6220 == 1729.11706543)) && ((FLOAT_807F6224 == 3433.54956055 && ((FLOAT_807F6228 == 330 && (FLOAT_807F622C == 170)))))) && (FLOAT_807F6230 == 0)) && (FLOAT_807F6234 == 1))) {"
		)
	elseif functionType == 13 then
		display("xC_successful = 0")
		display("xC_focusedPlayerNumber = 0")
		display("if (player_count != 0) {")
		display("do {")
		display("xC_focusedPlayerNumber_ = xC_focusedPlayerNumber")
		display("xC_focusedPlayerNumber = (xC_focusedPlayerNumber_ + 1) & 0xFF")
		display("if (*(byte *)(character_change_pointer[xC_focusedPlayerNumber_]->does_player_exist) != 0) {")
		display("xC_focusedPlayerPointer = *(int *)(character_change_pointer[xC_focusedPlayerNumber_]->character_pointer)")
		display("if (*(byte *)(xC_focusedPlayerPointer->locked_to_pad) == 1) {")
		display("if (param_4 == *(short *)(xC_focusedPlayerPointer->standingOnObjectM2Index)) {")
		display(
			"if (param_4 == *(byte *)(xC_focusedPlayerPointer->unk0x10E == "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..")) {"
		)
		display("xC_successful = 1")
		display("}")
		display("}")
		display("}")
		display("}")
		display("} while (xC_focusedPlayerNumber < player_count)")
		display("}")
		display("if (xC_successful "..inverseFlagChar.."== 1) {")
	elseif functionType == 14 then
		display(
			"if (FUN_80641F70(param_1,"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..")"
			..inverseFlagInvertedChar
			.."== 0) {"
		)
	elseif functionType == 15 then
		display(
			"if (FUN_80723C98(*(word *) (behaviour + 0x38)) "
			..inverseFlagInvertedChar
			.."== 0) {"
		)
	elseif functionType == 16 then
		x10_conditional = "";
		x10_conditional_2 = "";
		if mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2) ~= -1 then
			x10_conditional = "(*(byte *)(behaviour + 0x5C) != "..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)..") || "
		end
		if mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1) ~= 0 then
			x10_conditional_2 = "(FUN_8067ACC0(*(ushort *)(behaviour + 0x5E)) & "..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)..")"
			display("if ((((*(byte *)(behaviour + 0x5C) == 0) || "
				..x10_conditional
				..x10_conditional_2
				..")) || (FUN_806419F8() == 0)) {"
			)
			display("x10_uvar9 = 0")
			display("} else {")
			display("FUN_80641724(ObjectModel2ArrayPointer[param_4].object_type)")
			display("x10_uvar9 = 1")
			display("}")
			display("if (x10_uvar9 "..inverseFlagChar.."== 1) {")
		else
			if inverseFlag == 1 then
				display("if (true) {")
			else
				display("if (1 == 0) {")
			end
		end
	elseif functionType == 17 then
		display("x11_successful = false")
		display("if (loadedActorCount != 0) {")
		display("x11_focusedArraySlot = &loadedActorArray")
		display("x11_focusedActor = loadedActorArray")
		display("while (true) {")
		display("x11_focusedArraySlot = x11_focusedArraySlot + 8")
		display("if ((*(uint *)(x11_focusedActor->object_properties_bitfield) & 0x2000) == 0) {")
		display("if (*(int *)(x11_focusedActor->actor_type) == "..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)..") {")
		display("if (x11_focusedActor->locked_to_pad == 1) {")
		display("if (param_4 == *(short *)(x11_focusedActor->standingOnObjectM2Index)) {")
		display("x11_successful = true")
		display("}")
		display("}")
		display("}")
		display("}")
		display("if ((&loadedActorArray + (loadedActorCount * 8) <= x11_focusedArraySlot) || (x11_successful)) break;")
		display("}")
		display("}")
		display("if ("..inverseFlagChar.."x11_successful) {")
	elseif functionType == 18 then
		display("x12_successful = false")
		display("if (loadedActorCount != 0) {")
		display("x12_focusedArraySlot = &loadedActorArray")
		display("x12_focusedActor = loadedActorArray")
		display("while (true) {")
		display("x12_focusedArraySlot = x12_focusedArraySlot + 8")
		display("if ((*(uint *)(x12_focusedActor->object_properties_bitfield) & 0x2000) == 0) {")
		display("if (*(int *)(x12_focusedActor->actor_type) == "..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)..") {")
		display("if (x12_focusedActor->locked_to_pad == 1) {")
		display("if (param_4 == *(short *)(x12_focusedActor->standingOnObjectM2Index)) {")
		display("if (*(short *)(x12_focusedActor->unk10E) == "..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)..") {")
		display("x12_successful = true")
		display("}")
		display("}")
		display("}")
		display("}")
		display("}")
		display("if ((&loadedActorArray + (loadedActorCount * 8) <= x12_focusedArraySlot) || (x12_successful)) break;")
		display("x12_focusedActor = *x12_focusedArraySlot")
		display("}")
		display("}")
		display("if ("..inverseFlagChar.."x12_successful) {")
	elseif functionType == 19 then
		display(
			"if (isPlayerWithinDistanceOfObject("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..") "
			..inverseFlagInvertedChar
			.."== 0) {"
		)
	elseif functionType == 20 then
		display("x14_successful_count = 0")
		display("x14_focusedArraySlot = &loadedActorArray")
		display("if (loadedActorCount != 0) {")
		display("x14_focusedActor = loadedActorArray")
		display("while (true) {")
		display("x14_focusedArraySlot = x14_focusedArraySlot + 8")
		display("if ((*(uint *)(x14_focusedActor->object_properties_bitfield) & 0x2000) == 0) {")
		display("if (*(int *)(x14_focusedActor->actor_type) == "..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)..") {")
		display("if (x14_focusedActor->locked_to_pad == 1) {")
		display("if (param_4 == *(short *)(x14_focusedActor->standingOnObjectM2Index)) {")
		display("if (*(short *)(x14_focusedActor->unk10E) == "..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)..") {")
		display("x14_successful_count = true")
		display("}")
		display("}")
		display("}")
		display("}")
		display("}")
		display("if ((&loadedActorArray + (loadedActorCount * 8) <= x14_focusedArraySlot)) break;")
		display("x14_focusedActor = *x14_focusedArraySlot")
		display("}")
		display("}")
		display("if (x14_successful_count "..inverseFlagChar.."== "..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3)..") {")
	elseif functionType == 21 then
		display(
			"if (FUN_80650D04(param_4,"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..") "
			..inverseFlagInvertedChar
			.."== 0) {"
		)
	elseif functionType == 22 then
		display(
			"if ((LevelStateBitfield & 0x"
			..bizstring.hex((mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1) * 0x10000) + mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2))
			..") != 0) {")
	elseif functionType == 23 then
		display("x17_successful = 0")
		display("x17_focusedPlayerNumber = 0")
		display("if (player_count != 0) {")
		display("do {")
		display("x17_focusedPlayerNumber_ = x17_focusedPlayerNumber")
		display("x17_focusedPlayerNumber = (x17_focusedPlayerNumber_ + 1) & 0xFF")
		display("if (*(byte *)(character_change_pointer[x17_focusedPlayerNumber_]->does_player_exist) != 0) {")
		display("x17_focusedPlayerPointer = *(int *)(character_change_pointer[x17_focusedPlayerNumber_]->character_pointer)")
		display("if (*(byte *)(x17_focusedPlayerPointer->control_state) == "..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)..") {")
		if mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2) == 0 then
			display("x17_successful = 1")
		else
			display("if (x17_focusedPlayerPointer->control_state_progress == "..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)..") {")
			display("x17_successful = 1")
			display("}")
		end
		display("}")
		display("}")
		display("} while (x17_focusedPlayerNumber < player_count)")
		display("}")
		display("if (x17_successful "..inverseFlagChar.."== 1) {")
	elseif functionType == 24 then
		display("x18_successful = 0")
		display("if (*(byte *)(behaviour + 0x5C) != 0) {")
		if mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2) ~= -1 then
			display("if (*(byte *)(behaviour + 0x5C) == "..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2).."){")
		end
		display("if ((*(ushort *)(behaviour + 0x5E) == "..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)..") && FUN_806419F8() != 0) {")
		display("FUN_80641724(ObjectModel2Array[param_4].object_type)")
		display("x18_successful = 1")
		display("}")
		if mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2) ~= -1 then
			display("}")
		end
		display("}")
		display("if (x18_successful "..inverseFlagChar.."== 1) {")
	elseif functionType == 25 then
		display(
			"if (*(int *)(PlayerPointer->ActorType) "
			..inverseFlagChar
			.."== "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..") {"
		)
	elseif functionType == 26 then
		display(
			"if (*(byte *)(character_change_pointer->unk0x2C0) "
			..inverseFlagChar
			.."== "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..") {")
	elseif functionType == 27 then
		display("if (*(byte *)(character_change_pointer->unk0x2C1) "..inverseFlagInvertedChar.."== 0){")
	elseif functionType == 28 then
		display("x1C_svar6 = 80650a70()")
		if mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2) == 0 then
			if inverseFlag == 0 then
				display("if (x1C_svar6 < "..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3)..") {")
			else
				display("if (x1C_svar6 >= "..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3)..") {")
			end
		elseif mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2) == 1 then
			if inverseFlag == 0 then
				display("if (x1C_svar6 >= "..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3)..") {")
			else
				display("if (x1C_svar6 < "..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3)..") {")
			end
		else
			display("if (1 == 0) {")
		end
	elseif functionType == 29 then
		if mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1) == 0 then
			if inverseFlag == 0 then
				display(
					"if (*(byte *)(behaviour + 0x"
					..bizstring.hex(0x48 + mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3))
					..") < "
					..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
					..") {"
				)
			else
				display(
					"if (*(byte *)(behaviour + 0x"
					..bizstring.hex(0x48 + mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3))
					..") >= "
					..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
					..") {"
				)
			end
		elseif mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1) == 1 then
			if inverseFlag == 0 then
				display(
					"if (*(byte *)(behaviour + 0x"
					..bizstring.hex(0x48 + mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3))
					..") >= "
					..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
					..") {"
				)
			else
				display(
					"if (*(byte *)(behaviour + 0x"
					..bizstring.hex(0x48 + mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3))
					..") < "
					..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
					..") {"
				)
			end
		else
			display("if (1 == 0) {")
		end
	elseif functionType == 30 then
		display("if ((FUN_80726D7C() & 0xFF) "..inverseFlagInvertedChar.."== 0){")
	elseif functionType == 31 then
		if inverseFlag == 0 then
			display("if (1 == 0) {")
		else
			display("if (true) {")
		end
	elseif functionType == 32 then
		display("if ((FUN_806422D8() & 0xFF) "..inverseFlagInvertedChar.."== 0){")
	elseif functionType == 33 then
		display("x21_successful = 0")
		display("x21_focusedPlayerNumber = 0")
		display("if (player_count != 0) {")
		display("do {")
		display("x21_focusedPlayerNumber_ = x21_focusedPlayerNumber")
		display("x21_focusedPlayerNumber = (x21_focusedPlayerNumber_ + 1) & 0xFF")
		display("if (*(byte *)(character_change_pointer[x21_focusedPlayerNumber_]->does_player_exist) != 0) {")
		display("21_focusedPlayerPointer = *(int *)(character_change_pointer[x21_focusedPlayerNumber_]->character_pointer)")
		display(
			"if (*(byte *)(x21_focusedPlayerPointer->control_state_progress) == "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..") {"
		)
		display("x21_successful = 1")
		display("}")
		display("}")
		display("}")
		display("}")
		display("if (x21_successful "..inverseFlagChar.."== 1) {")
	elseif functionType == 34 then
		display(
			"if (touchingModelTwoById(0x"
			..bizstring.hex(mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1))
			..") "
			..inverseFlagInvertedChar
			.."== 0) {"
		)
	elseif functionType == 35 then
		display("if (CutsceneActive "..inverseFlagChar.."== 1) {")
	elseif functionType == 36 then
		display("x24_focusedActor = getSpawnerTiedActor("..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)..",0)")
		display(
			"if (*(byte *)(x24_focusedActor->control_state) "
			..inverseFlagChar
			.."== "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..") {"
		)
	elseif functionType == 37 then
		display(
			"if ("
			..inverseFlagChar
			.."(*(byte *)CurrentCollectableBase->SlamLvl => "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..")) {"
		)
	elseif functionType == 38 then
		display(
			"if ((*(uint *)(PlayerPointer->unk0x368) & 0x"
			..bizstring.hex((mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1) * 0x10000) + mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2))
			..") "
			..inverseFlagInvertedChar
			.."== 0) {"
		)
	elseif functionType == 39 then
		display(
			"if ((*(uint *)(PlayerPointer->effectBitfield) & 0x"
			..bizstring.hex((mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1) * 0x10000) + mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2))
			..") "
			..inverseFlagInvertedChar
			.."== 0) {"
		)
	elseif functionType == 40 then
		display(
			"if ((*(byte *)(behaviour + 0x9A) & 1) "
			..inverseFlagChar
			.."== 0) {"
		)
	elseif functionType == 41 then
		display(
			"if (FUN_806423A8("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3)
			..") "
			..inverseFlagInvertedChar
			.."== 0) {"
		)
	elseif functionType == 42 then
		if inverseFlag == 0 then
			display("if (BYTE_807F61F8 != 0 || *(byte *)(PTR_0x807F61F0->control_state) == 5) {")
		else
			display("if (BYTE_807F61F8 == 0 && *(byte *)(PTR_0x807F61F0->control_state) != 5) {")
		end
	elseif functionType == 43 then
		display(
			"if (BYTE_807F61F8 "
			..inverseFlagInvertedChar
			.."== 0) {"
		)
	elseif functionType == 44 then
		display(
			"if (FUN_80689BAC("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..") "
			..inverseFlagInvertedChar
			.."== 0) {"
		)
	elseif functionType == 45 then
		display(
			"if (checkFlag(0x"
			..bizstring.hex(math.floor(mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1) / 8))
			..">"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1) % 8
			..",'Permanent') "
			..inverseFlagInvertedChar
			.."== 0) {"
		)
	elseif functionType == 46 then
		display(
			"if (FUN_80689B10("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..",0,0) "
			..inverseFlagChar
			.."== "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..") {")
	elseif functionType == 47 then
		display("if ((FUN_80726DC0() & 0xFF) "..inverseFlagInvertedChar.."== 0) {")
	elseif functionType == 48 then
		display(
			"if (*(byte *)(PlayerPointer->unk0xD1) "
			..inverseFlagChar
			.."== "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..") {"
		)
	elseif functionType == 49 then
		display("x31_ivar10_4 = indexOfNextObj(&WORD_807F6240["..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1).."])")
		display(
			"if (ObjectModel2ArrayPointer[x31_ivar10_4]->behaviour_pointer[0x"
			..bizstring.hex(0x48 + mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3))
			.."] "
			..inverseFlagChar
			.."== "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..") {"
		)
	elseif functionType == 50 then
		display(
			"if (*(ushort *)PreviousMap "
			..inverseFlagChar
			.."== "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..") {"
		)
	elseif functionType == 51 then
		if mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1) == 0 then
			if inverseFlag == 0 then
				display(
					"if ("
					..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
					.."< FUN_80614A54(PlayerPointer)) {"
				)
			else
				display(
					"if ("
					..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
					..">= FUN_80614A54(PlayerPointer)) {"
				)
			end
		elseif mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1) == 1 then
			if inverseFlag == 0 then
				display(
					"if ("
					..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
					..">= FUN_80614A54(PlayerPointer)) {"
				)
			else
				display(
					"if ("
					..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
					.."< FUN_80614A54(PlayerPointer)) {"
				)
			end
		else
			display("if (1 == 0) {")
		end
	elseif functionType == 52 then
		display("x34_uvar4 == FUN_806C8D2C("..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)..")")
		if inverseFlag == 0 then
			display(
				"if ("
				..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
				.."<= &character_collectable_base[(BYTE_807FC929 * 0x5E) + (0x306 * x34_uvar4)] {"
			)
		else
			display(
				"if ("
				..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
				.."> &character_collectable_base[(BYTE_807FC929 * 0x5E) + (0x306 * x34_uvar4)] {"
			)
		end
	elseif functionType == 53 then
		display(
			"if (*(byte *)PlayerPointer->0xD0 "
			..inverseFlagChar
			.."== "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..") {"
		)
	elseif functionType == 54 then
		display(
			"if (checkFlag(0x"
			..bizstring.hex(math.floor(mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1) / 8))
			..">"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1) % 8
			..",'Temporary') "
			..inverseFlagInvertedChar
			.."== 0) {"
		)
	elseif functionType == 55 then
		display("FUN__80650D8C(param_4,"..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)..",austack30,austack36)")
		display("if (austack30[0] "..inverseFlagChar.."== "..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)..") {")
	elseif functionType == 56 then
		display(
			"if ("
			..inverseFlagChar
			.."(*(byte *)Character < 5)) {"
		)
	elseif functionType == 57 then
		display(
			"if (("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			.."& *(ushort *)PlayerPointer->CollisionQueue->TypeBitfield) "
			..inverseFlagInvertedChar
			.."== 0) {"
		)
	elseif functionType == 58 then
		display(
			"if (((1 << "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..") & BYTE_807F693E) "
			..inverseFlagInvertedChar
			.."== 0) {"
		)
	elseif functionType == 59 then
		display(
			"if (checkFlag(0x"
			..bizstring.hex(math.floor(mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1) / 8))
			..">"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1) % 8
			..",'Global') "
			..inverseFlagInvertedChar
			.."== 0) {"
		)
	elseif functionType == 60 then
		display(
			"if (PlayerPointer->chunk "
			..inverseFlagChar
			.."== "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..") {"
		)
	elseif functionType == 61 then
		display(
			"if (BYTE_807F6903 "
			..inverseFlagInvertedChar
			.."== 0) {"
		)
	else
		display("if (["
		..functionType
		..","
		..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
		..","
		..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
		..","
		..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3)
		.."]) {")
	end
end

function grabExecutional(param_1, ScriptCommand,behaviour,param_3)
	functionType = mainmemory.read_u16_be(ScriptCommand + command_struct.command)
	if functionType == 0 then
		display(
			"FUN_80642748("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..","
			..behaviour
			..")"
		)
	elseif functionType == 1 then
		display(
			"*(byte *)(behaviour + 0x"
			..bizstring.hex(mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2) + 0x4B)
			..") = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
		)
	elseif functionType == 2 then
		display(
			"FUN_80723284("
			..mainmemory.read_u32_be(behaviour + 0x38)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..")"
		)
	elseif functionType == 3 then
		if mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1) == 0 then
			display(
				"*(short *)(behaviour + 0x"
				..bizstring.hex((mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3) * 2) + 0x44)
				..") = "
				..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			)
		else
			display(
				"*(short *)(behaviour + 0x"
				..bizstring.hex((mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3) * 2) + 0x44)
				..") = *(short *)(behaviour + 0x"
				..bizstring.hex((mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2) * 4) + 0x14)
				..")"
			)
		end
	elseif functionType == 4 then
		display(
			"FUN_80723484(*(int *)(behaviour + 0x38))"
		)
		display(
			"FUN_807238D4(*(int *)(behaviour + 0x38),0x807F621C,0x807F6220,0x807F6224)"
		)
	elseif functionType == 5 then
		display(
			"FUN_806418E8("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..",behaviour)"
		)
	elseif functionType == 6 then
		display(
			"*(float *)(behaviour + 0x"
			..bizstring.hex((mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1) * 4) + 0x14)
			..") = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2) / 10
		)
	elseif functionType == 7 then
		display(
			"*(code *)(0x"
			..bizstring.hex(0x80747E70 + (mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1) * 4))
			..")(behaviour,param_4,"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3)
			..")"
		)
	elseif functionType == 8 then
		display(
			"FUN_80642844("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			.."behaviour)"
		)
	elseif functionType == 9 then
		display(
			"if ((FLOAT_807F621C != FLOAT_807F61FC) || (FLOAT_807F6224 != 3433.54956055)) {"
		)
		display(
			"FUN_80642480("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..")"
		)
		display("}")
	elseif functionType == 0xA then
		display(
			"*(byte *)(behaviour + 0x50) = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
		)
		display(
			"*(float *)(behaviour + 0x78) = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2) / 100
		)
		display(
			"*(float *)(behaviour + 0x7C) = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3) / 100
		)
	elseif functionType == 0xB then
		display(
			"*(short *)(behaviour + 0x80) = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
		)
		display(
			"*(short *)(behaviour + 0x82) = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
		)
	elseif functionType == 0xC then
		display(
			"*(short *)(behaviour + 0x84) = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
		)
		display(
			"*(short *)(behaviour + 0x86) = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
		)
	elseif functionType == 0xD then
		display(
			"*(short *)(behaviour + 0x88) = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
		)
		display(
			"*(short *)(behaviour + 0x8A) = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
		)
	elseif functionType == 0xE then
		display(
			"if (*(short *)(behaviour + 0x"
			..bizstring.hex((bit.band(mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1),1) * 2) + 0x10)
			..") < 0) {"
		)
		display(
			"*(short *)(behaviour + 0x"
			..bizstring.hex((bit.band(mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1),1) * 2) + 0x10)
			..") = FUN_80605044(param_4,"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..bit.band(mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3),0x7F)
			..","
			..bit.band(mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2),2)
			..")"
		)
		display("}")
	elseif functionType == 0xF then
		xF_ivar5 = mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
		if mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2) < 0 then
			xF_ivar5 = xF_ivar5 + 0x7F
		end
		xF_uvar9 = bit.band(bit.rshift(xF_ivar5,7),0xFF)
		xF_bvar15 = xF_uvar9
		xF_ivar5 = mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3)
		if mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3) < 0 then
			xF_ivar5 = xF_ivar5 + 0x7F
		end
		xF_uvar14 = bit.band(bit.rshift(xF_ivar5,7),0xFF)
		if xF_uvar9 == 0 then
			xF_bvar15 = 0x7F
		end
		if xF_uvar14 == 0 then
			xF_uvar14 = 0xFF
		end
		display(
			"FUN_806085DC(param_4,"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..xF_uvar14
			..","
			..xF_bvar15
			..")"
		)
	elseif functionType == 0x10 then
		display(
			"x10_temp = *(short *)(behaviour + 0x"
			..bizstring.hex((mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2) * 2) + 0x10)
			..")"
		)
		display(
			"if (-1 < x10_temp) {"
		)
		display("FUN_80605380(x10_temp)")
		display(
			"*(short *)(behaviour + 0x"
			..bizstring.hex((mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2) * 2) + 0x10)
			..") = 0xFFFF"
		)
		display("}")
	elseif functionType == 0x11 then
		display(
			"FUN_806508B4(param_4,"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..")"
		)
	elseif functionType == 0x12 then
		display(
			"FUN_8065092C(param_4,"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..")"
		)
	elseif functionType == 0x13 then
		display(
			"FUN_80650998(param_4,"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..")"
		)
	elseif functionType == 0x14 then
		display(
			"FUN_80650A04(param_4,"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..")"
		)
	elseif functionType == 0x15 then
		display(
			"FUN_80650b50(param_4,"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..")"
		)
	elseif functionType == 0x16 then
		display(
			"FUN_80650BBC(param_4,"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..")"
		)
	elseif functionType == 0x17 then
		display(
			"FUN_80650C28(param_4,"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..")"
		)
	elseif functionType == 0x18 then
		display(
			"FUN_80650C98(param_4,"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..")"
		)
	elseif functionType == 0x19 then
		display(
			"setCharacterChangeParameters("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..",0,0)"
		)
	elseif functionType == 0x1A then
		display(
			"FUN_80650AD8(param_4,"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..",("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3)
			.."/(5.333806864e-315)))"
		)
	-- functionTypes 0x1B & 0x1C
	elseif functionType == 0x1D then
		display(
			"FUN_80642844("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..",behaviour)"
		)
	elseif functionType == 0x1E then
		display(
			"FUN_80642748("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..",behaviour)"
		)
	elseif functionType == 0x1F then
		display(
			"FUN_807232EC(*(int *)(behaviour + 0x38),"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..")"
		)
	elseif functionType == 0x20 then
		display(
			"FUN_80723380(*(int *)(behaviour + 0x38),"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..")"
		)
	elseif functionType == 0x21 then
		display(
			"FUN_80723320(*(int *)(behaviour + 0x38),"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..")"
		)
	elseif functionType == 0x22 then
		display(
			"*(int *)(behaviour + 0x38) = FUN_80723020(FLOAT_807F6220,FLOAT_807F6224,"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3)
			..")"
		)
	elseif functionType == 0x23 then
		display(
			"FUN_80723428(*(int *)(behaviour + 0x38))"
		)
		display(
			"*(int *)(behaviour + 0x38) = 0xFFFFFFFF"
		)
	elseif functionType == 0x24 then
		display(
			"FUN_8072334C(*(int *)(behaviour + 0x38),"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..")"
		)
	elseif functionType == 0x25 then
		display(
			"playCutsceneFromModelTwoScript(behaviour,"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3)
			..")"
		)
	elseif functionType == 0x26 then
		display(
			"FUN_8064199C(behaviour,"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..")"
		)
	-- functionTypes 0x27 > 0x2C
	elseif functionType == 0x2D then
		display("x2d_counter = 0")
		display("x2d_PTR_focusedLoadedActor = &PTR_DAT_807FB930")
		display("if (loadedActorCount != 0) {")
		display("do {")
		display("x2d_ADDR_focusedLoadedActor = *x2d_PTR_focusedLoadedActor")
		display("x2d_counter = x2d_counter + 1")
		display("if ((*(uint *)(x2d_ADDR_focusedLoadedActor->object_properties_bitfield_1) & 0x2000) == 0) {")
		display("if (x2d_ADDR_focusedLoadedActor->locked_to_pad == 0x1) {")
		display("if (param_4 == *(word *)(x2d_ADDR_focusedLoadedActor->unk0x10C)) {")
		if mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1) == 0 then
			display("*(ushort *)(x2d_ADDR_focusedLoadedActor->unk0x68) = *(ushort *)(x2d_ADDR_focusedLoadedActor->unk0x68) & 0xFFFB")
		else
			display("*(ushort *)(x2d_ADDR_focusedLoadedActor->unk0x68) = *(ushort *)(x2d_ADDR_focusedLoadedActor->unk0x68) | 4")
		end
		display("}")
		display("}")
		display("}")
		display("x2d_PTR_focusedLoadedActor = x2d_PTR_focusedLoadedActor + 8")
		display("x2d_finishedArray = x2d_counter < loadedActorCount")
		display("} while(x2d_finishedArray)")
		display("}")
	elseif functionType == 0x2E then
		display(
			"FUN_80651BC0("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..")"
		)
	elseif functionType == 0x2F then
		display(
			"FUN_8060B49C(PlayerPointer,"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..")"
		)
	elseif functionType == 0x30 then
		display(
			"InitMapChange("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..",0)"
		)
	elseif functionType == 0x31 then
		if bit.band(mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3),0x100) ~= 0 then
			display("SetIntroStoryPlaying(2)")
			display("setNextTransitionType('Fade (Wrong Cutscene)')")
		end
		if bit.band(mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3),0xFF) == 0 then
			display(
				"InitMapChange_TransferredActor("
				..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
				..","
				..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
				..",0,0)"
			)
		else
			if bit.band(mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3),0xFF) == 1 then
				display(
					"InitMapChange_TransferredActor("
					..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
					..","
					..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
					..",0,1)"
				)
			elseif bit.band(mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3),0xFF) == 2 then
				display(
					"InitMapChange_TransferredActor("
					..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
					..","
					..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
					..",0,3)"
				)
			else
				display(
					"InitMapChange_TransferredActor("
					..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
					..","
					..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
					..",0,0)"
				)
			end
		end
	elseif functionType == 0x32 then
		display(
			"InitMapChange_ParentMap("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..")"
		)
	elseif functionType == 0x33 then
		display(
			"FUN_8062B86C("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..",(float) "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..",(float) "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3) / 100
			..")"
		)
	elseif functionType == 0x34 then
		display(
			"FUN_8062B8A4("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..",(float) "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..",(float) "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3) / 100
			..")"
		)
	elseif functionType == 0x35 then
		display(
			"FUN_80641C98("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..",param_4)"
		)
	elseif functionType == 0x36 then
		display(
			"FUN_80641BCC("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..",param_4)"
		)
	-- functionTypes 0x37
	elseif functionType == 0x38 then
		display(
			"FUN_80651be0("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3)
			..")"
		)
	elseif functionType == 0x39 then
		display(
			"*(byte *)(behaviour + 0x4F) = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
		)
	-- functionTypes 0x3A > 0x3C
	elseif functionType == 0x3D then
		display(
			"*(byte *)(behaviour + 0x67) = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
		)
	elseif functionType == 0x3E then
		display(
			"*(byte *)(behaviour + 0x6F) = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
		)
	elseif functionType == 0x3F then
		display(
			"*(byte *)(behaviour + 0x6E) = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
		)
	elseif functionType == 0x40 then
		display(
			"*(int *)LevelStateBitfield = *(int *)LevelStateBitfield | 0x"
			..bizstring.hex((mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1) * 0x10000) + mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2))
		)
	elseif functionType == 0x41 then
		display(
			"WORD_807F6904 = 1"
		)
	elseif functionType == 0x42 then
		display(
			"FUN_80634CC8(param_4,"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3)
			..")"
		)
	elseif functionType == 0x43 then
		display(
			"if ("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			.." == 1) {"
		)
		display(
			"*(int *)(behaviour + 0x8) = *(int *)(behaviour + 0x"
			..bizstring.hex((mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2) * 4) + 0x14)
			..")"
		)
		display(
			"*(int *)(behaviour + 0xC) = *(int *)(behaviour + 0x"
			..bizstring.hex((mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3) * 4) + 0x14)
			..")"
		)
		display("}")
		display("else {")
		display(
			"*(float *)(behaviour + 0x8) = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2) / 10
		)
		display(
			"*(float *)(behaviour + 0xC) = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3) / 10
		)
		display("}")
	elseif functionType == 0x44 then
		display(
			"WORD_807F6906 = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
		)
		display(
			"WORD_807F6908 = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
		)
	elseif functionType == 0x45 then
		display(
			"*(byte *)(behaviour + 0x60) = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
		)
		display(
			"*(ushort *)(behaviour + 0x62) = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
		)
		display(
			"*(byte *)(behaviour + 0x66) = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3)
		)
	elseif functionType == 0x46 then
		display(
			"*(byte *)(behaviour + 0x70) = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
		)
	elseif functionType == 0x47 then
		display(
			"*(byte *)(behaviour + 0x71) = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
		)
	elseif functionType == 0x48 then
		display(
			"FUN_80604BE8(*(byte *)(behaviour + 0x"
			..bizstring.hex((mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1) * 2) + 0x11)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			.." / 5.232460324e-315,"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3)
			..")"
		)
	elseif functionType == 0x49 then
		display(
			"FUN_8067ABC0("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3)
			..",FLOAT_807F621C,FLOAT_807F6220,FLOAT_807F6224)"
		)
	elseif functionType == 0x4A then
		display(
			"FUN_8063393C(param_4,1,"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..")"
		)
	elseif functionType == 0x4B then
		display(
			"FUN_8072ED9C(param_4,"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..")"
		)
	elseif functionType == 0x4C then
		display(
			"x4C_temp = FUN_80650A70()"
		)
		display(
			"x4C_temp = (x4C_temp + 0x"
			..bizstring.hex(mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2))
			..")"
		)
		display("if (x4C_temp < 0) {")
		display("x4C_temp = 0")
		display("}")
		display(
			"FUN_80650A04(param_4,"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..",x4C_temp)"
		)
	-- functionTypes 0x4D > 0x50
	elseif functionType == 0x51 then
		display(
			"FUN_806F4F50(param_4,FLOAT_807F621C,FLOAT_807F6220,FLOAT_807F6224)"
		)
	elseif functionType == 0x52 then
		display(
			"// Execution Type 0x52 stripped from final. Parameters: "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3)
		)
	elseif functionType == 0x53 then
		display(
			"// Execution Type 0x53 stripped from final. Parameters: "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3)
		)
	-- functionTypes 0x54
	elseif functionType == 0x55 then
		display(
			"FUN_8062B630("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..")"
		)
	-- functionTypes 0x56 & 0x57
	elseif functionType == 0x58 then
		display(
			"x58_temp = FUN_805FFE50("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3)
			..")"
		)
		display("if (x58_temp == 0) {")
		display(
			"FUN_8063DB3C("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3)
			..")"
		)
		display("}")
	elseif functionType == 0x59 then
		display(
			"FUN_80724994(3,"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..",0)"
		)
	elseif functionType == 0x5A then
		display(
			"*(ushort *)(behaviour + 0x68) = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
		)
		display(
			"*(ushort *)(behaviour + 0x6A) = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
		)
		display(
			"*(ushort *)(behaviour + 0x6C) = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3)
		)
	elseif functionType == 0x5B then
		display(
			"FUN_806C92C4("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..")"
		)
	elseif functionType == 0x5C then
		display(
			"FUN_80724A9C("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3)
			..")"
		)
	elseif functionType == 0x5D then
		display(
			"setNextTransitionType("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..")"
		)
	-- functionTypes 0x5E
	elseif functionType == 0x5F then
		display(
			"*(uint *)(PlayerPointer->ExtraInfo->unk0x1F0) = *(uint *)(PlayerPointer->ExtraInfo->unk0x1F0 | 0x"
			..bizstring.hex((mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1) * 0x10000) + mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2))
		)
	-- functionTypes 0x60
	elseif functionType == 0x61 then
		if mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3) == 0 then
			display(
				"playSong('"
				..getSongName(mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1))
				.."', (float) 1)"
			)
		else
			display(
				"playSong('"
				..getSongName(mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1))
				.."', (float) "
				..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3) / 255
				..")"
			)
		end
	elseif functionType == 0x62 then
		display(
			"WORD_807F693A = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
		)
	-- functionTypes 0x63 > 0x64
	elseif functionType == 0x65 then
		display(
			"*(byte *)(behaviour + 0x"
			..bizstring.hex(mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2) + 0x4B)
			..") = *(byte *)(behaviour + 0x"
			..bizstring.hex(mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2) + 0x4B)
			..") + "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
		)
	elseif functionType == 0x66 then
		display("if (BYTE_807F61F8 == 0) {")
		display("spawnActor(TimerController)")
		display("temp = CurrentActorPointer")
		display("WORD_807F61F4 = PTR_PTR_807FBB44")
		display("CurrentActorPointer = mainmemory.read_u32_be(0x7FBB44)")
		display(
			"spawnTimer(0xDC,0x2A"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..")"
		)
		display("BYTE_807F61F8 = 1")
		display("WORD_807F61F0 = PTR_PTR_807FBB44")
		display("CurrentActorPointer = temp")
		display("}")
	--[[
		functionTypes 0x67 > 0x6A
	]]--
	elseif functionType == 0x6B then
		display("setFlag("
		.."0x"
		..bizstring.hex(math.floor(mainmemory.read_u16_be(ScriptCommand + command_struct.command_param_1) / 8))
		..">"
		..mainmemory.read_u16_be(ScriptCommand + command_struct.command_param_1) % 8
		..","
		..getTOrF(mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2))
		..",'Permanent')")
	-- functionTypes 0x6C & 0x6D
	elseif functionType == 0x6E then
		display(
			"BYTE_807F693F = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
		)
	-- functionTypes 0x6F > 0x73
	elseif functionType == 0x74 then
		display(
			"*(byte *)(behaviour + 0x9B) = *(byte *)(behaviour + 0x9B) | 0x"
			..bizstring.hex(mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1))
		)
	elseif functionType == 0x75 then
		display(
			"changeTriggerActiveStateOfFirstInstanceOfType('"
			..getTriggerTypeName(mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1))
			.."',"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..")"
		)
	-- functionTypes 0x76 > 0x78
	elseif functionType == 0x79 then
		display("setFlag("
		.."0x"
		..bizstring.hex(math.floor(mainmemory.read_u16_be(ScriptCommand + command_struct.command_param_1) / 8))
		..">"
		..mainmemory.read_u16_be(ScriptCommand + command_struct.command_param_1) % 8
		..","
		..getTOrF(mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2))
		..",'Temporary')")
	-- functionTypes 0x7A & 0x7B
	elseif functionType == 0x7C then
		display(
			"BYTE_80748094 = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
		)
	-- functionTypes 0x7D
	elseif functionType == 0x7E then
		x7e_ivar5 = mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
		if mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2) < 0 then
			x7e_ivar5 = x7e_ivar5 + 0x7F
		end
		x7e_uvar9 = bit.band(bit.rshift(x7e_ivar5,7),0xFF)
		x7e_ivar5 = mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3)
		if mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3) < 0 then
			x7e_ivar5 = x7e_ivar5 + 0x7F
		end
		x7e_uvar14 = bit.band(bit.rshift(x7e_ivar5,7),0xFF)
		x7e_bvar15 = x7e_uvar14
		if x7e_uvar9 == 0 then
			x7e_uvar9 = 0x7F
		end
		if x7e_uvar14 == 0 then
			x7e_bvar15 = 0xFF
		end
		display("if (BYTE_80748094 < 1) {")
		display(
			"playSFX("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..",0x7FFF,0x427C0000,"
			..x7e_uvar9/127
			..")"
		)
		display("}")
		display("else {")
		display("FUN_806335B0(param_4,1,BYTE_80748094)")
		display(
			"FUN_806086CC("
			..x7e_bvar15
			..","
			..x7e_uvar9
			..","
			..bit.band(mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2),0x7F)
			..","
			..bit.band(mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3),0x7F)
			..",0.3,0)"
		)
		display("}")
	elseif functionType == 0x7F then
		if mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2) == 0 then
			x7f_temp = 0
		elseif mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2) == 1 then
			x7f_temp = 1
		elseif mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2) == 2 then
			x7f_temp = 2
		elseif mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2) == 3 then
			x7f_temp = 3
		else
			x7f_temp = 0
		end
		display(
			"FUN_8072EE0C(param_4,"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..x7f_temp
			..")"
		)
	-- functionTypes 0x80 > 0x82
	elseif functionType == 0x83 then
		display(
			"FUN_806FB370("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3)
			..")"
		)
	elseif functionType == 0x84 then
		display("setFlag("
		.."0x"
		..bizstring.hex(math.floor(mainmemory.read_u16_be(ScriptCommand + command_struct.command_param_1) / 8))
		..">"
		..mainmemory.read_u16_be(ScriptCommand + command_struct.command_param_1) % 8
		..","
		..getTOrF(mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2))
		..",'Global')")
	-- functionTypes 0x85 > 0x89
	elseif functionType == 0x8A then
		display(
			"FUN_806417BC("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..")"
		)
	-- functionTypes 0x8B > 0x94
	elseif functionType == 0x95 then
		display("WORD_807F693C = 0x80")
	elseif functionType == 0x96 then
		display(
			"BYTE_807F6903 = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
		)
	else
		display("["
		..functionType
		..","
		..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
		..","
		..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
		..","
		..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3)
		.."]")
	end
end

-- Key 8 in savestate is 0x3B9680
-- parseObjectScript(0x3B9680) -- Key 8
-- parseObjectScript(0x3B6590) -- Coin Door
parseObjectScript(0x455300) -- Kroc Kruiser
-- parseObjectScript(0x453530) -- Isles Water Switch
-- parseObjectScript(0x4C5D00) -- Rareware GB
-- parseObjectScript(0x455FF0) -- Isles lightning rod

--[[
for i = 0, 215 do
	savestate.loadslot(4); -- Change savestate value
	mainmemory.write_u32_be(0x7444E4,i);
	end_timer = 500;
	while end_timer == 500 do
		model2_timer_value = mainmemory.read_u32_be(0x76A064);
		object_model2_array = mainmemory.read_u32_be(0x7F6000) - 0x80000000;
		mainmemory.write_u32_be(0x7444E4,i);
		if model2_timer_value == 1 then
			num_objects = mainmemory.read_u32_be(0x7F6004);
			for k = 1, num_objects do
				slotBase = object_model2_array + (k - 1) * 0x90;
				focused_slotBase = slotBase
				objectValue = mainmemory.read_u16_be(slotBase + 0x84);
				parseObjectScript(slotBase)
			end
			end_timer = 499;
			print("Map: "..i..", Timer: "..end_timer)
		end
		if emu.framecount() > 3600 then -- Change end frame
			end_timer = 499;
		end
		emu.frameadvance();
	end
end
]]--