previous_failed = 570;
previous_successful = 567

while true do
	savestate.loadslot(4);
	next_to_do = (previous_failed + previous_successful) / 2;
	mainmemory.writefloat(0x4A93EC, next_to_do, true);
	x_pos = mainmemory.readfloat(0x4A93EC, true);
	y_pos = mainmemory.readfloat(0x4A93F0, true);
	while x_pos > 100 or (y_pos > 610 and x_pos > 100 and x_pos < 114) do
		emu.frameadvance();
		x_pos = mainmemory.readfloat(0x4A93EC, true);
		y_pos = mainmemory.readfloat(0x4A93F0, true);
		emu.yield();
	end
	if x_pos < 100 then -- failed
		previous_failed = next_to_do;
	else
		previous_successful = next_to_do;
	end
	emu.yield();
end