obj_model2_timer = 0x76A064;
player_pointer = 0x7FBB4C;
button_input = 0x014DC4; -- 2 Byte
stick_x = 0x014DC6; -- 1 Byte
stick_y = 0x014DC7; -- 1 Byte
frame_lag = 0x76AF10;
frame_real = 0x7F0560;

RDRAMBase = 0x80000000;
RDRAMSize = 0x800000;

phasewalk_indicator = {};
phasewalk_comment = "";
for i = 1, 5 do
	phasewalk_indicator[i] = "Pending...";
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

function isRDRAM(value)
	return type(value) == "number" and value >= 0 and value < RDRAMSize;
end

function isLoading()
	return mainmemory.read_u32_be(obj_model2_timer) == 0;
end

function getPlayerObject()
	if isLoading() then
		return;
	end
	return dereferencePointer(player_pointer);
end

function getMovementState()
	local playerObject = getPlayerObject();
	if isRDRAM(playerObject) then
		local controlState = mainmemory.readbyte(playerObject + 0x154);
		return controlState;
	end
	return 'Unknown';
end

function isInSubGame()
	current_map = mainmemory.read_u32_be(0x76A0A8);
	return current_map == 2 or current_map == 9;
end

function getYRotation()
	if not isInSubGame() then
		local playerObject = getPlayerObject();
		if isRDRAM(playerObject) then
			angle = mainmemory.read_u16_be(playerObject + 0xE6);
			return angle % 4096;
		end
	end
	return 0;
end

-- First Person = 2
-- Crouch = 60

-- Ray Deadzone = 56.03 > | Y |

-- PHASEWALK INPUTS A
-- 0008 0000
-- 0000 0081
-- 0000 0000
-- 0000 007E
-- 2000 0000

-- PHASEWALK INPUTS B
-- 0008 0000
-- 0000 0081
-- 0000 0000
-- 2000 007E
-- 2000 0000

-- PHASEWALK INPUTS C
-- 0008 0000
-- 0000 0081
-- 0000 0000
-- 2000 007E
-- 0000 0000

