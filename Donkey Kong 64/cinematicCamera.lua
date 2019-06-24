------ TUTORIAL
-- SCRIPTHAWK (https://github.com/Isotarge/ScriptHawk) IS HEAVILY ADVISED TO RUN IN PARALLEL TO THIS DUE TO IT'S L-TO-LEVITATE ABILITIES
-- THIS WILL ONLY WORK WITH A DK64 US ROM ON BIZHAWK
-- setStart() in the place you want to start (Account for camera angles)
-- setFinish() in the place you want to finish (Account for camera angles)
-- enter first person
-- cameraPan(duration) where "duration" is the duration of the camera pan in frames (DK64 runs at 60 fps, even though most of them are just lag frames)
-- The camera will halt at the start for 100 frames (1.66s) to steady the camera, and then follow a linear path through the start and finish w/ camera angle changes
-- Use "clear()" to set everything back to default

function clear()
	parameters = {
		starting_frame = 0,
		camera_panning = false,
		position = {
			start = {},
			finish = {},
			per_frame = {},
		},
		angle = {
			start = 0,
			finish = 0,
			per_frame = 0,
		},
		cameraAngle = {
			start = 0,
			finish = 0,
			per_frame = 0,
		},
		cameraTrackingAngle = {
			start = 0,
			finish = 0,
			per_frame = 0,
		},
		duration = 0,
	};
end
clear();

RDRAMBase = 0x80000000;
RDRAMSize = 0x800000; 
RAMBase = RDRAMBase;
RAMSize = RDRAMSize;

function isRDRAM(value)
	return type(value) == "number" and value >= 0 and value < RDRAMSize;
end

function isPointer(value)
		return type(value) == "number" and value >= RDRAMBase and value < RDRAMBase + RDRAMSize;
end

function dereferencePointer(address)
	if type(address) == "number" and address >= 0 and address < (RDRAMSize - 4) then
		address = mainmemory.read_u32_be(address);
		if isPointer(address) then
			return address - RDRAMBase;
		end
	end
end

function isLoading()
	return mainmemory.read_u32_be(0x76A064) == 0;
end

function getPlayerObject() -- TODO: Cache this
	if isLoading() then
		return;
	end
	return dereferencePointer(0x7FBB4C);
end

function setPosition(x,y,z)
	local playerObject = getPlayerObject();
	if isRDRAM(playerObject) then
		mainmemory.writefloat(playerObject + 0x7C,x,true);
		mainmemory.writefloat(playerObject + 0x80,y,true);
		mainmemory.writefloat(playerObject + 0x84,z,true);
	end
end

function setAngle(angle)
	local playerObject = getPlayerObject();
	if isRDRAM(playerObject) then
		mainmemory.write_u16_be(playerObject + 0xE6, math.floor(angle % 4096));
	end
end

function setCameraAngle(angle)
	local cameraObject = dereferencePointer(0x7FB968);
	if isRDRAM(cameraObject) then
		mainmemory.write_u16_be(cameraObject + 0x22A,math.floor(angle) % 4096);
	end
end

function setCameraTrackingAngle(angle)
	local cameraObject = dereferencePointer(0x7FB968);
	if isRDRAM(cameraObject) then
		mainmemory.writefloat(cameraObject + 0x230,angle, true);
	end
end

function angle_degToUnits(input)
	-- 360 deg = 4096 units
	return math.floor((4096 * input) / 360);
end

function set_invisify(value)
	local playerObject = getPlayerObject();
	if isRDRAM(playerObject) then
		local visibilityBitfieldValue = mainmemory.readbyte(playerObject + 0x63);
		if value > 0 then
			mainmemory.writebyte(playerObject + 0x63, bit.set(visibilityBitfieldValue, 2));
		else
			mainmemory.writebyte(playerObject + 0x63, bit.clear(visibilityBitfieldValue, 2));
		end
	end
end

function setStart()
	local playerObject = getPlayerObject();
	local cameraObject = dereferencePointer(0x7FB968);
	if isRDRAM(playerObject) then
		for i = 1, 3 do
			parameters.position.start[i] = mainmemory.readfloat(playerObject + 0x78 + (4 * i), true);
		end
		parameters.angle.start = mainmemory.read_u16_be(playerObject + 0xE6);
	end
	if isRDRAM(cameraObject) then
		parameters.cameraAngle.start = mainmemory.read_u16_be(cameraObject + 0x22A);
		parameters.cameraTrackingAngle.start = mainmemory.readfloat(cameraObject + 0x230, true);
	end
	print("START SET");
	print("X: "..parameters.position.start[1]);
	print("Y: "..parameters.position.start[2]);
	print("Z: "..parameters.position.start[3]);
	print("Facing Angle: "..parameters.angle.start);
	print("Camera Horizontal Angle: "..parameters.cameraAngle.start);
	print("Camera Vertical Angle: "..parameters.cameraTrackingAngle.start);
end

function setFinish()
	local playerObject = getPlayerObject();
	local cameraObject = dereferencePointer(0x7FB968);
	if isRDRAM(playerObject) then
		for i = 1, 3 do
			parameters.position.finish[i] = mainmemory.readfloat(playerObject + 0x78 + (4 * i), true);
		end
		parameters.angle.finish = mainmemory.read_u16_be(playerObject + 0xE6);
	end
	if isRDRAM(cameraObject) then
		parameters.cameraAngle.finish = mainmemory.read_u16_be(cameraObject + 0x22A);
		parameters.cameraTrackingAngle.finish = mainmemory.readfloat(cameraObject + 0x230, true);
	end
	print("FINISH SET");
	print("X: "..parameters.position.finish[1]);
	print("Y: "..parameters.position.finish[2]);
	print("Z: "..parameters.position.finish[3]);
	print("Facing Angle: "..parameters.angle.finish);
	print("Camera Horizontal Angle: "..parameters.cameraAngle.finish);
	print("Camera Vertical Angle: "..parameters.cameraTrackingAngle.finish);
end

--[[
function cameraPan(positionArray_start,positionArray_finish,angle_start,angle_finish,duration_frames)
	-- set initial parameters
	parameters.starting_frame = emu.framecount();
	parameters.position.start = positionArray_start;
	parameters.position.finish = positionArray_finish;
	parameters.angle.start = angle_degToUnits(angle_start) % 4096;
	parameters.angle.finish = angle_degToUnits(angle_finish) % 4096;
	parameters.camera_panning = true;
	parameters.duration = duration_frames;
	parameters.cameraAngle.start = angle_degToUnits(angle_start + 180) % 4096;
	parameters.cameraAngle.finish = angle_degToUnits(angle_finish + 180) % 4096;
]]--


--[[
function invertAngularTransition()
	if parameters.angle.finish > parameters.angle.start then
		parameters.angle.start = parameters.angle.start + 4096;
	else
		parameters.angle.finish = parameters.angle.finish + 4096;
	end
end
]]--

function cameraPan(duration_frames)
	parameters.starting_frame = emu.framecount();
	parameters.duration = duration_frames;
	parameters.camera_panning = true;
	
	if parameters.angle.finish > parameters.angle.start then
		if parameters.cameraAngle.finish < parameters.cameraAngle.start then
			parameters.cameraAngle.finish = parameters.cameraAngle.finish + 4096;
		end
	else
		if parameters.cameraAngle.finish > parameters.cameraAngle.start then
			parameters.cameraAngle.start = parameters.cameraAngle.start + 4096;
		end
	end
	
	-- set per frame parameters
	x_per_frame = (parameters.position.finish[1] - parameters.position.start[1]) / duration_frames;
	y_per_frame = (parameters.position.finish[2] - parameters.position.start[2]) / duration_frames;
	z_per_frame = (parameters.position.finish[3] - parameters.position.start[3]) / duration_frames;
	parameters.position.per_frame = {x_per_frame,y_per_frame,z_per_frame};
	parameters.angle.per_frame = (parameters.angle.finish - parameters.angle.start) / duration_frames;
	parameters.cameraAngle.per_frame = (parameters.cameraAngle.finish - parameters.cameraAngle.start) / duration_frames;
	parameters.cameraTrackingAngle.per_frame = (parameters.cameraTrackingAngle.finish - parameters.cameraTrackingAngle.start) / duration_frames;
	print("STARTING CAMERA PAN");
	duration_seconds = math.floor((duration_frames / 60) * 100) / 100;
	print("Duration: "..duration_frames.." frames ("..duration_seconds.." seconds)");
end

function performPan()
	if parameters.camera_panning then
		set_invisify(0)
		current_frame = emu.framecount();
		time_reference = current_frame - (parameters.starting_frame + 100);
		if time_reference < 0 then
			actual_time_reference = 0;
		else
			actual_time_reference = time_reference;
		end
		new_x = parameters.position.start[1] + (actual_time_reference * parameters.position.per_frame[1]);
		new_y = parameters.position.start[2] + (actual_time_reference * parameters.position.per_frame[2]);
		new_z = parameters.position.start[3] + (actual_time_reference * parameters.position.per_frame[3]);
		new_angle_a = parameters.angle.start + (actual_time_reference * parameters.angle.per_frame);
		new_angle_b = parameters.cameraAngle.start + (actual_time_reference * parameters.cameraAngle.per_frame);
		new_angle_c = parameters.cameraTrackingAngle.start + (actual_time_reference * parameters.cameraTrackingAngle.per_frame);
		setPosition(new_x,new_y,new_z);
		setAngle(new_angle_a);
		setCameraAngle(new_angle_b);
		setCameraTrackingAngle(new_angle_c);
		if time_reference == parameters.duration then
			parameters.camera_panning = false;
			print("ENDING CAMERA PAN");
			print("");
		end
	else
		set_invisify(1)
	end
end

event.onframestart(performPan, "Performs Camera Pan");