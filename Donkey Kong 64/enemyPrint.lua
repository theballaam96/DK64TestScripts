enemyTypes = {
	[0x0] = "Beaver",
	[0x1] = "Giant Clam",
	[0x2] = "Krash",
	[0x3] = "Book",
	[0x4] = 0,
	[0x5] = "Zinger (Charger)",
	[0x6] = "Klobber",
	[0x7] = "Snide",
	[0x8] = "Army Dillo",
	[0x9] = "Klump",
	[0xA] = 0,
	[0xB] = "Cranky",
	[0xC] = "Funky",
	[0xD] = "Candy",
	[0xE] = "Beetle",
	[0xF] = "Mermaid",
	[0x10] = "Kabooom",
	[0x11] = "Vulture",
	[0x12] = "Squawks",
	[0x13] = "Cutscene DK",
	[0x14] = "Cutscene Diddy",
	[0x15] = "Cutscene Lanky",
	[0x16] = "Cutscene Tiny",
	[0x17] = "Cutscene Chunky",
	[0x18] = "Padlock (T&S)",
	[0x19] = "Llama",
	[0x1A] = "Mad Jack",
	[0x1B] = "Klaptrap (Green)",
	[0x1C] = "Zinger (Bomber)",
	[0x1D] = "Vulture (Race)",
	[0x1E] = "Klaptrap (Purple)",
	[0x1F] = "Klaptrap (Red)",
	[0x20] = "Get Out Controller",
	[0x21] = "Beaver (Gold)",
	[0x22] = 0,
	[0x23] = 213,
	[0x24] = "Minecart (TNT)",
	[0x25] = "Minecart (TNT)",
	[0x26] = "Pufftoss",
	[0x27] = "Cannon (Seasick)",
	[0x28] = "K Rool's Foot",
	[0x29] = 0,
	[0x2A] = "Fireball Spawner",
	[0x2B] = 0,
	[0x2C] = "Mushroom Man",
	[0x2D] = 0,
	[0x2E] = "Troff",
	[0x2F] = 0,
	[0x30] = "Bad Hit Detection Man",
	[0x31] = 0,
	[0x32] = 0,
	[0x33] = "Ruler",
	[0x34] = "Toy Box",
	[0x35] = "Squawks",
	[0x36] = "Seal",
	[0x37] = "Scoff",
	[0x38] = "Robo-Kremling",
	[0x39] = "Dogadon",
	[0x3A] = 0,
	[0x3B] = "Kremling",
	[0x3C] = "Spotlight Fish",
	[0x3D] = "Kasplat (DK)",
	[0x3E] = "Kasplat (Diddy)",
	[0x3F] = "Kasplat (Lanky)",
	[0x40] = "Kasplat (Tiny)",
	[0x41] = "Kasplat (Chunky)",
	[0x42] = "Mechanical Fish",
	[0x43] = "Seal",
	[0x44] = "Banana Fairy",
	[0x45] = "Squawks (w/ Spotlight)",
	[0x46] = 0,
	[0x47] = 0,
	[0x48] = "Rabbit",
	[0x49] = "Owl",
	[0x4A] = "Nintendo Logo",
	[0x4B] = 257,
	[0x4C] = 256,
	[0x4D] = 297,
	[0x4E] = "Toy Car",
	[0x4F] = "Minecart (TNT)",
	[0x50] = "Cutscene Object",
	[0x51] = "Guard",
	[0x52] = "Rareware Logo",
	[0x53] = "Robo-Zinger",
	[0x54] = "Krossbones",
	[0x55] = "Shuri",
	[0x56] = "Gimpfish",
	[0x57] = "Mr. Dice",
	[0x58] = "Sir Domino",
	[0x59] = "Mr. Dice",
	[0x5A] = "Rabbit",
	[0x5B] = 0,
	[0x5C] = "Fireball (w/ Glasses)",
	[0x5D] = "K. Lumsy",
	[0x5E] = "Spider (Boss)",
	[0x5F] = "Spider (Spiderling)",
	[0x60] = "Squawks",
	[0x61] = "K Rool (DK Phase)",
	[0x62] = "Skeleton Head",
	[0x63] = "Bat",
	[0x64] = "Tomato (Fungi)",
	[0x65] = "Kritter-in-a-Sheet",
	[0x66] = "Pufftup",
	[0x67] = "Kosha",
	[0x68] = 0,
	[0x69] = "Enemy Car",
	[0x6A] = "K. Rool (Diddy Phase)",
	[0x6B] = "K. Rool (Lanky Phase)",
	[0x6C] = "K. Rool (Tiny Phase)",
	[0x6D] = "K. Rool (Chunky Phase)",
	[0x6E] = "Bug",
	[0x6F] = "Banana Fairy (BFI)",
	[0x70] = "Tomato (Ice)",
};

