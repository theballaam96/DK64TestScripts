processKey = 1;
eventCounter = 0;

while processKey == 1 do
	savestate.loadslot(6);
	mainmemory.writebyte(0x33F54,eventCounter)
	
	emu.frameadvance();
	emu.frameadvance();
	
	cutscene = mainmemory.read_u16_be(0x7476F4);
	active = mainmemory.readbyte(0x7444EC);
	
	if active > 0 then
		print("Event "..eventCounter.." | Cutscene "..cutscene);
	end
	
	eventCounter = eventCounter + 1;
	emu.frameadvance();
end