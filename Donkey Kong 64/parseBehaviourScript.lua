function isValidPointer(addr)
	if addr >= 0x80000000 and addr < 0x80800000 then
		return true
	end
	return false
end

function derefPtr(addr)
	ptr = mainmemory.read_u32_be(addr)
	if isValidPointer(ptr) then
		return ptr - 0x80000000
	end
	return 0
end

command_struct = {
	command = 0x0,
	command_param_1 = 0x2,
	command_param_2 = 0x4,
	command_param_3 = 0x6,
}

function parseObjectScript(objectAddr)
	behaviour_pointer = derefPtr(objectAddr + 0x7C)
	if behaviour_pointer ~= 0 then
		behaviour_script = derefPtr(behaviour_pointer + 0xA0)
		if behaviour_script ~= 0 then
			conditional_count = mainmemory.readbyte(behaviour_script)
			master_loop_control = true
			while master_loop_control do
				if conditional_count ~= 0 then
					scriptCommandAddr = behaviour_script + 2
					for i = 1, conditional_count do
						grabConditional(0, scriptCommandAddr,behaviour_pointer,0)
						scriptCommandAddr = scriptCommandAddr + 8
					end
				end
				execution_count = mainmemory.readbyte(behaviour_script + 0x2A)
				if execution_count ~= 0 then
					scriptCommandAddr = behaviour_script + 0x2C
					for i = 1, execution_count do
						grabExecutional(0, scriptCommandAddr, behaviour_pointer, 0)
						scriptCommandAddr = scriptCommandAddr + 8
					end
				end
				if conditional_count ~= 0 then
					for i = 1, conditional_count do
						display("}")
					end
				end
				behaviour_script = derefPtr(behaviour_script + 0x4C)
				if behaviour_script == 0 then
					master_loop_control = false
				end
				conditional_count = mainmemory.readbyte(behaviour_script)
				emu.yield();
			end
		end
	end
end

function display(str)
	print(str)
end

