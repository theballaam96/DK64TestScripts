function resetList()
	model_pointers = {};
end

function checkPointers()
	model_pointer_count = 0;
	for model = 0, 0xEC do
		savestate.loadslot(6);
		mainmemory.write_u16_be(0x75C41A,model);
		for j = 1, 10 do
			emu.frameadvance();
		end
		model_pointer = mainmemory.read_u32_be(0x7FB634);
		isOnList = false;
		if #model_pointers > 0 then
			for i = 1, #model_pointers do
				if model_pointers[i][1] == model_pointer then
					model_pointer_array = model_pointers[i][2];
					array_counter = #model_pointer_array;
					model_pointer_array[array_counter + 1] = model;
					model_pointers[i][2] = model_pointer_array;
					isOnList = true;
				end
			end
		end
		if not isOnList then
			model_pointer_count = model_pointer_count + 1;
			model_pointers[model_pointer_count] = {model_pointer, {model}};
		end
	end
end

function printMatches()
	hasAMatch = false;
	for i = 1, #model_pointers do
		if #model_pointers[i][2] > 1 then
			hasAMatch = true;
			modelString = model_pointers[i][2][1];
			for j = 2, #model_pointers[i][2] do
				modelString = modelString..", "..model_pointers[i][2][j];
			end
			print("Match! Models: "..modelString..", Pointer: "..model_pointers[i][1]);
		end
	end
	if not hasAMatch then
		print("No Matches")
	end
end

function eventCycle()
	resetList()
	checkPointers()
	printMatches()
end

eventCycle();