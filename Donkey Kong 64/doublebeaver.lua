-- 222400. X: 152.3 , Z: 125.5
xmin = 150.1; -- Hole exists as far left as x=125.1. Limit is just for finding the beaver spot found beforehand
xmax = 164.1;
zmin = 124.9;
zmax = 163.9;
y = -30;
y_velocity = -100;
start_frame = 222309;
end_frame = 222329
beavers_found = 0;
x_start = 159.9; -- Normal: xmin (Other value if splitting brute forcing)
z_start = 141.9; -- Normal: zmin (Other value if splitting brute forcing)
savestate.loadslot(0);

x10 = x_start * 10;
z10 = z_start * 10;

function writeBeaverPosition(x10_copy,z10_copy)
	x = x10_copy / 10;
	z = z10_copy / 10;
	mainmemory.writefloat(0x4975EC,x,true);
	mainmemory.writefloat(0x4975F4,z,true);
end

function getTime()
	lag_factor = 3; -- emu lag
	diff = lag_factor * (end_frame - start_frame) / 60;
	zprog = z10 - (zmin * 10);
	xprog = x10 - (xmin * 10);
	totalprog = (zprog * ((xmax * 10) - (xmin * 10) + 1)) + xprog + 1;
	maxprog = (((zmax * 10) - (zmin * 10) + 1) * ((xmax * 10) - (xmin * 10) + 1));
	
	timeleft = math.floor(100 * (maxprog - totalprog) * diff) / 100;
	minleft = math.floor(timeleft / 60);
	hourleft = math.floor(minleft / 60);
	minleft_actual = minleft - (60 * hourleft);
	secleft_actual = math.floor(100 * (timeleft - (60 * minleft))) / 100;
	
	timestring = hourleft.."h"..minleft_actual.."m"..secleft_actual.."s";
	return timestring;
end

function drawGUI()
	zprog = z10 - (zmin * 10);
	xprog = x10 - (xmin * 10);
	totalprog = (zprog * ((xmax * 10) - (xmin * 10) + 1)) + xprog + 1;
	maxprog = (((zmax * 10) - (zmin * 10) + 1) * ((xmax * 10) - (xmin * 10) + 1));
	totalprogperc = math.floor(1000 * (totalprog / maxprog)) / 10;
	row = 0;
	gui.text(32, 32 + (16 * row), "Beaver: "..totalprog.."/"..maxprog.." ("..totalprogperc.."%)", nil, 'topleft')
	row = row + 1;
	gui.text(32, 32 + (16 * row), "Double Beavers: "..beavers_found.."/"..totalprog, nil, 'topleft')
	row = row + 2;
	gui.text(32, 32 + (16 * row), "X: "..(x10 / 10), nil, 'topleft')
	row = row + 1;
	gui.text(32, 32 + (16 * row), "Z: "..(z10 / 10), nil, 'topleft')
	row = row + 2;
	
	timeremaining = getTime();
	gui.text(32, 32 + (16 * row), "Est. Time Left: "..timeremaining, nil, 'topleft')
	row = row + 1;
end

function checkBeaver()
	frame = emu.framecount();
	if frame == end_frame then
		beaver_count = mainmemory.readbyte(0x4AC3D5);
		beaver_score = 12 - beaver_count;
		if beaver_score > 1 then -- Double Beaver
			print("------------------")
			print(beaver_score.."x Beaver!")
			print("X: "..x..", Z: "..z)
			beavers_found = beavers_found + 1;
		end
		savestate.loadslot(0);
		mainmemory.writefloat(0x4975F0,y,true); -- Y value
		mainmemory.writefloat(0x497630,y_velocity,true); -- Y Velocity
		if x10 == (xmax * 10) then
			if z10 < (zmax * 10) then
				x10 = xmin * 10;
				z10 = z10 + 1;
			else
				client.pause();
				print("Test over!")
			end
		else
			x10 = x10 + 1;
		end
	end
end

function everyframe()
	drawGUI();
	writeBeaverPosition(x10,z10);
	checkBeaver();
	if not client.ispaused() then
		writeBeaverPosition(x10,z10);
		drawGUI();
		checkBeaver();
	end
end

event.onframeend(everyframe, "Every Frame")
event.onloadstate(everyframe, "Every Frame")