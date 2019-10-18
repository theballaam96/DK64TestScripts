function autoDanceSkip()
	mainmemory.write_u32_be(0x6EFB9C, 0x0) -- Cancel Movement Write
	mainmemory.write_u32_be(0x6EFC1C, 0x0) -- Cancel CS Play Function Call
	mainmemory.write_u32_be(0x6EFB88, 0x0) -- Cancel Animation Write Function Call
	mainmemory.write_u32_be(0x6EFC0C, 0x0) -- Cancel Change Rotation Write
end
autoDanceSkip()