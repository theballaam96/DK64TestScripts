iterations = 5000;
result_list = {};

for i = 0, iterations do
	savestate.loadslot(9);
	mainmemory.write_u32_be(0x746A40,i);
	emu.frameadvance();
	result = mainmemory.readbyte(0x46C8E5);
	savestate.loadslot(9);
	failsafe_triggered = false;
	mainmemory.write_u32_be(0x746A40,i);
	mainmemory.writebyte(0x46C8E3, result - 16);
	emu.frameadvance();
	new_result = mainmemory.readbyte(0x46C8E5);
	if new_result == result then
		failsafe_triggered = true;		
	end
	result_array = {i, result, failsafe_triggered};
	table.insert(result_list, result_array);
	if i%500 == 0 then
		print(i.." iterations complete")
	end
	emu.yield();
end

print("Copy-Paste this into Excel to analyse");
print("-----");
if #result_list > 0 then
	for i = 1, #result_list do
		if result_list[i][3] then
			bool_string = "true";
		else
			bool_string = "false";
		end
		print(result_list[i][1].."	"..result_list[i][2].."	"..bool_string);
	end
end