function everyFrame()
	if previousMovement == nil then
		previousMovement = 0;
		phasewalk_frame = 0;
	end
	currentMovement = getMovementState();
	lag = mainmemory.read_u32_be(frame_lag);
	real = mainmemory.read_u32_be(frame_real);
	if currentMovement == 2 then
		phasewalk_state = 0; -- Phasewalk not established
	end
	if previousMovement == 2 and currentMovement ~= 2 then -- Phasewalking start
		phasewalk_state = 1;
		phasewalk_frame = 0;
		phasewalk_button_inputs = {};
		phasewalk_stick_inputs = {};
		phasewalk_indicator = {};
		angle = getYRotation();
		if angle < 2048 then
			phasewalk_comment = "";
		else
			phasewalk_comment = "Angle not phasewalkable";
		end
		for i = 1, 5 do
			phasewalk_indicator[i] = "Pending...";
		end
	end
	if phasewalk_frame < 7 and phasewalk_state == 1 and lag == real then
		phasewalk_frame = phasewalk_frame + 1;
	end
	if phasewalk_frame > 0 and phasewalk_frame < 6 then
		phasewalk_button_inputs[phasewalk_frame] = mainmemory.read_u16_be(button_input);
		stick_x_value = mainmemory.read_s8(stick_x);
		stick_y_value = mainmemory.read_s8(stick_y);
		ray_size = (((stick_x_value)^(2))+((stick_y_value)^(2)))^(1/2);
		if math.abs(ray_size) < 56.03 then
			phasewalk_stick_inputs[phasewalk_frame] = 0; -- Neutral
		elseif stick_y_value < 0 then
			phasewalk_stick_inputs[phasewalk_frame] = -1; -- Back
		else
			phasewalk_stick_inputs[phasewalk_frame] = 1; -- Forward
		end
	end
	if phasewalk_frame == 6 and lag == real then
		for i = 1, 5 do
			--print("["..i.."] - Button: "..phasewalk_button_inputs[i]..", Stick: "..phasewalk_stick_inputs[i]);
		end
		
		if phasewalk_stick_inputs[1] == 0 then
			phasewalk_indicator[1] = "Correct";
		else
			phasewalk_indicator[1] = "Incorrect";
			if phasewalk_comment == "" then
				phasewalk_comment = "C-Up frame doesn't contain neutral input";
			end
		end
		
		if phasewalk_stick_inputs[2] == -1 and phasewalk_button_inputs [2] ~= 8192 then
			phasewalk_indicator[2] = "Correct";
		else
			phasewalk_indicator[2] = "Incorrect";
			if phasewalk_comment == "" and phasewalk_button_inputs [2] == 0 then
				phasewalk_comment = "Back input not performed";
			end
		end
		
		if phasewalk_stick_inputs[3] == 0 and phasewalk_button_inputs [3] ~= 8192 then
			phasewalk_indicator[3] = "Correct";
		else
			phasewalk_indicator[3] = "Incorrect";
			if phasewalk_comment == "" and phasewalk_button_inputs [3] == 0 then
				phasewalk_comment = "2nd Neutral input not performed";
			end
		end
		
		if phasewalk_stick_inputs[4] == 1 then
			if phasewalk_button_inputs[4] == 0 or phasewalk_button_inputs[4] == 8192 then
				phasewalk_indicator[4] = "Correct";
			else
				phasewalk_indicator[4] = "Incorrect";
			end
		else
			phasewalk_indicator[4] = "Incorrect";
			if phasewalk_comment == "" then
				phasewalk_comment = "Forward input not performed";
			end
		end
		
		if phasewalk_stick_inputs[5] == 0 then
			if phasewalk_button_inputs[5] == 0 or phasewalk_button_inputs[4] == 8192 then
				phasewalk_indicator[5] = "Correct";
			elseif phasewalk_button_inputs[4] == 0 or phasewalk_button_inputs[5] == 8192 then
				phasewalk_indicator[5] = "Correct";
			else
				phasewalk_indicator[5] = "Incorrect";
			end
		else
			phasewalk_indicator[5] = "Incorrect";
			if phasewalk_comment == "" then
				phasewalk_comment = "3rd Neutral input not performed";
			end
		end
		
		for i = 1,5 do
			if phasewalk_button_inputs[i] == 8192 then
				first_z_press_frame = i;
			end
		end
		
		if first_z_press_frame == nil then
			first_z_press_frame = 6;
		end
		
		if first_z_press_frame < 4 then
			if phasewalk_comment == "" then
				phasewalk_comment = "Z Press too early";
			end
		end
		
		if first_z_press_frame > 5 then
			if phasewalk_comment == "" then
				phasewalk_comment = "Z Press too late";
			end
		end
		
		phasewalk_correct_counter = 0;
		for i = 1, 5 do
			if phasewalk_indicator[i] == "Correct" then
				phasewalk_correct_counter = phasewalk_correct_counter + 1;
			end
		end
		
		if phasewalk_correct_counter == 5 then
			phasewalk_comment = "Perfect!";
		end
	end
	previousMovement = getMovementState();
	drawGUI()
	if not client.ispaused() then
		drawGUI();
	end
end

function drawGUI()
	row = 0;
	for i = 1, 5 do
		gui.text(32, 32 + (16 * row), "Frame "..i..": "..phasewalk_indicator[i], nil, 'topleft')
		row = row + 1;
	end
	gui.text(32, 32 + (16 * row), "------------------", nil, 'topleft')
	row = row + 1;
	gui.text(32, 32 + (16 * row), "Comment: "..phasewalk_comment, nil, 'topleft')
end

event.onframestart(everyFrame, "Every Frame");
event.onloadstate(everyFrame, "Every Frame");