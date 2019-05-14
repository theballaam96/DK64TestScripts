-- DK64 Glitch Removal lua
-- Created by theballaam96SRL
-- Credit to Isotarge and the rest of the ScriptHawk crew for a lot of this code and a lot of this discovery
-- ScriptHawk can be found here: https://github.com/Isotarge/ScriptHawk

function isRDRAM(value)
	return type(value) == "number" and value >= 0 and value < 0x800000;
end

function getPlayerObject()
	playerPointer = mainmemory.read_u32_be(0x7FBB4C) - 0x80000000;
	return playerPointer;
end

function isInSubGame()
	current_map = mainmemory.read_u32_be(0x76A0A8);
	return current_map == 2 or current_map == 9;
end

flag_array = {};
set_bit = bit.set;
check_bit = bit.check;
clear_bit = bit.clear;

function setFlag(byte, bit)
	currenteepromslot = 0;
	for i = 0, 3 do
		if mainmemory.readbyte(0x7EDEA8 + i) == mainmemory.readbyte(0x7467C8) then
			currenteepromslot = i;
		end
	end
	flags = 0x7ECEA8 + (currenteepromslot * 0x1AC);
	local currentValue = mainmemory.readbyte(flags + byte);
	mainmemory.writebyte(flags + byte, set_bit(currentValue, bit));
end

function clearFlag(byte, bit)
	currenteepromslot = 0;
	for i = 0, 3 do
		if mainmemory.readbyte(0x7EDEA8 + i) == mainmemory.readbyte(0x7467C8) then
			currenteepromslot = i;
		end
	end
	flags = 0x7ECEA8 + (currenteepromslot * 0x1AC);
	local currentValue = mainmemory.readbyte(flags + byte);
	mainmemory.writebyte(flags + byte, clear_bit(currentValue, bit));
end

function checkFlag(byte, bit)
	currenteepromslot = 0;
	for i = 0, 3 do
		if mainmemory.readbyte(0x7EDEA8 + i) == mainmemory.readbyte(0x7467C8) then
			currenteepromslot = i;
		end
	end
	flags = 0x7ECEA8 + (currenteepromslot * 0x1AC);
	local currentValue = mainmemory.readbyte(flags + byte);
	if check_bit(currentValue, bit) then
		return true;
	else
		return false;
	end
end

function getYRotation()
	if not isInSubGame() then
		local playerObject = getPlayerObject();
		if isRDRAM(playerObject) then
			return mainmemory.read_u16_be(playerObject + 0xE6);
		end
	end
	return 0;
end

function fixYRotation()
	currentAngle = getYRotation();
	newAngle = currentAngle % 4096;
	if not isInSubGame() then
		local playerObject = getPlayerObject();
		if isRDRAM(playerObject) then
			mainmemory.write_u16_be(playerObject + 0xE6, newAngle);
		end
	end
end

function fixLagClips()
	frames_visual = mainmemory.read_u32_be(0x7F0560);
	mainmemory.write_u32_be(0x76AF10, frames_visual - 1);
end

function fixKey8()
	current_map = mainmemory.read_u32_be(0x76A0A8);
	if current_map == 17 then -- Is Helm
		key_8_exists = 0;
		local objModel2Array = mainmemory.read_u32_be(0x7F6000) - 0x80000000;
		if isRDRAM(objModel2Array) then
			local numSlots = mainmemory.read_u32_be(0x7F6004);
			for i = 1, numSlots do
				pointer = objModel2Array + (i - 1) * 0x90;
				object_type = mainmemory.read_u16_be(pointer + 0x84);
				if object_type == 0x13C then -- Is Boss Key
					key_8_exists = 1;
				end
			end
		end
	end
	
	if checkFlag(0x60,2) and checkFlag(0x60,3) and checkFlag(0x60,4) then -- BoM Off, Coin Door, Crown Door
		if current_map == 17 then -- Is Helm
			if key_8_exists == 0 then
				setFlag(0x2F,4);
			else
				clearFlag(0x2F,4);
			end
		end
	else
		clearFlag(0x2F,4);
	end
end

