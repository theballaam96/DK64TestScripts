drawing_array = {
	actors = {
	
	},
	obj_m2 = {
	
	},
	l_zones = {
	
	},
	spawners = {
	
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
};

------------
-- Actors --
------------

function updateActorCache()
	drawing_array.actors = {};
	local playerObject = Game.getPlayerObject();
	local cameraObject = dereferencePointer(Game.Memory.camera_pointer);
	if isRDRAM(playerObject) and isRDRAM(cameraObject) then
		for object_no = 0, getObjectModel1Count() do
			local pointer = dereferencePointer(Game.Memory.actor_pointer_array + (object_no * 4));
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
		local numSlots = mainmemory.read_u32_be(Game.Memory.obj_model2_array_count);
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
		local arraySize = mainmemory.read_u16_be(Game.Memory.loading_zone_array_size);
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
	local enemyRespawnObject = dereferencePointer(Game.Memory.enemy_respawn_object);
	local enemySlotSize = 0x48;
	if Game.version == 4 then
		enemySlotSize = 0x44;
	end
	if isRDRAM(enemyRespawnObject) then
		local numberOfEnemies = mainmemory.read_u16_be(Game.Memory.num_enemies);
		for i = 1, numberOfEnemies do
			local slotBase = enemyRespawnObject + (i - 1) * enemySlotSize;
			table.insert(drawing_array.spawners, slotBase);
		end
	end
end