coords = {
	start = {
		x = 2400,
		y = 1200,
		z = 3450,
	},
	finish = {
		x = 2500,
		y = 1320,
		z = 3600,
	}
};

step_amount = 5;
check_address = 0x485D00;
print_array = {};


for x = coords.start.x, coords.finish.x, step_amount do
	for y = coords.start.y, coords.finish.y, step_amount do
		for z = coords.start.z, coords.finish.z, step_amount do
			savestate.loadslot(8);
			Game.setPosition(x,y,z);
			emu.frameadvance()
			emu.frameadvance()
			check_value = mainmemory.readbyte(0x485D00);
			table.insert(print_array,{x,y,z,(1-check_value)});
			emu.yield();
		end
	end
end

print("Copy-Paste this into Excel to graph");
print("-----");

for i = 1, #print_array do
	x_val = print_array[i][1];
	y_val = print_array[i][2];
	z_val = print_array[i][3];
	active_val = print_array[i][4];
	print(x_val.."	"..y_val.."	"..z_val.."	"..active_val);
end