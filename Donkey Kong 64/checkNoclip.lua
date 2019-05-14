obj_model2_timer = 0x76A064;
player_pointer = 0x7FBB4C;
control_state_byte = 0x154;
noclip_byte = 0x144;

RDRAMBase = 0x80000000;
RDRAMSize = 0x800000; -- Halved with no expansion pak, can be read from 0x80000318
RAMBase = RDRAMBase;
RAMSize = RDRAMSize;

function isRDRAM(value)
		return type(value) == "number" and value >= 0 and value < RDRAMSize;
end

function isPointer(value)
	return type(value) == "number" and value >= RDRAMBase and value < RDRAMBase + RDRAMSize;
end

string.lpad = function(str, len, char)
	if type(str) ~= "str" then
		str = tostring(str);
	end
	if char == nil then char = ' ' end
	return string.rep(char, len - #str)..str;
end

function toHexString(value, desiredLength, prefix)
	value = string.format("%X", value or 0);
	value = string.lpad(value, desiredLength or string.len(value), '0');
	return (prefix or "0x")..value;
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
	return mainmemory.read_u32_be(obj_model2_timer) == 0;
end

function getPlayerObject() -- TODO: Cache this
	if isLoading() then
		return;
	end
	return dereferencePointer(player_pointer);
end

function setMovementState(value)
	playerObject = getPlayerObject();
	if isRDRAM(playerObject) then
		mainmemory.writebyte(playerObject + control_state_byte, value);
	end
end

control_states = {
		[0x01] = "Idle", -- Enemy
		[0x02] = "First person camera",
		[0x03] = "First person camera", -- Water
		[0x04] = "Fairy Camera",
		[0x05] = "Fairy Camera", -- Water
		[0x06] = "Locked", -- Inside bonus barrel
		[0x07] = "Minecart (Idle)",
		[0x08] = "Minecart (Crouch)",
		[0x09] = "Minecart (Jump)",
		[0x0A] = "Minecart (Left)",
		[0x0B] = "Minecart (Right)",
		[0x0C] = "Idle",
		[0x0D] = "Walking",
		[0x0E] = "Skidding",
		[0x0F] = "Sliding", -- Beetle Race
		[0x10] = "Sliding (Left)", -- Beetle Race
		[0x11] = "Sliding (Right)", -- Beetle Race
		[0x12] = "Sliding (Forward)", -- Beetle Race
		[0x13] = "Sliding (Back)", -- Beetle Race
		[0x14] = "Jumping", -- Beetle Race
		[0x15] = "Slipping",
		[0x16] = "Slipping", -- DK Slope in Helm
		[0x17] = "Jumping",
		[0x18] = "Baboon Blast Pad",
		[0x19] = "Bouncing", -- Mushroom
		[0x1A] = "Double Jump", -- Diddy
		[0x1B] = "Simian Spring",
		[0x1C] = "Simian Slam",
		[0x1D] = "Long Jumping",
		[0x1E] = "Falling",
		[0x1F] = "Falling", -- Gun
		[0x20] = "Falling/Splat",
		[0x21] = "Falling", -- Beetle Race
		[0x22] = "Pony Tail Twirl",
		[0x23] = "Attacking", -- Enemy
		[0x24] = "Primate Punch", -- TODO: Is this used anywhere else?
		[0x25] = "Attacking", -- Enemy
		[0x26] = "Ground Attack",
		[0x27] = "Attacking", -- Enemy
		[0x28] = "Ground Attack (Final)",
		[0x29] = "Moving Ground Attack",
		[0x2A] = "Aerial Attack",
		[0x2B] = "Rolling",
		[0x2C] = "Throwing Orange",
		[0x2D] = "Shockwave",
		[0x2E] = "Chimpy Charge",
		[0x2F] = "Charging", -- Rambi
		[0x30] = "Bouncing",
		[0x31] = "Damaged",
		[0x32] = "Stunlocked", -- Kasplat
		[0x33] = "Damaged", -- Mad Jack Wrong Switch
		[0x34] = "Unknown 0x34",
		[0x35] = "Damaged", -- Klump knockback
		[0x36] = "Death",
		[0x37] = "Damaged", -- Underwater
		[0x38] = "Damaged", -- Vehicle (Boat?)
		[0x39] = "Shrinking",
		[0x3A] = "Unknown 0x3A",
		[0x3B] = "Death", -- Dogadon Lava
		[0x3C] = "Crouching",
		[0x3D] = "Uncrouching",
		[0x3E] = "Backflip",
		[0x3F] = "Entering Orangstand",
		[0x40] = "Orangstand",
		[0x41] = "Jumping", -- Orangstand
		[0x42] = "Barrel", -- Tag Barrel, Bonus Barrel, Mini Monkey Barrel
		[0x43] = "Barrel", -- Underwater
		[0x44] = "Baboon Blast Shot",
		[0x45] = "Cannon Shot",
		[0x46] = "Pushing Object", -- Unused
		[0x47] = "Picking up Object",
		[0x48] = "Idle", -- Carrying Object
		[0x49] = "Walking", -- Carrying Object
		[0x4A] = "Dropping Object",
		[0x4B] = "Throwing Object",
		[0x4C] = "Jumping", -- Carrying Object
		[0x4D] = "Throwing Object", -- In Air
		[0x4E] = "Surface Swimming",
		[0x4F] = "Underwater",
		[0x50] = "Leaving Water",
		[0x51] = "Jumping", -- Out of water
		[0x52] = "Bananaporter",
		[0x53] = "Monkeyport",
		[0x54] = "Bananaporter", -- Multiplayer
		[0x55] = "Unknown 0x55",
		[0x56] = "Locked", -- Funky's & Candy's store
		[0x57] = "Swinging on Vine",
		[0x58] = "Leaving Vine",
		[0x59] = "Climbing Tree",
		[0x5A] = "Leaving Tree",
		[0x5B] = "Grabbed Ledge",
		[0x5C] = "Pulling up on Ledge",
		[0x5D] = "Idle", -- With gun
		[0x5E] = "Walking", -- With gun
		[0x5F] = "Putting away gun",
		[0x60] = "Pulling out gun",
		[0x61] = "Jumping", -- With gun
		[0x62] = "Aiming Gun",
		[0x63] = "Rocketbarrel",
		[0x64] = "Taking Photo",
		[0x65] = "Taking Photo", -- Underwater
		[0x66] = "Damaged", -- Exploding TNT Barrels
		[0x67] = "Instrument",
		[0x68] = "Unknown 0x68",
		[0x69] = "Car", -- Race
		[0x6A] = "Learning Gun",
		[0x6B] = "Locked", -- Bonus barrel
		[0x6C] = "Feeding T&S",
		[0x6D] = "Boat",
		[0x6E] = "Baboon Balloon",
		[0x6F] = "Updraft", -- Castle tower
		[0x70] = "GB Dance",
		[0x71] = "Key Dance",
		[0x72] = "Crown Dance",
		[0x73] = "Loss Dance",
		[0x74] = "Victory Dance",
		[0x75] = "Vehicle", -- Castle Car Race
		[0x76] = "Entering Battle Crown",
		[0x77] = "Locked", -- Tons of cutscenes use this
		[0x78] = "Gorilla Grab",
		[0x79] = "Learning Move",
		[0x7A] = "Locked", -- Car race loss, possibly elsewhere
		[0x7B] = "Locked", -- Beetle Race loss, falling animation on ground
		[0x7C] = "Trapped", -- Spider miniBoss
		[0x7D] = "Klaptrap Kong", -- Beaver Bother
		[0x7E] = "Surface Swimming", -- Enguarde
		[0x7F] = "Underwater", -- Enguarde
		[0x80] = "Attacking", -- Enguarde, surface
		[0x81] = "Attacking", -- Enguarde
		[0x82] = "Leaving Water", -- Enguarde
		[0x83] = "Fairy Refill",
		[0x84] = "Unknown 0x84", -- Screen fades to black function at 806F007C sets it, pointer to that function in jump table at 80752DDC (near portal enter/exit functions)
		[0x85] = "Main Menu",
		[0x86] = "Entering Main Menu",
		[0x87] = "Entering Portal",
		[0x88] = "Exiting Portal",
};

check_bit = bit.check;

function checkNoclipState()
	playerObject = getPlayerObject();
	if isRDRAM(playerObject) then
		local value = mainmemory.readbyte(playerObject + noclip_byte);
		if not (check_bit(value, 2) and check_bit(value, 3)) then
			return true; -- Has Noclip
		end
	end
	return false;
end

noclipStates = {};
movement_state = 1;

blacklist = {
	[1] = 133;
	[2] = 134;
};
	
	while movement_state < 0x89 do
		savestate.loadslot(7);
		isOnBlacklist = 0;
		
		for i = 1, #blacklist do
			if movement_state == blacklist[i] then
				isOnBlacklist = 1;
			end
		end
		
		if isOnBlacklist == 0 then
			setMovementState(movement_state);
			
			notCrashed = 0;
			
			for i = 1, 10 do
				emu.frameadvance()
				setMovementState(movement_state);
				if not emu.islagged() then
					notCrashed = 1;
					noclipState = checkNoclipState();
					if noclipState then
						noclipStates[movement_state] = "Yes";
					else
						noclipStates[movement_state] = "No";
					end
				end
			end
			
			if notCrashed == 0 then
				noclipStates[movement_state] = "Crashes the game";
			end
		else
			noclipStates[movement_state] = "Crashes BizHawk";
		end
		--if noclipStates[movement_state] == "Crashes BizHawk" then
			print("["..toHexString(movement_state).."] - ("..control_states[movement_state]..") - "..noclipStates[movement_state]);
		--end
		movement_state = movement_state + 1;
		emu.frameadvance()
	end