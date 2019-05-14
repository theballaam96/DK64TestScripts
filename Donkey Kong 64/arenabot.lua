for i = -128, 127 do
	savestate.loadslot(4);
	mainmemory.write_s8(0x744538,i);
	joypad.set({A=1}, 1);
	emu.frameadvance();
	map = mainmemory.read_u32_be(0x7444E4);
	if map < 216 then
		print("Arena "..i..": Map "..map);
	end
end