function grabConditional(param_1, ScriptCommand,behaviour,param_3)
	-- Seem to be if statements
	functionType = bit.band(mainmemory.read_u16_be(ScriptCommand + command_struct.command),0x7FFF)
	inverseFlag = bit.band(mainmemory.read_u16_be(ScriptCommand + command_struct.command),0x8000)
	inverseFlagChar = ""
	inverseFlagInvertedChar = "!"
	if inverseFlag ~= 0 then
		inverseFlag = 1;
		inverseFlagChar = "!"
		inverseFlagInvertedChar = ""
	else
		inverseFlagChar = ""
		inverseFlagInvertedChar = "!"
	end
	if functionType == 0 then
		display(
			"if ("
			..inverseFlagChar
			.."true) {"
		)
	elseif functionType == 1 then
		display(
			"if (*(byte *)(behaviour + 0x"
			..bizstring.hex(mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2) + 0x48)
			..") "
			..inverseFlagChar
			.."== "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..") {"
		)
	-- elseif functionType == 2 then
	elseif functionType == 3 then
		display("if (1 == 0) {")
	elseif functionType == 4 then
		display(
			"if (*(ushort *)(behaviour + 0x"
			..bizstring.hex((mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2) * 2) + 0x44)
			..") "
			..inverseFlagChar
			.."== "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..") {"
		)
	elseif functionType == 5 then
		display(
			"if (FUN_806425FC("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..") "
			..inverseFlagInvertedChar
			.."== 0) {"
		)
	elseif functionType == 6 then
		display(
			"if (FUN_"
			..bizstring.hex(0x80748048 + (mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1) * 4))
			.."(behaviour,param_4,"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3)
			..") "
			..inverseFlagInvertedChar
			.."== 0) {"
		)
	elseif functionType == 7 then
		display(
			"if (FUN_80642500(behaviour + 0x14,"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..") "
			..inverseFlagInvertedChar
			.."== 0) {"
		)
	elseif functionType == 8 then
		display(
			"if (*(byte *)(behaviour + 0x51) "
			..inverseFlagInvertedChar
			.."== 0) {"
		)
	elseif functionType == 9 then
		display(
			"if (*(byte *)(behaviour + 0x52) "
			..inverseFlagInvertedChar
			.."== 0) {"
		)
	--elseif functionType == 10 then
	--elseif functionType == 11 then
	elseif functionType == 12 then
		display(
			"if ("
			..inverseFlagInvertedChar
			.."(((((FLOAT_807F621C == FLOAT_807F61FC) && (FLOAT_807F6220 == 1729.11706543)) && ((FLOAT_807F6224 == 3433.54956055 && ((FLOAT_807F6228 == 330 && (FLOAT_807F622C == 170)))))) && (FLOAT_807F6230 == 0)) && (FLOAT_807F6234 == 1))) {"
		)
	--elseif functionType == 13 then
	elseif functionType == 14 then
		display(
			"if (FUN_80641F70(param_1,"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..")"
			..inverseFlagInvertedChar
			.."== 0) {"
		)
	elseif functionType == 15 then
		display(
			"if (FUN_80723C98(*(word *) (behaviour + 0x38)) "
			..inverseFlagInvertedChar
			.."== 0) {"
		)
	-- functionTypes 16 > 24
	elseif functionType == 25 then
		display(
			"if (*(int *)(PlayerPointer->ActorType) "
			..inverseFlagChar
			.."== "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..") {"
		)
	-- functionTypes 26 > 44
	elseif functionType == 45 then
		display(
			"if (checkFlag(0x"
			..bizstring.hex(math.floor(mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1) / 8))
			..">"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1) % 8
			..",'Permanent') "
			..inverseFlagInvertedChar
			.."== 0) {"
		)
	-- functionTypes 46 > 49
	elseif functionType == 50 then
		display(
			"if (*(ushort *)PreviousMap "
			..inverseFlagChar
			.."== "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..") {"
		)
	-- functionTypes 51 > 53
	elseif functionType == 54 then
		display(
			"if (checkFlag(0x"
			..bizstring.hex(math.floor(mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1) / 8))
			..">"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1) % 8
			..",'Temporary') "
			..inverseFlagInvertedChar
			.."== 0) {"
		)
	-- functionTypes 55
	elseif functionType == 56 then
		display(
			"if ("
			..inverseFlagChar
			.."(*(byte *)Character < 5)) {"
		)
	-- functionTypes 57 & 58
	elseif functionType == 59 then
		display(
			"if (checkFlag(0x"
			..bizstring.hex(math.floor(mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1) / 8))
			..">"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1) % 8
			..",'Global') "
			..inverseFlagInvertedChar
			.."== 0) {"
		)
	-- functionTypes 60 & 61
	else
		display("if (["
		..functionType
		..","
		..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
		..","
		..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
		..","
		..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3)
		.."]) {")
	end
end

