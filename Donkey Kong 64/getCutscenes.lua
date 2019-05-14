function isLoading()
	return mainmemory.read_u32_be(0x76A064) < 5 or mainmemory.read_u32_be(0x76A064) > 11527;
end

function getTimeUI(value)
	total = value;
	totalmin = math.floor(total / 60);
	sec = total - (totalmin * 60);
	totalhour = math.floor(totalmin / 60);
	mindisp = totalmin - (totalhour * 60);
	secdisp = math.floor(100 * sec) / 100;
	if secdisp < 10 then
		secinterval = "0";
	else
		secinterval = "";
	end
	if mindisp < 10 then
		mininterval = "0";
	else
		mininterval = "";
	end
	timedisp = totalhour..":"..mininterval..mindisp..":"..secinterval..secdisp;
	return timedisp;
end

function drawGUI()
	row = 0;
	gui.text(32, 32 + (16 * row), "Map: "..map_value.."/ 216", nil, 'topleft')
	row = row + 2;
	gui.text(32, 32 + (16 * row), "Cutscenes: "..cutscenes_so_far, nil, 'topleft')
	row = row + 1;
	timeshown = getTimeUI(time_so_far);
	gui.text(32, 32 + (16 * row), "Total Cutscene Time: "..timeshown, nil, 'topleft')
end

function advance()
	savestate.loadslot(6);
	cutsceneArray[cutscene_number + 1] = previous_cutscene_timer;
	cutscene_number = cutscene_number + 1;
	cutscenes_so_far = cutscenes_so_far + 1;
	time_so_far = time_so_far + (previous_cutscene_timer / 30);
end

main_levels = {
	[1] = 0x7,
	[2] = 0x26,
	[3] = 0x1A,
	[4] = 0x1E,
	[5] = 0x30,
	[6] = 0x48,
	[7] = 0x57,
};

blacklisted_maps = {
	[1] = 0x2;
	[2] = 0x9;
};

function everyframe()
	drawGUI();
	if not client.ispaused() then
		drawGUI();
	end
end

cutscenes_so_far = 0;
time_so_far = 0;
map_value = 0;

event.onframeend(everyframe, "Every Frame")
event.onloadstate(everyframe, "Every Frame")

base_frame = 201887;

while map_value < 216 do
	for i = 1, #blacklisted_maps do
		if blacklisted_maps[i] == map_value then
			map_value = map_value + 1;
		end
	end
	cutscene_number = 0;
	number_of_cutscenes = 10;
	cutsceneArray = {};
	while cutscene_number < number_of_cutscenes + 1 do
		isMainLevel = 0;
		previous_cutscene_timer_frame = base_frame;
		previous_real_frame = base_frame;
		savestate.loadslot(6);
		mainmemory.write_u32_be(0x7444E4,map_value);
		mainmemory.writebyte(0x75533B,1);
		mainmemory.write_u16_be(0x75533E, cutscene_number);
		mainmemory.write_u16_be(0x7476F4, cutscene_number);
		for i = 1, #main_levels do
			if main_levels[i] == map_value then
				isMainLevel = 1;
			end
		end
		mainmemory.write_u32_be(0x7444E8, isMainLevel);
		forLoopLength = 3600;
		forLoopTimer = base_frame;
		while forLoopTimer < base_frame + forLoopLength do
			cutscene_value = mainmemory.read_u16_be(0x7476F4);
			cutscene_active = mainmemory.readbyte(0x7444EC);
			if cutscene_value == cutscene_number and cutscene_active > 0 then
				-- Cutscene hasn't changed values
				previous_cutscene_timer = mainmemory.read_u16_be(0x7476F0);
				previous_cutscene_timer_frame = emu.framecount();
			elseif isLoading() then
				-- game is loading
				previous_cutscene_timer = mainmemory.read_u16_be(0x7476F0);
				previous_cutscene_timer_frame = emu.framecount();
			else
				forLoopLength = forLoopTimer - base_frame + 1;
				number_of_cutscenes = mainmemory.read_u16_be(0x7F5BDC) - 1;
			end
			forLoopTimer = emu.framecount();
			if forLoopTimer - previous_cutscene_timer_frame > 1800 then
				forLoopLength = forLoopTimer - base_frame + 1;
			end
			frames_lag = mainmemory.read_u32_be(0x76AF10);
			frames_real = mainmemory.read_u32_be(0x7F0560);
			if frames_lag == frames_real then
				previous_real_frame = emu.framecount();
			end
			if forLoopTimer - previous_real_frame > 150 then
				forLoopLength = forLoopTimer - base_frame + 1;
			end
			emu.frameadvance()
		end
		cutsceneArray[cutscene_number + 1] = previous_cutscene_timer;
		cutscene_number = cutscene_number + 1;
		cutscenes_so_far = cutscenes_so_far + 1;
		time_so_far = time_so_far + (previous_cutscene_timer / 30);
		emu.frameadvance()
	end

	print("Cutscene Times for Map: "..map_value);
	for i = 1, #cutsceneArray do
		print("Cutscene "..(i - 1)..": "..cutsceneArray[i]);
	end
	map_value = map_value + 1;
	emu.frameadvance()
end