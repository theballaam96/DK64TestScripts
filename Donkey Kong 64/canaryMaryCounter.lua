controls_bitfield = 0x079B40;
a_count = 0
previous_A = false;
check_bit = bit.check;

function startNew()
	a_count = 0;
end

function checkNewA()
	new_A = check_bit(mainmemory.readbyte(controls_bitfield),7);
	if new_A and not previous_A then
		previous_A = new_A;
		return true;
	end
	previous_A = new_A;
	return false;
end

function incrementCounter()
	a_count = a_count + 1;
end

function checkCounter()
	print("A Count: "..a_count);
end

function canaryMary_eventCycle()
	A_new = checkNewA();
	if A_new then
		incrementCounter();
	end
end

event.onframestart(canaryMary_eventCycle, "Tag Barrel Event Cycle");