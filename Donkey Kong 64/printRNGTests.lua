amount_of_values = 1000;

for i = 1, amount_of_values do
	input = math.floor(math.random() * 0x100000000);
	savestate.loadslot(4);
	mainmemory.write_u32_be(0x746A40,input);
	emu.frameadvance();
	emu.frameadvance();
	output = mainmemory.read_u32_be(0x746A40);
	print("test(0x"..bizstring.hex(input)..", 0x"..bizstring.hex(output)..");");
end

emu.yield();