function fixHelmMedals()
	current_map = mainmemory.read_u32_be(0x76A0A8);
	if current_map == 17 then -- Is Helm
		if checkFlag(0x60,2) then -- BoM Off
			local objModel2Array = mainmemory.read_u32_be(0x7F6000) - 0x80000000;
			if isRDRAM(objModel2Array) then
				local numSlots = mainmemory.read_u32_be(0x7F6004);
				for i = 1, numSlots do
					pointer = objModel2Array + (i - 1) * 0x90;
					object_type = mainmemory.read_u16_be(pointer + 0x84);
					if object_type == 0x90 then -- Is Helm Medal
						behaviourPointer = mainmemory.read_u32_be(pointer + 0x7C) - 0x80000000;
						mainmemory.writebyte(behaviourPointer + 0x60, 0); -- Medal is collectable
						mainmemory.writebyte(behaviourPointer + 0x54, 2); -- Medal state has been checked
					end
				end
			end
		end
	end
end

function fixMoonkicks()
	local playerObject = getPlayerObject();
	kong = mainmemory.readbyte(0x74E77C);
	if isRDRAM(playerObject) then
		movementState = mainmemory.readbyte(playerObject + 0x154);
	end
	if kong == 0 then -- Is DK
		if movementState == 0x29 then -- Moving Ground Attack (Regular Kick / Moonkick)
			if not isInSubGame() then
				local playerObject = getPlayerObject();
				if isRDRAM(playerObject) then
					return mainmemory.writefloat(playerObject + 0xC4, -20, true);
				end
			end
		end
	end
end

function fixTBS()
	if mainmemory.readbyte(0x7444EC) == 1 then	-- Cutscene Active
		if mainmemory.read_u16_be(0x7476F4) == 14 then -- Cutscene 14 (Map or Kong)
			cutsceneType = mainmemory.read_u32_be(0x7476FC) - 0x80000000;
			if cutsceneType == 0x7F5BF0 then -- Kong cutscene (AKA Tag Barrel CS)
				local playerObject = getPlayerObject();
				if isRDRAM(playerObject) then
					mainmemory.writebyte(playerObject + 0x154, 0x42);
				end
			end
		end
	end
end

