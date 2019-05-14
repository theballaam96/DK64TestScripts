duration = 1800;
sound = 0;
starting_frame = 5895;
state = 7;
sound_detection_frame = 30;

caps = {
	sound = 1126, -- Post 1127 Crashes
	frame = starting_frame + duration, -- Frame to reset state
	frame2 = starting_frame + sound_detection_frame; -- Frame to reset if no sound heard
};

savestate.loadslot(state);
client.unpause();

function setStartingParams()
	mainmemory.writefloat(0x04BD70, 54, true); -- X Position
	mainmemory.write_u16_be(0x04C716, sound); -- Sound
	current_frame = emu.framecount();
	sound_detected = mainmemory.readbyte(0x77A686);
	freezeDK();
	row = 0;
	gui.text(32, 32 + (16 * row), "Sound: "..sound.."/"..caps.sound, nil, 'topleft')
	if current_frame > starting_frame then
		mainmemory.write_u16_be(0x04C716, 0);
		if sound_detected == 0 and current_frame > caps.frame2 then
			n();
		end
	end
	if current_frame > caps.frame then
		n();
	end
end

function n()
	sound = sound + 1;
	savestate.loadslot(state);
end

function freezeDK()
	mainmemory.write_u16_be(0x04AC4A,1344);
	mainmemory.write_u16_be(0x04B3CA,1344);
	mainmemory.write_u16_be(0x04BD46,1344);
	mainmemory.writebyte(0x04BD49,11);
end

event.onframestart(setStartingParams, "event cycle");