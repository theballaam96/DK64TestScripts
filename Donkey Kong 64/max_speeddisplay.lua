function setVerticalDirection(magnitude)
	input_x = 0;
	input_y = magnitude;
	joypad.setanalog({["X Axis"] = input_x, ["Y Axis"] = input_y}, 1)
end

function setA()
	joypad.set({["A"] = true}, 1);
end

function setB()
	joypad.set({["B"] = true}, 1);
end

function setZ()
	joypad.set({["Z"] = true}, 1);
end

function setR()
	joypad.set({["R"] = true}, 1);
end

function clearInput()
	joypad.set({["Z"] = false}, 1);
	joypad.set({["B"] = false}, 1);
	joypad.set({["A"] = false}, 1);
	joypad.set({["R"] = false}, 1);
	joypad.setanalog({["X Axis"] = false, ["Y Axis"] = false}, 1)
end

function isLoading()
	return mainmemory.read_u32_be(0x76A064) == 0;
end

function getPlayerObject() -- TODO: Cache this
	if isLoading() then
		return;
	end
	pointer_val = mainmemory.read_u32_be(0x7FBB4C);
	return pointer_val - 0x80000000;
end

function isRDRAM(ptr)
	if ptr ~= nil then
		if ptr > -1 and ptr < 0x800000 then
			return true;
		end
	end
	return false;
end

function getMovement()
	local playerObject = getPlayerObject();
	if isRDRAM(playerObject) then
		local controlState = mainmemory.readbyte(playerObject + 0x154);
		return controlState;
	end
	return 'Unknown';
end

function getVelocity()
	local playerObject = getPlayerObject();
	if isRDRAM(playerObject) then
		return mainmemory.readfloat(playerObject + 0xB8, true);
	end
	return 0;
end

function setVelocity(value)
	local playerObject = getPlayerObject();
	if isRDRAM(playerObject) then
		mainmemory.writefloat(playerObject + 0xB8, value, true);
	end
end

function getYVelocity()
	local playerObject = getPlayerObject();
	if isRDRAM(playerObject) then
		return mainmemory.readfloat(playerObject + 0xC0, true);
	end
	return 0;
end

function getFloor()
	local playerObject = getPlayerObject();
	if isRDRAM(playerObject) then
		return mainmemory.readfloat(playerObject + 0xA4, true);
	end
	return 0;
end

function getYPos()
	local playerObject = getPlayerObject();
	if isRDRAM(playerObject) then
		return mainmemory.readfloat(playerObject + 0x80, true);
	end
	return 0;
end

function getGroundedState()
	playerFloor = getFloor();
	playerY = getYPos();
	if playerFloor == playerY then
		return true;
	end
	return false;
end

function setYRotation(value)
	local playerObject = getPlayerObject();
	if isRDRAM(playerObject) then
		mainmemory.write_u16_be(playerObject + 0xE6, value);
	end
end

function setXPosition(value)
	local playerObject = getPlayerObject();
	if isRDRAM(playerObject) then
		mainmemory.writefloat(playerObject + 0x7C, value, true);
	end
end

function setZPosition(value)
	local playerObject = getPlayerObject();
	if isRDRAM(playerObject) then
		mainmemory.writefloat(playerObject + 0x84, value, true);
	end
end

function getZPosition()
	local playerObject = getPlayerObject();
	if isRDRAM(playerObject) then
		return mainmemory.readfloat(playerObject + 0x84, true);
	end
	return 0;
end

total_laps = 10;
gatekeeper_laps = total_laps - 1;
lap_increment_pending = false;
end_pending = false;
laps = 0;
z_start = 150;
z_end = 800;
x_start = 1760;

function detectTrackEnd()
	z_pos = getZPosition();
	if z_pos > z_end and laps < gatekeeper_laps then
		setZPosition(z_pos - (z_end - z_start));
		setXPosition(x_start);
		setYRotation(0);
		lap_increment_pending = true;
	elseif z_pos > z_end and laps == gatekeeper_laps then
		laps = laps + 1;
		end_pending = true;
	elseif end_pending then
		end_time = emu.framecount();
		total_time = end_time - start_time;
		avg_speed = (60 * (z_end - z_start) * total_laps) / total_time;
		print("Total time: "..total_time.." frames");
		print("Avg Speed: "..avg_speed.." units per second");
		stop();
		end_pending = false;
	elseif z_pos < z_end and lap_increment_pending then
		lap_increment_pending = false;
		laps = laps + 1;
	end
end

function preset()
	setYRotation(0);
	setXPosition(x_start);
	setZPosition(z_start);
	setR();
end

function start()
	start_time = emu.framecount();
	has_started = true;
end

function stop()
	has_started = false;
end

has_started = false;

function performOptimalHorizontalMovement()
	movement = getMovement();
	velocity = getVelocity();
	y_velocity = getYVelocity();
	grounded = getGroundedState();
	setR();
	setYRotation(0);
	setXPosition(x_start);
	character = mainmemory.readbyte(0x74E77C);
	
	if movement == 12 and velocity == 0 then
		setVerticalDirection(-127);
	end
	if movement == 13 and velocity < 13 then
		setVerticalDirection(127);
	end
	if character == 0 then
		if movement == 13 and velocity > 50 then
			setZ();
			setVerticalDirection(127);
			peak_reached = false;
		elseif movement == 60 then
			setZ();
			setB();
			setVerticalDirection(127);
			peak_reached = false;
		elseif movement == 43 and velocity < 250 and not peak_reached then
			setVerticalDirection(127);
		elseif movement == 43 and velocity == 250 then
			setVerticalDirection(0);
			peak_reached = true;
		elseif movement == 43 and velocity > 160 and peak_reached then
			setVerticalDirection(0);
		elseif movement == 43 and velocity < 161 then
			setVerticalDirection(127);
		end
	elseif character == 1 then
		if grounded and movement == 13 and velocity > 50 then
			setVerticalDirection(127);
			setB();
		elseif grounded and movement == 42 and velocity > 50 then
			setVerticalDirection(127);
			setB();
		elseif movement == 41 then
			setVerticalDirection(127);
			setA();
		elseif movement == 23 and y_velocity > 30 then
			setVerticalDirection(127);
			setA();
		elseif movement == 23 and y_velocity == -10 then
			setVerticalDirection(127);
			setA();
		elseif movement == 23 and y_velocity == 30 then
			setVerticalDirection(127);
			setB();
		elseif movement == 42 and not grounded then
			setVerticalDirection(127);
		end
	elseif character > 1 and character < 5 then
		if movement == 13 and velocity > 50 then
			setZ();
			setVerticalDirection(127);
		elseif movement == 60 then
			setZ();
			setA();
			setVerticalDirection(127);
		elseif movement == 29 and not grounded then
			setVerticalDirection(127);
		elseif movement == 29 and grounded then
			setVerticalDirection(127);
			setB();
		elseif movement == 41 then
			setVerticalDirection(127);
			setVelocity(150);
		end
	end
end

function everyFrame()
	clearInput();
	if has_started then
		performOptimalHorizontalMovement();
		detectTrackEnd();
	end
end

event.onframestart(everyFrame, "Event Cycle");