version = 1;

memory = {
	current_map = {0x76A0A8, 0x764BC8, 0x76A298, 0x72CDE4}, -- See Game.maps for values
	exit_array_pointer = {0x7FC900, 0x7FC840, 0x7FCD90, 0x7B6520}, -- Pointer
	number_of_exits = {0x7FC904, 0x7FC844, 0x7FCD94, 0x7B6524}, -- Byte
	loading_zone_transition_type = {0x76AEE0, 0x765A00, 0x76B0D0, 0x72D110}, -- byte
	loading_zone_transition_speed = {0x7FD88C, 0x7FD7CC, 0x7FDD1C, 0x7B708C}, -- Float
	loading_zone_array_size = {0x7FDCB0, 0x7FDBF0, 0x7FE140, 0x7B7410}, -- u16_be
	loading_zone_array = {0x7FDCB4, 0x7FDBF4, 0x7FE144, 0x7B7414},
	character = {0x74E77C, 0x748EDC, 0x74E05C, 0x6F9EB8},
	object_spawn_table = {0x74E8B0, 0x749010, 0x74E1D0, 0x6F9F80},
	enemy_drop_table = {0x750400, 0x74AB20, 0x74FCE0, 0x6FB630},
	enemy_table = {0x75EB80, 0x759690, 0x75ED40, 0x70A460},
	num_enemy_types = {0x70, 0x70, 0x70, 0x66},
	enemy_type_size = {0x18, 0x18, 0x18, 0x1C},
	player_pointer = {0x7FBB4C, 0x7FBA6C, 0x7FBFBC, 0x7B5AFC},
	camera_pointer = {0x7FB968, 0x7FB888, 0x7FBDD8, 0x7B5918},
	actor_pointer_array = {0x7FBFF0, 0x7FBF10, 0x7FC460, 0x7B5E58},
	actor_count = {0x7FC3F0, 0x7FC310, 0x7FC860, 0x7B6258},
	obj_model2_array_pointer = {0x7F6000, 0x7F5F20, 0x7F6470, 0x7A20B0}, -- 0x6F4470 has something to do with obj model 2 on Kiosk, not sure what yet
	obj_model2_array_count = {0x7F6004, 0x7F5F24, 0x7F6474, 0x7B17B8},
	obj_model2_timer = {0x76A064, 0x764B84, 0x76A254, 0x72CDAC},
	num_enemies = {0x7FDC88, 0x7FDBC8, 0x7FE118, 0x7B73D8},
	enemy_respawn_object = {0x7FDC8C, 0x7FDBCC, 0x7FE11C, 0x7B73DC},
};

drawing_array = {
	actors = {
	
	},
	obj_m2 = {
	
	},
	l_zones = {
	
	},
	spawners = {
	
	},
	exits = {
	
	},
};

relevant_info = {
	actors = {
		actor_type = 0x5A, -- u32
		x_pos = 0x7C, -- Float
		z_pos = 0x84, -- Float
	},
	obj_m2 = {
		x_pos = 0x0, -- Float
		z_pos = 0x4, -- Float
		object_type = 0x84, -- u16
	},
	l_zones = {
		x_pos = 0x0, -- s16
		z_pos = 0x4, -- s16
		x_size = 0x6, -- u16 (Need to look more into this)
		z_size = 0xA, -- u16 (Need to look more into this)
		active = 0x39, -- u8
	},
	spawners = {
		enemy = 0x0, -- u8
		x_pos = 0x4, -- s16
		z_pos = 0x8, -- s16
		state = 0x42, -- u8
		alt_enemy = 0x44, -- u8
	},
	exits = {
	
	},
};

------------------------------------
-------- Baseline Functions --------
--------- From  ScriptHawk ---------
-- github.com/isotarge/scripthawk --
------------------------------------

RDRAMBase = 0x80000000; 
RDRAMSize = 0x800000; -- Halved with no expansion pak, can be read from 0x80000318 
RAMBase = RDRAMBase; 
RAMSize = RDRAMSize; 
 
-- Checks whether a value falls within N64 RDRAM 
function isRDRAM(value) 
	return type(value) == "number" and value >= 0 and value < RDRAMSize; 
end 
 
-- Checks whether a value is a pointer in to N64 RDRAM on the system bus 
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


function Game.isLoading() 
 	return mainmemory.read_u32_be(memory.obj_model2_timer[version]) == 0; 
end 


function Game.getPlayerObject() -- TODO: Cache this 
 	if Game.isLoading() then 
 		return; 
	end 
	return dereferencePointer(memory.player_pointer[version]); 