maps = {
	"Test Map", -- 0
	"Funky's Store",
	"DK Arcade",
	"K. Rool Barrel - Lanky's Maze",
	"Jungle Japes - Mountain",
	"Cranky's Lab",
	"Jungle Japes - Minecart",
	"Jungle Japes",
	"Jungle Japes - Army Dillo",
	"Jetpac",
	"Kremling Kosh! (very easy)", -- 10
	"Stealthy Snoop! (normal, no logo)",
	"Jungle Japes - Shell",
	"Jungle Japes - Lanky's Cave",
	"Angry Aztec - Beetle Race",
	"Snide's H.Q.",
	"Angry Aztec - Tiny's Temple",
	"Hideout Helm",
	"Teetering Turtle Trouble! (very easy)",
	"Angry Aztec - Five Door Temple (DK)",
	"Angry Aztec - Llama Temple", -- 20
	"Angry Aztec - Five Door Temple (Diddy)",
	"Angry Aztec - Five Door Temple (Tiny)",
	"Angry Aztec - Five Door Temple (Lanky)",
	"Angry Aztec - Five Door Temple (Chunky)",
	"Candy's Music Shop",
	"Frantic Factory",
	"Frantic Factory - Car Race",
	"Hideout Helm (Level Intros, Game Over)",
	"Frantic Factory - Power Shed",
	"Gloomy Galleon", -- 30
	"Gloomy Galleon - K. Rool's Ship",
	"Batty Barrel Bandit! (easy)",
	"Jungle Japes - Chunky's Cave",
	"DK Isles Overworld",
	"K. Rool Barrel - DK's Target Game",
	"Frantic Factory - Crusher Room",
	"Jungle Japes - Barrel Blast",
	"Angry Aztec",
	"Gloomy Galleon - Seal Race",
	"Nintendo Logo", -- 40
	"Angry Aztec - Barrel Blast",
	"Troff 'n' Scoff", -- 42
	"Gloomy Galleon - Shipwreck (Diddy, Lanky, Chunky)",
	"Gloomy Galleon - Treasure Chest",
	"Gloomy Galleon - Mermaid",
	"Gloomy Galleon - Shipwreck (DK, Tiny)",
	"Gloomy Galleon - Shipwreck (Lanky, Tiny)",
	"Fungi Forest",
	"Gloomy Galleon - Lighthouse",
	"K. Rool Barrel - Tiny's Mushroom Game", -- 50
	"Gloomy Galleon - Mechanical Fish",
	"Fungi Forest - Ant Hill",
	"Battle Arena - Beaver Brawl!",
	"Gloomy Galleon - Barrel Blast",
	"Fungi Forest - Minecart",
	"Fungi Forest - Diddy's Barn",
	"Fungi Forest - Diddy's Attic",
	"Fungi Forest - Lanky's Attic",
	"Fungi Forest - DK's Barn",
	"Fungi Forest - Spider", -- 60
	"Fungi Forest - Front Part of Mill",
	"Fungi Forest - Rear Part of Mill",
	"Fungi Forest - Mushroom Puzzle",
	"Fungi Forest - Giant Mushroom",
	"Stealthy Snoop! (normal)",
	"Mad Maze Maul! (hard)",
	"Stash Snatch! (normal)",
	"Mad Maze Maul! (easy)",
	"Mad Maze Maul! (normal)", -- 69
	"Fungi Forest - Mushroom Leap", -- 70
	"Fungi Forest - Shooting Game",
	"Crystal Caves",
	"Battle Arena - Kritter Karnage!",
	"Stash Snatch! (easy)",
	"Stash Snatch! (hard)",
	"DK Rap",
	"Minecart Mayhem! (easy)", -- 77
	"Busy Barrel Barrage! (easy)",
	"Busy Barrel Barrage! (normal)",
	"Main Menu", -- 80
	"Title Screen (Not For Resale Version)",
	"Crystal Caves - Beetle Race",
	"Fungi Forest - Dogadon",
	"Crystal Caves - Igloo (Tiny)",
	"Crystal Caves - Igloo (Lanky)",
	"Crystal Caves - Igloo (DK)",
	"Creepy Castle",
	"Creepy Castle - Ballroom",
	"Crystal Caves - Rotating Room",
	"Crystal Caves - Shack (Chunky)", -- 90
	"Crystal Caves - Shack (DK)",
	"Crystal Caves - Shack (Diddy, middle part)",
	"Crystal Caves - Shack (Tiny)",
	"Crystal Caves - Lanky's Hut",
	"Crystal Caves - Igloo (Chunky)",
	"Splish-Splash Salvage! (normal)",
	"K. Lumsy",
	"Crystal Caves - Ice Castle",
	"Speedy Swing Sortie! (easy)",
	"Crystal Caves - Igloo (Diddy)", -- 100
	"Krazy Kong Klamour! (easy)",
	"Big Bug Bash! (very easy)",
	"Searchlight Seek! (very easy)",
	"Beaver Bother! (easy)",
	"Creepy Castle - Tower",
	"Creepy Castle - Minecart",
	"Kong Battle - Battle Arena",
	"Creepy Castle - Crypt (Lanky, Tiny)",
	"Kong Battle - Arena 1",
	"Frantic Factory - Barrel Blast", -- 110
	"Gloomy Galleon - Pufftoss",
	"Creepy Castle - Crypt (DK, Diddy, Chunky)",
	"Creepy Castle - Museum",
	"Creepy Castle - Library",
	"Kremling Kosh! (easy)",
	"Kremling Kosh! (normal)",
	"Kremling Kosh! (hard)",
	"Teetering Turtle Trouble! (easy)",
	"Teetering Turtle Trouble! (normal)",
	"Teetering Turtle Trouble! (hard)", -- 120
	"Batty Barrel Bandit! (easy)",
	"Batty Barrel Bandit! (normal)",
	"Batty Barrel Bandit! (hard)",
	"Mad Maze Maul! (insane)",
	"Stash Snatch! (insane)",
	"Stealthy Snoop! (very easy)",
	"Stealthy Snoop! (easy)",
	"Stealthy Snoop! (hard)",
	"Minecart Mayhem! (normal)",
	"Minecart Mayhem! (hard)", -- 130
	"Busy Barrel Barrage! (hard)",
	"Splish-Splash Salvage! (hard)",
	"Splish-Splash Salvage! (easy)",
	"Speedy Swing Sortie! (normal)",
	"Speedy Swing Sortie! (hard)",
	"Beaver Bother! (normal)",
	"Beaver Bother! (hard)",
	"Searchlight Seek! (easy)",
	"Searchlight Seek! (normal)",
	"Searchlight Seek! (hard)", -- 140
	"Krazy Kong Klamour! (normal)",
	"Krazy Kong Klamour! (hard)",
	"Krazy Kong Klamour! (insane)",
	"Peril Path Panic! (very easy)",
	"Peril Path Panic! (easy)",
	"Peril Path Panic! (normal)",
	"Peril Path Panic! (hard)",
	"Big Bug Bash! (easy)",
	"Big Bug Bash! (normal)",
	"Big Bug Bash! (hard)", -- 150
	"Creepy Castle - Tunnel",
	"Hideout Helm (Intro Story)",
	"DK Isles (DK Theatre)",
	"Frantic Factory - Mad Jack",
	"Battle Arena - Arena Ambush!",
	"Battle Arena - More Kritter Karnage!",
	"Battle Arena - Forest Fracas!",
	"Battle Arena - Bish Bash Brawl!",
	"Battle Arena - Kamikaze Kremlings!",
	"Battle Arena - Plinth Panic!", -- 160
	"Battle Arena - Pinnacle Palaver!",
	"Battle Arena - Shockwave Showdown!",
	"Creepy Castle - Dungeon Basement",
	"Creepy Castle - Tree",
	"K. Rool Barrel - Diddy's Kremling Game",
	"Creepy Castle - Chunky's Toolshed",
	"Creepy Castle - Trash Can",
	"Creepy Castle - Greenhouse",
	"Jungle Japes Lobby",
	"Hideout Helm Lobby", -- 170
	"DK's House",
	"Rock (Intro Story)",
	"Angry Aztec Lobby",
	"Gloomy Galleon Lobby",
	"Frantic Factory Lobby",
	"Training Grounds",
	"Dive Barrel",
	"Fungi Forest Lobby",
	"Gloomy Galleon - Submarine",
	"Orange Barrel", -- 180
	"Barrel Barrel",
	"Vine Barrel",
	"Creepy Castle - Crypt",
	"Enguarde Arena",
	"Creepy Castle - Car Race",
	"Crystal Caves - Barrel Blast",
	"Creepy Castle - Barrel Blast",
	"Fungi Forest - Barrel Blast",
	"Fairy Island",
	"Kong Battle - Arena 2", -- 190
	"Rambi Arena",
	"Kong Battle - Arena 3",
	"Creepy Castle Lobby",
	"Crystal Caves Lobby",
	"DK Isles - Snide's Room",
	"Crystal Caves - Army Dillo",
	"Angry Aztec - Dogadon",
	"Training Grounds (End Sequence)",
	"Creepy Castle - King Kut Out",
	"Crystal Caves - Shack (Diddy, upper part)", -- 200
	"K. Rool Barrel - Diddy's Rocketbarrel Game",
	"K. Rool Barrel - Lanky's Shooting Game",
	"K. Rool Fight - DK Phase",
	"K. Rool Fight - Diddy Phase",
	"K. Rool Fight - Lanky Phase",
	"K. Rool Fight - Tiny Phase",
	"K. Rool Fight - Chunky Phase",
	"Bloopers Ending",
	"K. Rool Barrel - Chunky's Hidden Kremling Game",
	"K. Rool Barrel - Tiny's Pony Tail Twirl Game", -- 210
	"K. Rool Barrel - Chunky's Shooting Game",
	"K. Rool Barrel - DK's Rambi Game",
	"K. Lumsy Ending",
	"K. Rool's Shoe",
	"K. Rool's Arena", -- 215	
};

