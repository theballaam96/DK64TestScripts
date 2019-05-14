for i = 0, 0x7FFFFF do
	savestate.loadslot(0);
	address = i;
	previousvalue = mainmemory.readbyte(i);
	emu.frameadvance();
	mainmemory.writebyte(i,previousvalue);
	emu.frameadvance();
	mainmemory.writebyte(i,previousvalue);
	cutscene = mainmemory.read_u16_be(0x7476F4);
	if cutscene ~= 8 then
		print("Memory Address "..i.." influences DDQ");
		print("Previous Value: "..previousvalue);
		print("");
	end
end

emu.yield();