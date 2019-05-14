function compareValues(address1, address2, length, bytelength)
	-- Compares values from address 1 & 2 until +'length'
	-- Values compared are 'bytelength' bytes
	-- If address 1 relates to address 2 as determined by 'comparison'
		-- Then is printed in format determined by 'output'
		
	-- Comparisons: "=", "~=", ">", "<", ">=", "<="
		-- Equal, Not Equal, 1 greater than 2, 1 less than 2
		-- 1 greater than/equal to 2, 1 less than/equal to 2
	-- Bytelength: 1, 2, 4
	-- Output: "unsigned", "signed", "hex", "float"
		-- Float only works for 4-byte
		
	--if bytelength ~= 4 and outputformat == "float" then
	--	print("Float output can only be used for 4-byte searches");
	--end
	
	--if bytelength ~= 1 and bytelength ~= 2 and bytelength ~= 4 then
	--	print("Invalid Byte length");
	--end
	
	--if comparison ~= "=" and comparison ~= "~=" and comparison ~= ">" and comparison ~= "<" and comparison ~= ">=" and comparison ~= "<=" then
	--	print("Invalid Comparison");
	--end
	
	print("Address 1: "..address1);
	print("Address 2: "..address2);
	--print("Address 3: "..address3);
	--print("Address 4: "..address4);
	--print("Address 5: "..address5);
	
	for i = 0, length - 1 do
		newaddress1 = address1 + i;
		newaddress2 = address2 + i;
		--newaddress3 = address3 + i;
		--newaddress4 = address4 + i;
		--newaddress5 = address5 + i;
		
		if bytelength == 1 then
			value1 = mainmemory.readbyte(newaddress1);
			value2 = mainmemory.readbyte(newaddress2);
			--value3 = mainmemory.readbyte(newaddress3);
			--value4 = mainmemory.readbyte(newaddress4);
			--value5 = mainmemory.readbyte(newaddress5);
		end
		
		if bytelength == 2 then
			value1 = mainmemory.read_u16_be(newaddress1);
			value2 = mainmemory.read_u16_be(newaddress2);
			--value3 = mainmemory.read_u16_be(newaddress3);
			--value4 = mainmemory.read_u16_be(newaddress4);
			--value5 = mainmemory.read_u16_be(newaddress5);
		end
		
		if bytelength == 4 then
			value1 = mainmemory.read_u32_be(newaddress1);
			value2 = mainmemory.read_u32_be(newaddress2);
			--value3 = mainmemory.read_u32_be(newaddress3);
			--value4 = mainmemory.read_u32_be(newaddress4);
			--value5 = mainmemory.read_u32_be(newaddress5);
		end
		
		--if value1 == value2 and value2 == value3 and value3 == value4 then
		--	if value1 ~= 0 and value1 ~= 255 then
		--		print("+"..i..": Value = "..value1);
		--	end
		--end
		
		if value1 ~= value2 then
			--if value1 ~= 0 and value1 ~= 255 then
				print("+"..i..": Value 1 = "..value1..", Value 2: "..value2);
				mainmemory.writebyte(newaddress1,value2);
			--end
		end
	end
	
	-- compareValues(0x320738,0x320890,"=",0x100,1,"unsigned")
	-- compareValues(0x320738,0x320890,0x100,1,"unsigned")
	-- compareValues(0x320738,0x320890,0x100,1)
	-- compareValues(3278648,3278992,256)
	
	-- compareValues(0x3206C8,0x320820,0x158,1)
	
	-- compareValues(0x304b58+0x340,0x3165F0+0x340,0x40,1)
end