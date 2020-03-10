--[[
	SquawksEye.lua
]]--

startMessage = {
	[1] = "SquawksEye.lua",
	[2] = "-----------",
	[3] = "Shifts camera to above the player to get a birds-eye perspective",
	[4] = "Enter activate() to start the tracking",
	[5] = "Enter changeHeight(value) to change the height of the camera relative to the player (Default is 100 above the player)",
	[6] = "Enter changePosition(x,y,z) to change the tracking to a fixed location (Default is 0,0,0)",
	[7] = "Enter deactivate() to finish the tracking",
	[8] = "Angle can be changed by going into first person",
	[9] = "This only works on the US Version of DK64",
	[10] = "",
}

function boot()
	for i = 1, #startMessage do
		print(startMessage[i]);
	end
	active = false;
	y_relative = 100;
end

boot();

function activate()
	y_relative = 100;
	x_pos = 0;
	y_pos = 0;
	z_pos = 0;
	camera_mode = "birdseye"
	active = true;
	print("[SquawksEye] Active");
end

function deactivate()
	active = false;
	print("[SquawksEye] Inactive");
end

function changeHeight(value)
	y_relative = value;
	camera_mode = "birdseye";
	print("[SquawksEye] Changing relative height to "..value)
end

function changePosition(x_p,y_p,z_p)
	x_pos = x_p;
	y_pos = y_p;
	z_pos = z_p;
	camera_mode = "fixed";
	print("[SquawksEye] Changing relative height to ("..x_p..","..y_p..","..z_p..")")
end

function shiftCamera()
	if active then
		player = mainmemory.read_u32_be(0x7FBB4C);
		if player > 0x7FFFFFFF and player < 0x80800000 then
			player = player - 0x80000000;
			weird_object = mainmemory.read_u32_be(0x7FC924);
			if weird_object > 0x7FFFFFFF and weird_object < 0x80800000 then
				if camera_mode == "birdseye" then
					weird_object = weird_object - 0x80000000;
					player_x = mainmemory.readfloat(player + 0x7C, true);
					player_y = mainmemory.readfloat(player + 0x80, true);
					player_z = mainmemory.readfloat(player + 0x84, true);
					mainmemory.writefloat(weird_object + 0x210, player_x, true);
					mainmemory.writefloat(weird_object + 0x214, player_y + y_relative, true);
					mainmemory.writefloat(weird_object + 0x218, player_z, true);
				elseif camera_mode == "fixed" then
					weird_object = weird_object - 0x80000000;
					mainmemory.writefloat(weird_object + 0x210, x_pos, true);
					mainmemory.writefloat(weird_object + 0x214, y_pos, true);
					mainmemory.writefloat(weird_object + 0x218, z_pos, true);
				end
			end
		end
	end
end

function changeChunk(value)
	weird_object = mainmemory.read_u32_be(0x7FC924);
	if weird_object > 0x7FFFFFFF and weird_object < 0x80800000 then
		weird_object = weird_object - 0x80000000;
		mainmemory.write_u16_be(weird_object + 0x290, value);
	end
end

event.onframestart(shiftCamera, "Shifts Camera")