prev_frames = 0;
for i = 1, 255 do
	savestate.loadslot(2);
	frames = prev_frames + 2;
	for i = 1, frames do
		emu.frameadvance();
	end
	joypad.set({["A"] = true}, 1);
	for i = 1, 4 do
		emu.frameadvance();
	end
	picture_question = mainmemory.readbyte(0x0BDD51);
	if picture_question == 16 then
		print("Question 16 found after advancing "..frames.." frames!");
	end
	prev_frames = frames;
end

emu.yield();