--[[
	SquawksEye.lua
]]--

startMessage = {
	[1] = "SquawksEye.lua",
	[2] = "-----------",
	[3] = "Shifts camera to above the player to get a birds-eye perspective",
	[4] = "Enter activate() to start the tracking",
	[5] = "Enter changeHeight(value) to change the height of the camera relative to the player (Default is 100 above the player)",
	[6] = "Enter deactivate() to finish the tracking",
	[7] = "Angle can be changed by going into first person",
	[8] = "This only works on the US Version of DK64",
	[9] = "",
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
	active = true;
	print("[SquawksEye] Active");
end

function deactivate()
	active = false;
	print("[SquawksEye] Inactive");
end

function changeHeight(value)
	y_relative = value;
	print("[SquawksEye] Changing relative height to "..value)
end

function shiftCamera()
	if active then
		player = mainmemory.read_u32_be(0x7FBB4C);
		if player > 0x7FFFFFFF and player < 0x80800000 then
			player = player - 0x80000000;
			weird_object = mainmemory.read_u32_be(0x7FC924);
			if weird_object > 0x7FFFFFFF and weird_object < 0x80800000 then
				weird_object = weird_object - 0x80000000;
				player_x = mainmemory.readfloat(player + 0x7C, true);
				player_y = mainmemory.readfloat(player + 0x80, true);
				player_z = mainmemory.readfloat(player + 0x84, true);
				mainmemory.writefloat(weird_object + 0x210, player_x, true);
				mainmemory.writefloat(weird_object + 0x214, player_y + y_relative, true);
				mainmemory.writefloat(weird_object + 0x218, player_z, true);
			end
		end
	end
end

event.onframestart(shiftCamera, "Shifts Camera")