end 

function getObjectModel1Count() 
	return math.min(255, mainmemory.read_u16_be(memory.actor_count[version])); 
end 

obj_model2_slot_size = 0x90;

function getObjectModel2Array() 
	if Game.version ~= 4 then 
 		return dereferencePointer(memory.obj_model2_array_pointer[version]); 
 	end 
 	return memory.obj_model2_array_pointer[version]; -- Kiosk doesn't move 
end

function Game.getLoadingZoneArray()
	return dereferencePointer(memory.loading_zone_array[version]);
end


------------
-- Actors --
------------

function updateActorCache()
	drawing_array.actors = {};
	local playerObject = Game.getPlayerObject();
	local cameraObject = dereferencePointer(memory.camera_pointer[version]);
	if isRDRAM(playerObject) and isRDRAM(cameraObject) then
		for object_no = 0, getObjectModel1Count() do
			local pointer = dereferencePointer(memory.actor_pointer_array[version] + (object_no * 4));
			if isRDRAM(pointer) then
				table.insert(drawing_array.actors, pointer);
			end
		end
	end
end

function checkActorCache()
	-- If some condition fails (Object count changing?)
	-- updateActorCache();
end

--------------------
-- Object Model 2 --
--------------------

function updateObjM2Cache()
	drawing_array.obj_m2 = {};
	local objModel2Array = getObjectModel2Array();
	if isRDRAM(objModel2Array) then
		local numSlots = mainmemory.read_u32_be(memory.obj_model2_array_count[version]);
		-- Fill and sort pointer list
		for i = 1, numSlots do
			table.insert(drawing_array.obj_m2, objModel2Array + (i - 1) * obj_model2_slot_size);
		end
	end
end

-------------------
-- Loading Zones --
-------------------

function updateLZCache()
	drawing_array.l_zones = {};
	local loadingZoneArray = Game.getLoadingZoneArray();
	if isRDRAM(loadingZoneArray) then
		local arraySize = mainmemory.read_u16_be(memory.loading_zone_array_size[version]);
		for i = 0, arraySize - 1 do
			table.insert(drawing_array.l_zones, loadingZoneArray + (i * loading_zone_size));
		end
	end
end

--------------
-- Spawners --
--------------

function updateSpawnerCache()
	drawing_array.spawners = {};
	local enemyRespawnObject = dereferencePointer(memory.enemy_respawn_object[version]);
	local enemySlotSize = 0x48;
	if Game.version == 4 then
		enemySlotSize = 0x44;
	end
	if isRDRAM(enemyRespawnObject) then
		local numberOfEnemies = mainmemory.read_u16_be(memory.num_enemies[version]);
		for i = 1, numberOfEnemies do
			local slotBase = enemyRespawnObject + (i - 1) * enemySlotSize;
			table.insert(drawing_array.spawners, slotBase);
		end
	end
end

-----------------------
-- Drawing Functions --
-----------------------

function getMapCentreCoords()
	local playerObject = Game.getPlayerObject();
	player_x = mainmemory.readfloat(playerObject + relevant_info.actors.x_pos,true);
	player_z = mainmemory.readfloat(playerObject + relevant_info.actors.z_pos,true);
	return {player_x, player_z};
end

zoom_level = 1;
ui_units_between_centre_and_edge = 40;

map_scales = { -- Game Units per UI Units for 1x Zoom

};

function getMapScalingInUnits()
	local current_map = mainmemory.read_u32_be(memory.current_map[version]);
	map_scaling = map_scale[current_map];
	scale = (map_scaling * ui_units_between_centre_and_edge) / zoom_level;
	return scale; -- Game Units to Edge
end

function convertObjectPosToUIPos(obj_x,obj_z)
	local map_centre = getMapCentreCoords();
	local game_unit_estate = getMapScalingInUnits();
	dist_player_to_object = {
		x = obj_x - map_centre[1];
		z = obj_Z - map_centre[2];
	};
	ui_units_x = (dist_player_to_object.x / game_unit_estate) * ui_units_between_centre_and_edge;
	ui_units_z = (dist_player_to_object.z / game_unit_estate) * ui_units_between_centre_and_edge;
	lower_bound = 0 - ui_units_between_centre_and_edge;
	upper_bound = ui_units_between_centre_and_edge;
	if lower_bound > ui_units_x > upper_bound then
		if lower_bound > ui_units_z > upper_bound then
			return {ui_units_x,ui_units_z};
		end
	end
	return {nil,nil};
end