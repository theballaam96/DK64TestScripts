function CycleRNG(oldRNGValue)
    local multiplicationResult = Multiply(oldRNGValue,0x01DF5E0D);
    local lower32 = tonumber("0x"..string.sub(tostring(bizstring.hex(multiplicationResult)),-8))
    local newRNGValue = bit.band(lower32 + 1, 0xFFFFFFFF);
    return newRNGValue;
end

-- function test(input, expected)
--     local result = CycleRNG(input);
--     total = total + 1;
--     if result == expected then
--         passed = passed + 1;
--         --print("[PASS] CycleRNG("..bizstring.hex(input)..") returned the expected value of "..bizstring.hex(expected));
--     else
--         print("[FAIL] CycleRNG("..bizstring.hex(input)..") expected "..bizstring.hex(expected).." but got "..bizstring.hex(result));
--     end
-- end

function Multiply(a, b)
    local c = 0;
    while b > 0 do
        if bit.band(b, 1) > 0 then
            c = c + a;
        else
            c = c + 0;
        end
        a = bit.lshift(a, 1);
        b = bit.rshift(b, 1);
    end
    return c;
end

function calculateCycleCount(input,output)
	if input == output then
		return 0
	end
	count = "?";
	new_rng = input;
	for i = 1, 256 do
		if count == "?" then
			new_rng = CycleRNG(new_rng);
			if new_rng == output then
				count = i;
			end
		end
	end
	if count == "?" then
		print (input.." "..output)
	end
	return count;
end

old_rng_loop = mainmemory.read_u32_be(0x746A40);
function RNGLoop()
	is_lagged = emu.islagged();
	if not is_lagged then
		new_rng_loop = mainmemory.read_u32_be(0x746A40);
		cycle_count = calculateCycleCount(old_rng_loop,new_rng_loop);
		print(cycle_count);
		old_rng_loop = new_rng_loop;
	end
end

function resetRNGCache()
	old_rng_loop = mainmemory.read_u32_be(0x746A40);
end

event.onframestart(RNGLoop, "RNG Loop");
event.onloadstate(resetRNGCache, "RNG Cache Reset");

-- INPUT = F9712B7A
-- OUTPUT = 91FC0133

-- Test Values
-- console.clear();
-- https://pastebin.com/GSmK9zz2
-- console.log("Passed "..passed.."/"..total)