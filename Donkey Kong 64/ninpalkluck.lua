limit = 10000;

types = {
	[0] = "BK",
	[1] = "Picture",
	[2] = "Audio",
	[3] = "Grunty"
};

rng = 0x3860E0;
counts = {
	[0] = 0,
	[1] = 0,
	[2] = 0,
	[3] = 0,
};

for i = 1, limit do
	savestate.loadslot(2);
	mainmemory.write_u32_be(rng,i * 37);
	for i = 1, 2 do
		emu.frameadvance();
	end
	joypad.set({["A"] = true}, 1);
	for i = 1, 2 do
		emu.frameadvance();
	end
	output = mainmemory.readbyte(0x0C63EB);
	counts[output] = counts[output] + 1;
	if i % 250 == 0 then
		print("Iteration Number: "..i);
	end
end

print("Results after "..limit.." iterations:");

for i = 0, 3 do
	print("Chance of "..types[i].." question: "..((math.floor((counts[i]/limit) * 10000)) / 100).."%");
end

emu.yield();