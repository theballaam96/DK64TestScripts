coordinates = {
	start = {1635,1387},
	finish = {1393,2287},
};

closeness_tolerance = 0.5;
stateslot = 4;

function getPosition()
	player_header = mainmemory.read_u32_be(0x7FBB4C) - 0x80000000;
	x_pos = mainmemory.readfloat(player_header + 0x7C,true);
	z_pos = mainmemory.readfloat(player_header + 0x84,true);
	coords_array = {x_pos,z_pos};
	return coords_array;
end

function checkSign(value)
	if value == 0 then
		value = 1;
	end
	sign = value / math.abs(value);
	return sign;
end

function checkCloseness(x,z)
	reference = x;
	ref_z = z;
	difference_x = coordinates.finish[1] - coordinates.start[1];
	difference_z = coordinates.finish[2] - coordinates.start[2];
	increment_z = difference_z / difference_x;
	z_optimal = coordinates.start[2] + (increment_z * (reference - coordinates.start[1]));
	closeness = math.abs(ref_z - z_optimal);
	return closeness;
end

function getDirectionOfTravel()
	dir_x = coordinates.finish[1] - coordinates.start[1];
	dir_x_actual = checkSign(dir_x);
	dir_z = coordinates.finish[2] - coordinates.start[2];
	dir_z_actual = checkSign(dir_z);
	direction_array = {dir_x_actual, dir_z_actual};
	return direction_array;
end

function checkDistanceTravelled(x,z)
	diff_x = x - previous[1];
	diff_z = z - previous[2];
	distance_travelled = math.sqrt((diff_x ^ 2) + (diff_z ^ 2));
	correct_direction = getDirectionOfTravel();
	diff_x_sign = checkSign(diff_x);
	diff_z_sign = checkSign(diff_z);
	if diff_x_sign == correct_direction[1] then
		if diff_z_sign == correct_direction[2] then
			return distance_travelled;
		end
	end
	return 0;
end

function processInputStructure(inp_x, inp_z)
	pos = getPosition();
	x_position = pos[1];
	z_position = pos[2];
	dist = checkDistanceTravelled(x_position,z_position);
	close_rating = checkCloseness(x_position,z_position);
	if close_rating < closeness_tolerance then
		if dist == best_dist then
			best_dist = dist;
			best_inpx = inp_x;
			best_inpz = inp_z;
		elseif dist > best_dist then
			best_dist = dist;
			best_inpx = inp_x;
			best_inpz = inp_z;
		end
	end
end

function incrementRerecCount()
	rerec_count = movie.getrerecordcount();
	movie.setrerecordcount(rerec_count + 1);
end

function setInput(i_x,i_z)
	joypad_input = {["X Axis"] = i_x,    ["Y Axis"] = i_z};
	joypad.setanalog(joypad_input, 1);
end

function scanInputs()
	savestate.loadslot(stateslot);
	incrementRerecCount();
	previous = getPosition();
	best_dist = 0;
	best_inpx = 0;
	best_inpz = 0;
	isLF = false;
	emu.frameadvance();
	isLF = emu.islagged();
	if not isLF then
		for input_x = -128, 127 do
			input_z = 127;
			savestate.loadslot(stateslot);
			incrementRerecCount()
			setInput(input_x,input_z);
			emu.frameadvance();
			processInputStructure();
			input_z = -128;
			savestate.loadslot(stateslot);
			incrementRerecCount()
			setInput(input_x,input_z);
			emu.frameadvance();
			processInputStructure();
		end
		for input_z = -128, 127 do
			input_x = 127;
			savestate.loadslot(stateslot);
			incrementRerecCount()
			setInput(input_x,input_z);
			emu.frameadvance();
			processInputStructure();
			input_x = -128;
			savestate.loadslot(stateslot);
			incrementRerecCount()
			setInput(input_x,input_z);
			emu.frameadvance();
			processInputStructure();
		end
	end
	savestate.loadslot(stateslot);
	incrementRerecCount()
	setInput(best_inpx,best_inpz);
	print("Best Input: "..best_inpx..","..best_inpz);
	emu.frameadvance();
	savestate.saveslot(stateslot);
end

while true do
	scanInputs();
end