function grabExecutional(param_1, ScriptCommand,behaviour,param_3)
	functionType = mainmemory.read_u16_be(ScriptCommand + command_struct.command)
	if functionType == 0 then
		display(
			"FUN_80642748("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..","
			..behaviour
			..")"
		)
	elseif functionType == 1 then
		display(
			"behaviour + 0x"
			..bizstring.hex(mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2) + 0x4B)
			.." = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
		)
	elseif functionType == 2 then
		display(
			"FUN_80723284("
			..mainmemory.read_u32_be(behaviour + 0x38)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..")"
		)
	elseif functionType == 3 then
		if mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1) == 0 then
			display(
				"behaviour + 0x"
				..bizstring.hex((mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3) * 2) + 0x44)
				.." = "
				..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			)
		else
			display(
				"behaviour + 0x"
				..bizstring.hex((mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3) * 2) + 0x44)
				.." = mainmemory.read_s16_be(behaviour + 0x"
				..bizstring.hex((mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2) * 4) + 0x14)
				..")"
			)
		end
	elseif functionType == 4 then
		display(
			"FUN_80723484("
			..mainmemory.read_u32_be(behaviour + 0x38)
			..")"
		)
		display(
			"FUN_807238D4("
			..mainmemory.read_u32_be(behaviour + 0x38)
			..",0x807F621C,0x807F6220,0x807F6224)"
		)
	elseif functionType == 5 then
		display(
			"FUN_806418E8("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..",behaviour)"
		)
	elseif functionType == 6 then
		display(
			"behaviour + 0x"
			..bizstring.hex((mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1) * 4) + 0x14)
			.." = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2) / 10
		)
	elseif functionType == 7 then
		display(
			"runCode(0x"
			..bizstring.hex(0x80747E70 + (mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1) * 4))
			.."(behaviour,param_4,"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3)
			.."))"
		)
	elseif functionType == 8 then
		display(
			"FUN_80642844("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..","
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
			.."behaviour)"
		)
	elseif functionType == 9 then
		display(
			"if ((FLOAT_807F621C != FLOAT_807F61FC) || (FLOAT_807F6224 != 3433.54956055)) {"
		)
		display(
			"FUN_80642480("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..")"
		)
		display("}")
	elseif functionType == 10 then
		display(
			"behaviour + 0x50 = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
		)
		display(
			"behaviour + 0x78 = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2) / 100
		)
		display(
			"behaviour + 0x7C = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3) / 100
		)
	elseif functionType == 11 then
		display(
			"behaviour + 0x80 = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
		)
		display(
			"behaviour + 0x82 = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
		)
	elseif functionType == 12 then
		display(
			"behaviour + 0x84 = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
		)
		display(
			"behaviour + 0x86 = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
		)
	elseif functionType == 13 then
		display(
			"behaviour + 0x88 = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
		)
		display(
			"behaviour + 0x8A = "
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
		)
	--[[
		functionTypes 0xE > 0x2F
	]]--
	elseif functionType == 0x30 then
		display(
			"InitMapChange("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..",0)"
		)
	--[[
		functionTypes 0x31 > 0x5C
	]]--
	elseif functionType == 0x5D then
		display(
			"setNextTransitionType("
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			..")"
		)
	--[[
		functionTypes 0x5E > 0x65
	]]--
	elseif functionType == 0x66 then
		display("if (BYTE_807F61F8 == 0) {")
		display("spawnActor(TimerController)")
		display("temp = CurrentActorPointer")
		display("WORD_807F61F4 = PTR_PTR_807FBB44")
		display("CurrentActorPointer = mainmemory.read_u32_be(0x7FBB44)")
		display(
			"spawnTimer(0xDC,0x2A"
			..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
			")"
		)
		display("BYTE_807F61F8 = 1")
		display("WORD_807F61F0 = PTR_PTR_807FBB44")
		display("CurrentActorPointer = temp")
		display("}")
	--[[
		functionTypes 0x67 > 0x6A
	]]--
	elseif functionType == 0x6B then
		display("setFlag("
		.."0x"
		..bizstring.hex(math.floor(mainmemory.read_u16_be(ScriptCommand + command_struct.command_param_1) / 8))
		..">"
		..mainmemory.read_u16_be(ScriptCommand + command_struct.command_param_1) % 8
		..","
		..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
		..",'Permanent')")
	else
		display("["
		..functionType
		..","
		..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_1)
		..","
		..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_2)
		..","
		..mainmemory.read_s16_be(ScriptCommand + command_struct.command_param_3)
		.."]")
	end
end

-- Key 8 in savestate is 0x3B9680
-- parseObjectScript(0x3B9680) -- Key 8
-- parseObjectScript(0x3B6590) -- Coin Door
-- parseObjectScript(0x455300) -- Kroc Kruiser
parseObjectScript(0x453530) -- Isles Water Switch