for i = 0, 215 do
	savestate.loadslot(9);
	mainmemory.write_u32_be(0x7444E4,i);
	end_timer = 500;
	while end_timer == 500 do
		model2_timer_value = mainmemory.read_u32_be(0x76A064);
		enemy_respawn_object = mainmemory.read_u32_be(0x7FDC8C) - 0x80000000;
		mainmemory.write_u32_be(0x7444E4,i);
		if model2_timer_value == 1 then
			num_enemies = mainmemory.read_u16_be(0x7FDC88);
			enemy_counts = {};
			for k = 1, num_enemies do
				slotBase = enemy_respawn_object + (k - 1) * 0x48;
				enemyValue = mainmemory.readbyte(slotBase);
				if enemy_counts[enemyValue] == nil then
					enemy_counts[enemyValue] = 1;
				else
					enemy_counts[enemyValue] = enemy_counts[enemyValue] + 1;
				end
			end_timer = 499;
			end
		end
		if emu.framecount() > 15200 then
			end_timer = 499;
		end
		emu.frameadvance();
	end
	if i ~= 2 and i~= 9 then
		if num_enemies > 0 then
			print("");
			print("MAP: "..maps[i + 1]);
		end
		for l = 0, 0x70 do
			if enemy_counts[l] == nil then
				enemy_counts[l] = 0;
			end
			if enemy_counts[l] > 0 then
				print(enemy_counts[l].."x "..enemyTypes[l].." ("..l..")");
			end
		end
	end
end

emu.yield();