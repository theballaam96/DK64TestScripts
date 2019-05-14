for i = 0, 255 do
		savestate.loadslot(7);
		mainmemory.writebyte(0x746A43,i);
		emu.frameadvance();
		previous_output = output;
		output = mainmemory.readbyte(0x746A43);
		if previous_output == nil then
			print("In: "..i..", Out: "..output);
		else
			difference = (output - previous_output) % 256;
			print("In: "..i..", Out: "..output.."(Increment:"..difference..")");
		end
end

emu.yield();
