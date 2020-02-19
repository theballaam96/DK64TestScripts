-- BFI
start_array = {-50,-50};
finish_array = {1300,1600};
step = 50;
y_val = 0;
check_type = "box";
save_state = 2;
frames_limit = 8

-- Hideout Helm
start_array = {-150,-200};
finish_array = {2400,5600};
step = 50;
y_val = 0;
check_type = "box";
save_state = 4;
frames_limit = 8

-- Jungle Japes
start_array = {-100,-100};
finish_array = {3400,4600};
step = 50;
y_val = -5000;
check_type = "exhaustive";
save_state = 5;
frames_limit = 8

-- Crystal Caves
start_array = {-500,-350};
finish_array = {3900,4400};
step = 50;
y_val = -5000;
check_type = "exhaustive";
save_state = 6;
frames_limit = 8

-- Fungi Forest Clock > W4 Analysis
start_array = {1940,3240};
finish_array = {2155,3415};
step = 5;
y_val = -5000;
check_type = "exhaustive";
save_state = 2;
frames_limit = 8

function isTransition()
	transition_speed = mainmemory.readfloat(0x7FD88C,true)
	if transition_speed == 0 then
		return false;
	end
	return true;
end

function addVoidCoords(val_x,val_z)
	unique_coords = true;
	if #void_coords > 0 then
		for i = 1, #void_coords do
			if void_coords[i][1] == val_x and void_coords[i][2] == val_z then
				unique_coords = false;
			end
		end
	end
	if unique_coords then
		coord_set = {val_x, val_z};
		table.insert(void_coords,coord_set);
	end
end

	start_x = start_array[1];
	start_z = start_array[2];
	finish_x = finish_array[1];
	finish_z = finish_array[2];
	void_coords = {};

	if check_type == "exhaustive" then
		-- Exhaustive Check: Checks every spot
		for x_val = start_x, finish_x, step do
			for z_val = start_z, finish_z, step do
				savestate.loadslot(save_state);
				console.clear()
				Game.setPosition(x_val, y_val, z_val);
				for k = 1, frames_limit do
					emu.frameadvance()
				end
				if isTransition() then
					addVoidCoords(x_val,z_val);
				end
			end
		end
	elseif check_type == "box" then
		--Box Check: Checks outer edges progressing inwards until finds a full 1-wide quadrilateral of non-void
		logged_new_void = true;
		while logged_new_void do
			logged_new_void = false;
			-- X Min
			x_val = start_x;
			for z_val = start_z, finish_z, step do
				savestate.loadslot(save_state);
				console.clear()
				Game.setPosition(x_val, y_val, z_val);
				for k = 1, frames_limit do
					emu.frameadvance()
				end
				if isTransition() then
					addVoidCoords(x_val,z_val);
					logged_new_void = true;
				end
			end

			-- X Max
			x_val = finish_x;
			for z_val = start_z, finish_z, step do
				savestate.loadslot(save_state);
				Game.setPosition(x_val, y_val, z_val);
				for k = 1, frames_limit do
					emu.frameadvance()
				end
				if isTransition() then
					addVoidCoords(x_val,z_val);
					logged_new_void = true;
				end
			end

			-- Z Min
			z_val = start_z;
			for x_val = start_x, finish_x, step do
				savestate.loadslot(save_state);
				Game.setPosition(x_val, y_val, z_val);
				for k = 1, frames_limit do
					emu.frameadvance()
				end
				if isTransition() then
					addVoidCoords(x_val,z_val);
					logged_new_void = true;
				end
			end

			-- Z Max
			z_val = finish_z;
			for x_val = start_x, finish_x, step do
				savestate.loadslot(save_state);
				Game.setPosition(x_val, y_val, z_val);
				for k = 1, frames_limit do
					emu.frameadvance()
				end
				if isTransition() then
					addVoidCoords(x_val,z_val);
					logged_new_void = true;
				end
			end

			start_x = start_x + step;
			start_z = start_z + step;
			finish_x = finish_x - step;
			finish_z = finish_z - step;
			emu.yield();
		end
	end
	
	print("Copy-Paste this into Excel to graph");
	print("-----");
	if #void_coords > 0 then
		for i = 1, #void_coords do
			print(void_coords[i][1].."	"..void_coords[i][2]);
		end
	end