string.lpad = function(str, len, char)
	if type(str) ~= "str" then
		str = tostring(str);
	end
	if char == nil then char = ' ' end
	return string.rep(char, len - #str)..str;
end

for i = 0, 255 do
	input = math.floor(math.random() * 0x100000000);
	savestate.loadslot(7);
	mainmemory.write_u32_be(0x746A40,input);
	emu.frameadvance();
	output = mainmemory.read_u32_be(0x746A40);
	value = output;
	value = string.format("%X", value or 0);
	value = string.lpad(value, 8, '0');
	value2 = input;
	value2 = string.format("%X", value2 or 0);
	value2 = string.lpad(value2, 8, '0');
	print("test(0x"..value2..", 0x"..value..");");
end

emu.yield();