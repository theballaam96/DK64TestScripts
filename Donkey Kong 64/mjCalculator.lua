-- For EmoArbiter

--[[
	0 | 1 | 2 | 3
	4 | 5 | 6 | 7
	8 | 9 | A | B
	C | D | E | F
]]--

--[[
	Checks:
	- If Kong & MJ are in the same position, list as distance = 6 to deter
	- MJ and Switch cannot be in the same position
	- MJ and Switch must be on the same square type
]]--

function Set (list)
  local set = {}
  for _, l in ipairs(list) do set[l] = true end
  return set
end

function calculateDistanceToSwitch(kong,mj,switch)
	kong_xy = {(kong % 4), math.floor(kong / 4)};
	mj_xy = {(mj % 4), math.floor(mj / 4)};
	switch_xy = {(switch % 4), math.floor(switch / 4)};
	testing_xy = {};
	current_xy = {};
	current_xy[1] = kong_xy[1];
	current_xy[2] = kong_xy[2];
	distance = 0;
	for iterations = 1, 6 do
		new_pos_found = false;
		applied_xy_test = {};
		applied_xy_test[1] = current_xy[1];
		applied_xy_test[2] = current_xy[2];
		if applied_xy_test[1] > switch_xy[1] and applied_xy_test[2] > switch_xy[2] and not new_pos_found then
		    testing_xy[1] = current_xy[1] - 1;
			testing_xy[2] = current_xy[2] - 1;
			if mj_xy[1] ~= testing_xy[1] or mj_xy[2] ~= testing_xy[2] then
				new_pos_found = true;
				current_xy[1] = testing_xy[1];
				current_xy[2] = testing_xy[2];
				distance = distance + math.sqrt(2);
				-- print("UL")
			end
		elseif applied_xy_test[1] > switch_xy[1] and applied_xy_test[2] < switch_xy[2] and not new_pos_found then
			testing_xy[1] = current_xy[1] - 1;
			testing_xy[2] = current_xy[2] + 1;
			if mj_xy[1] ~= testing_xy[1] or mj_xy[2] ~= testing_xy[2] then
				new_pos_found = true;
				current_xy[1] = testing_xy[1];
				current_xy[2] = testing_xy[2];
				distance = distance + math.sqrt(2);
				-- print("DL")
			end
		elseif applied_xy_test[1] < switch_xy[1] and applied_xy_test[2] > switch_xy[2] and not new_pos_found then
			testing_xy[1] = current_xy[1] + 1;
			testing_xy[2] = current_xy[2] - 1;
			if mj_xy[1] ~= testing_xy[1] or mj_xy[2] ~= testing_xy[2] then
				new_pos_found = true;
				current_xy[1] = testing_xy[1];
				current_xy[2] = testing_xy[2];
				distance = distance + math.sqrt(2);
				-- print("UR")
			end
		elseif applied_xy_test[1] < switch_xy[1] and applied_xy_test[2] < switch_xy[2] and not new_pos_found then
			testing_xy[1] = current_xy[1] + 1;
			testing_xy[2] = current_xy[2] + 1;
			if mj_xy[1] ~= testing_xy[1] or mj_xy[2] ~= testing_xy[2] then
				new_pos_found = true;
				current_xy[1] = testing_xy[1];
				current_xy[2] = testing_xy[2];
				distance = distance + math.sqrt(2);
				-- print("DR")
			end
	    end
	    
	    if applied_xy_test[1] > switch_xy[1] and not new_pos_found then
			testing_xy[1] = current_xy[1] - 1;
			testing_xy[2] = current_xy[2];
			if mj_xy[1] ~= testing_xy[1] or mj_xy[2] ~= testing_xy[2] then
				new_pos_found = true;
				current_xy[1] = testing_xy[1];
				current_xy[2] = testing_xy[2];
				distance = distance + 1;
				-- print("L")
			end
			
		elseif applied_xy_test[1] < switch_xy[1] and not new_pos_found then
			testing_xy[1] = current_xy[1] + 1;
			testing_xy[2] = current_xy[2];
			if mj_xy[1] ~= testing_xy[1] or mj_xy[2] ~= testing_xy[2] then
				new_pos_found = true;
				current_xy[1] = testing_xy[1];
				current_xy[2] = testing_xy[2];
				distance = distance + 1;
				-- print("R")
			end
		elseif applied_xy_test[2] > switch_xy[2] and not new_pos_found then
			testing_xy[1] = current_xy[1];
			testing_xy[2] = current_xy[2] - 1;
			if mj_xy[1] ~= testing_xy[1] or mj_xy[2] ~= testing_xy[2] then
				new_pos_found = true;
				current_xy[1] = testing_xy[1];
				current_xy[2] = testing_xy[2];
				distance = distance + 1;
				-- print("U")
			end
		elseif applied_xy_test[2] < switch_xy[2] and not new_pos_found then
			testing_xy[1] = current_xy[1];
			testing_xy[2] = current_xy[2] + 1;
			if mj_xy[1] ~= testing_xy[1] or mj_xy[2] ~= testing_xy[2] then
				new_pos_found = true;
		    	current_xy[1] = testing_xy[1];
				current_xy[2] = testing_xy[2];
				distance = distance + 1;
				-- print("D")
			end
		end
	end
	return distance
end

white_spaces_lookup = Set{0,2,5,7,8,10,13,15};
white_spaces = {0,2,5,7,8,10,13,15};
blue_spaces = {1,3,4,6,9,11,12,14};

kong_analysis = {};
kong_totals = {};
for i = 0, 15 do
	kong_analysis[i] = 0;
	kong_totals[i] = 0;
end
kong_mj_analysis = {};
kong_mj_totals = {};
for i = 0, 255 do
	kong_mj_analysis[i] = 0;
	kong_mj_totals[i] = 0;
end

for kong_location = 0, 15 do
	for mj_location = 0, 15 do
		if white_spaces_lookup[mj_location] then
			mj_colour = "white"
		else
			mj_colour = "blue"
		end
		for switch_location_lookup = 1, 8 do
			if mj_colour == "white" then
				switch_location = white_spaces[switch_location_lookup];
			else
				switch_location = blue_spaces[switch_location_lookup];
			end
			if switch_location ~= mj_location then
				print(kong_location.."|"..mj_location.."|"..switch_location)
				if kong_location == mj_location then
					distance = 6; -- Deter tactic
				else
					distance = calculateDistanceToSwitch(kong_location,mj_location,switch_location)
				end
				kong_mj_code = (16 * kong_location) + mj_location;
				kong_analysis[kong_location] = kong_analysis[kong_location] + distance;
				kong_mj_analysis[kong_mj_code] = kong_mj_analysis[kong_mj_code] + distance;
				kong_totals[kong_location] = kong_totals[kong_location] + 1;
				kong_mj_totals[kong_mj_code] = kong_mj_totals[kong_mj_code] + 1;
			end
		end
	end
end

print("KONG POSITION ANALYSIS")
for i = 0, 15 do
	avg = kong_analysis[i] / kong_totals[i];
	print("Kong Position "..i..", Avg Distance: "..avg)
end
print("")
print("KONG MJ POSITION ANALYSIS")
for i = 0, 255 do
	avg = kong_mj_analysis[i] / kong_mj_totals[i];
	print("Kong Position "..math.floor(i / 16)..", MJ Position "..(i%16)..", Avg Distance: ".. avg)
end