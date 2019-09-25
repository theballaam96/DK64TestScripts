-- FINDS ODDS OF GETTING TREX/WISHY WASHY --

limit = 10000;

types = {
	[0] = "Normal",
	[1] = "Washing Machine",
	[2] = "T-Rex",
};

flags = {
	[1] = 0xBB,
	[2] = 0xBA,
};

-- All 3 affect this --
rng = {
	[1] = 0x3860E0,
	[2] = 0x3860E4,
	[3] = 0x3860E8
};

counts = {
	[0] = 0,
	[1] = 0,
	[2] = 0,
};

for i = 1, limit do
	savestate.loadslot(6);
	for j = 1, #rng do
		mainmemory.write_u32_be(rng[j],i * 37);
	end
	for i = 1, 4 do
		emu.frameadvance();
	end
	if checkFlag("Prog", flags[2]) then
		counts[2] = counts[2] + 1;
	elseif checkFlag("Prog", flags[1]) then
		counts[1] = counts[1] + 1;
	else
		counts[0] = counts[0] + 1;
	end
	if i % 250 == 0 then
		print("Iteration Number: "..i);
	end
end

print("Results after "..limit.." iterations:");

for i = 0, 2 do
	print("Chance of "..types[i]..": "..((math.floor((counts[i]/limit) * 10000)) / 100).."%");
end

emu.yield();