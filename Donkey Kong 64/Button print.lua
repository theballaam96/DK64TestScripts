button_data_1 = 0x7ECD10 -- Bin
button_data_2 = 0x7ECD11 -- Bin
stick_x = 0x7ECD12 -- Signed
stick_y = 0x7ECD13 -- Signed

-- button_1
-- A 1000 0000
-- B 0100 0000
-- Z 0010 0000
-- S 0001 0000
-- DU 0000 1000
-- DD 0000 0100
-- DL 0000 0010
-- DR 0000 0001

-- button_2
-- L 0010 0000
-- R 0001 0000
-- CU 0000 1000
-- CD 0000 0100
-- CL 0000 0010
-- CR 0000 0001

function readButtonData()
	button_1 = mainmemory.readbyte(button_data_1);
	button_2 = mainmemory.readbyte(button_data_2);
	
	button_output_1 = {
		[1] = {0, "A"}, -- A
		[2] = {0, "B"}, -- B
		[3] = {0, "Z"}, -- Z
		[4] = {0, "S"}, -- S
		[5] = {0, "DU"}, -- DU
		[6] = {0, "DD"}, -- DD
		[7] = {0, "DL"}, -- DL
		[8] = {0, "DR"}, -- DR
	};
	button_output_2 = {
		[1] = {0, "?"},
		[2] = {0, "?"},
		[3] = {0, "L"}, -- L
		[4] = {0, "R"}, -- R
		[5] = {0, "CU"}, -- CU
		[6] = {0, "CD"}, -- CD
		[7] = {0, "CL"}, -- CL
		[8] = {0, "CR"}, -- CR
	};
	
	for i = 7, 0, -1 do
		if button_1 > ((2 ^ i) - 1) then
			button_output_1[8 - i][1] = 1;
			button_1 = button_1 - (2^i);
		end
		if button_2 > ((2 ^ i) - 1) then
			button_output_2[8 - i][1] = 1;
			button_2 = button_2 - (2^i);
		end
	end
end

function printButtonString()
	button_string = "";
	for i = 1, 8 do
		if button_output_1[i][1] == 1 then
			button_string = button_string..button_output_1[i][2].." ";
		else
			button_string = button_string.."- ";
		end
	end
	for i = 1, 8 do
		if button_output_2[i][1] == 1 then
			button_string = button_string..button_output_2[i][2].." ";
		else
			button_string = button_string.."- ";
		end
	end
	stick_x_value = mainmemory.read_s8(stick_x);
	stick_y_value = mainmemory.read_s8(stick_y);
	button_string = button_string.."X: "..stick_x_value.." Y: "..stick_y_value;
	print(button_string);
end

function everyFrame()
	readButtonData();
	printButtonString();
	if client.isPaused then
		readButtonData();
		printButtonString();
	end
end

event.onframestart(everyFrame, "Every Frame")