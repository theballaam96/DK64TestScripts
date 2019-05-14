legshake = 0;
raincycle = 0;
nightcycle = 0;
kremshake = 0;
beaverstack = 0;
minibeavers = 0;
rambibeavers = 0;
rambibarrel = 0;
krembullies = 0;
butterflies = 0;
other = 0;

total_iterations = 0;
iterations = 15000;
processKey = 1;

	while processKey == 1 and iterations > 0 do
		savestate.loadslot(7);
		RNG_value = math.floor((4294967296 * math.random()) - 1);
		mainmemory.write_u32_be(0x746A40, RNG_value);

		emu.frameadvance()
		emu.frameadvance()

		eventPending = mainmemory.readbyte(0x033F54);

		-- SOGGY
		if eventPending == 0x0 or eventPending == 0xA then
			legshake = legshake + 1;
		elseif eventPending == 0x26 then
			butterflies = butterflies + 1;
		elseif eventPending == 0x1A then
			beaverstack = beaverstack + 1;
		elseif eventPending == 0x12 then
			rambibarrel = rambibarrel + 1;
		elseif eventPending == 0x17 then
			kremshake = kremshake + 1;
		elseif eventPending == 0xD then
			rambibeavers = rambibeavers + 1;
		elseif eventPending == 0x3 then
			krembullies = krembullies + 1;
		elseif eventPending == 0x2D then
			nightcycle = nightcycle + 1;
		elseif eventPending == 0x1F then
			minibeavers = minibeavers + 1;
		elseif eventPending == 0x34 then
			raincycle = raincycle + 1;
		else
			other = other + 1;
		end
		
		-- TOTAL ITERATIONS
		total_iterations = total_iterations + 1;
		
		iterations = iterations - 1;
		
		if (iterations % 100) == 0 then
			print(iterations.." iterations left!");
		end
		
		if total_iterations > 0 then
			legshake_percentage = (1/100) * math.floor(10000 * (legshake / total_iterations));
			raincycle_percentage = (1/100) * math.floor(10000 * (raincycle / total_iterations));
			nightcycle_percentage = (1/100) * math.floor(10000 * (nightcycle / total_iterations));
			kremshake_percentage = (1/100) * math.floor(10000 * (kremshake / total_iterations));
			beaverstack_percentage = (1/100) * math.floor(10000 * (beaverstack / total_iterations));
			minibeavers_percentage = (1/100) * math.floor(10000 * (minibeavers / total_iterations));
			rambibeavers_percentage = (1/100) * math.floor(10000 * (rambibeavers / total_iterations));
			rambibarrel_percentage = (1/100) * math.floor(10000 * (rambibarrel / total_iterations));
			krembullies_percentage = (1/100) * math.floor(10000 * (krembullies / total_iterations));
			butterflies_percentage = (1/100) * math.floor(10000 * (butterflies / total_iterations));
			other_percentage = (1/100) * math.floor(10000 * (other / total_iterations));
			
		else
			legshake_percentage = 0;
			raincycle_percentage = 0;
			nightcycle_percentage = 0;
			kremshake_percentage = 0;
			beaverstack_percentage = 0;
			minibeavers_percentage = 0;
			rambibeavers_percentage = 0;
			rambibarrel_percentage = 0;
			krembullies_percentage = 0;
			butterflies_percentage = 0;
			other_percentage = 0;
		end
		
		if iterations == 0 then
			print("LegShakeBot.lua results");
			print("Iterations: "..total_iterations);
			print(" ");
			print("Leg Shake: "..legshake.." ("..legshake_percentage.."%)");
			print("Night Cycle: "..nightcycle.." ("..nightcycle_percentage.."%)");
			print("Rain Cycle: "..raincycle.." ("..raincycle_percentage.."%)");
			print("Kremling Shake: "..kremshake.." ("..kremshake_percentage.."%)");
			print("Beaver Stack: "..beaverstack.." ("..beaverstack_percentage.."%)");
			print("Mini Beavers: "..minibeavers.." ("..minibeavers_percentage.."%)");
			print("Rambi & Beavers: "..rambibeavers.." ("..rambibeavers_percentage.."%)");
			print("Rambi on a Barrel: "..rambibarrel.." ("..rambibarrel_percentage.."%)");
			print("Kremling Bullies: "..krembullies.." ("..krembullies_percentage.."%)");
			print("Butterflies: "..butterflies.." ("..butterflies_percentage.."%)");
			print("Other: "..other.." ("..other_percentage.."%)");
			print(" ");
		end
		
		emu.frameadvance();
	end