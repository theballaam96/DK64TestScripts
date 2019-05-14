function toHexString(value, desiredLength, prefix)
	value = string.format("%X", value or 0);
	value = string.lpad(value, desiredLength or string.len(value), '0');
	return (prefix or "0x")..value;
end

function printCoords(address,nonfloat)
	currentMap = toHexString(mainmemory.read_u32_be(0x76A0A8));
	if nonfloat == false then
		x_coord = mainmemory.readfloat(address + 0x7C, true);
		z_coord = mainmemory.readfloat(address + 0x84, true);
		print("{"..currentMap..","..x_coord..","..z_coord.."}");
	else
		x_coord = toHexString(mainmemory.read_u32_be(address + 0x7C));
		z_coord = toHexString(mainmemory.read_u32_be(address + 0x84));
		print("{"..currentMap..","..x_coord..","..z_coord.."}");
	end
end