function fixKeySkipping()
	current_map = mainmemory.read_u32_be(0x76A0A8);
	if checkFlag(0x37,4) and checkFlag(0x37,5) and checkFlag(0x37,6) and checkFlag(0x37,7) and checkFlag(0x38,0) and checkFlag(0x38,1) and checkFlag(0x38,2) and checkFlag(0x38,3) then
	-- Checks for all 8 keys
	else -- Not all 8 keys
		if current_map == 0xCB or current_map == 0xCC or current_map == 0xCD or current_map == 0xCE or current_map == 0xCF or current_map == 0xD6 or current_map == 0xD7 then
		-- Is in K Rool map
			mainmemory.write_u32_be(0x7444E4,0); -- Test map destination map
			voidByteValue = mainmemory.readbyte(0x7FBB62);
			mainmemory.writebyte(0x7FBB62, set_bit(voidByteValue, 0)); -- Force Zipper
		end
	end
	
	if checkFlag(0x37,3) then -- Japes Rock
	else
		if current_map == 0xA9 then -- Japes Lobby
			mainmemory.write_u32_be(0x7444E4,0x1C); -- Fake Helm destination map
			mainmemory.write_u32_be(0x7444E8,0x1); -- Kong Prison Destination Exit
			voidByteValue = mainmemory.readbyte(0x7FBB62);
			mainmemory.writebyte(0x7FBB62, set_bit(voidByteValue, 0)); -- Force Zipper
		end
	end
	
	if checkFlag(0x37,4) then -- Key 1
	else
		if current_map == 0xAD then -- Aztec Lobby
			mainmemory.write_u32_be(0x7444E4,0x1C); -- Fake Helm destination map
			mainmemory.write_u32_be(0x7444E8,0x1); -- Kong Prison Destination Exit
			voidByteValue = mainmemory.readbyte(0x7FBB62);
			mainmemory.writebyte(0x7FBB62, set_bit(voidByteValue, 0)); -- Force Zipper
		end
	end
	
	if checkFlag(0x37,4) and checkFlag(0x37,5) then -- Keys 1 & 2
		if current_map == 0xAF then -- Factory Lobby
			mainmemory.write_u32_be(0x7444E4,0x1C); -- Fake Helm destination map
			mainmemory.write_u32_be(0x7444E8,0x1); -- Kong Prison Destination Exit
			voidByteValue = mainmemory.readbyte(0x7FBB62);
			mainmemory.writebyte(0x7FBB62, set_bit(voidByteValue, 0)); -- Force Zipper
		end
	end
	
	if checkFlag(0x37,4) and checkFlag(0x37,5) then -- Keys 1 & 2
	else
		if current_map == 0xAE then -- Galleon Lobby
			mainmemory.write_u32_be(0x7444E4,0x1C); -- Fake Helm destination map
			mainmemory.write_u32_be(0x7444E8,0x1); -- Kong Prison Destination Exit
			voidByteValue = mainmemory.readbyte(0x7FBB62);
			mainmemory.writebyte(0x7FBB62, set_bit(voidByteValue, 0)); -- Force Zipper
		end
	end
	
	if checkFlag(0x37,4) and checkFlag(0x37,5) and checkFlag(0x37,7) then -- Keys 1, 2 & 4
	else
		if current_map == 0xB2 then -- Fungi Lobby
			mainmemory.write_u32_be(0x7444E4,0x1C); -- Fake Helm destination map
			mainmemory.write_u32_be(0x7444E8,0x1); -- Kong Prison Destination Exit
			voidByteValue = mainmemory.readbyte(0x7FBB62);
			mainmemory.writebyte(0x7FBB62, set_bit(voidByteValue, 0)); -- Force Zipper
		end
	end
	
	if checkFlag(0x37,4) and checkFlag(0x37,5) and checkFlag(0x37,7) and checkFlag(0x38,0) then -- Keys 1, 2, 4 & 5
	else
		if current_map == 0xC2 then -- Caves Lobby
			mainmemory.write_u32_be(0x7444E4,0x1C); -- Fake Helm destination map
			mainmemory.write_u32_be(0x7444E8,0x1); -- Kong Prison Destination Exit
			voidByteValue = mainmemory.readbyte(0x7FBB62);
			mainmemory.writebyte(0x7FBB62, set_bit(voidByteValue, 0)); -- Force Zipper
		end
	end
	
	if checkFlag(0x37,4) and checkFlag(0x37,5) and checkFlag(0x37,7) and checkFlag(0x38,0) then -- Keys 1, 2, 4 & 5
	else
		if current_map == 0xC1 then -- Castle Lobby
			mainmemory.write_u32_be(0x7444E4,0x1C); -- Fake Helm destination map
			mainmemory.write_u32_be(0x7444E8,0x1); -- Kong Prison Destination Exit
			voidByteValue = mainmemory.readbyte(0x7FBB62);
			mainmemory.writebyte(0x7FBB62, set_bit(voidByteValue, 0)); -- Force Zipper
		end
	end
	
	if checkFlag(0x37,4) and checkFlag(0x37,5) and checkFlag(0x37,7) and checkFlag(0x38,0) and checkFlag(0x38,1) and checkFlag(0x38,2) then -- Keys 1, 2, 4, 5, 6 and 7
	else
		if current_map == 0xAA then -- Helm Lobby
			mainmemory.write_u32_be(0x7444E4,0x1C); -- Fake Helm destination map
			mainmemory.write_u32_be(0x7444E8,0x1); -- Kong Prison Destination Exit
			voidByteValue = mainmemory.readbyte(0x7FBB62);
			mainmemory.writebyte(0x7FBB62, set_bit(voidByteValue, 0)); -- Force Zipper
		end
	end
end

function eachFrame()
	fixYRotation();
	fixLagClips();
	fixKey8();
	fixHelmMedals();
	fixMoonkicks();
	fixTBS();
	fixKeySkipping();
end

event.onframestart(eachFrame, "What is running every frame");