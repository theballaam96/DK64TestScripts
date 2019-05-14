soggy_null = 0;
soggy_star = 0;
soggy_inferno = 0;
soggy_castle = 0;

moggy_null = 0;
moggy_area51 = 0;
moggy_cave = 0;
moggy_dodgems = 0;

groggy_null = 0;
groggy_train = 0;
groggy_inferno = 0;
groggy_dodgems = 0;

sat = 0;
sai = 0;
sad = 0;
sct = 0;
sci = 0;
scd = 0;
sdt = 0;
sdi = 0;
sdd = 0;
iat = 0;
iai = 0;
iad = 0;
ict = 0;
ici = 0;
icd = 0;
idt = 0;
idi = 0;
idd = 0;
cat = 0;
cai = 0;
cad = 0;
cct = 0;
cci = 0;
ccd = 0;
cdt = 0;
cdi = 0;
cdd = 0;

total_iterations = 0;
iterations = 5000;
processKey = 1;

	while processKey == 1 and iterations > 0 do
		savestate.loadslot(8);
		RNG_value = math.floor((4294967296 * math.random()) - 1);
		mainmemory.write_u32_be(0x12C7F0, RNG_value);
		
		emu.frameadvance()
		
		address1 =  0xAE + mainmemory.read_u32_be(0x12C770) - 0x80000000;
		address2 =  0xAF + mainmemory.read_u32_be(0x12C770) - 0x80000000;
		KidsValue1 = mainmemory.readbyte(address1);
		KidsValue2 = mainmemory.readbyte(address2);
		
		SoggyValue = ((KidsValue1 - (KidsValue1 % 128)) / 64) + (KidsValue2 % 2);
		
		MoggyValue = (KidsValue1 % 128) / 32;
		
		GroggyValue = (KidsValue2 - (KidsValue2 % 2)) / 2;

		-- SOGGY
		if SoggyValue == 0 then
			soggy_null = soggy_null + 1;
		elseif SoggyValue == 1 then
			soggy_star = soggy_star + 1;
		elseif SoggyValue == 2 then
			soggy_inferno = soggy_inferno + 1;
		elseif SoggyValue == 3 then
			soggy_castle = soggy_castle + 1;
		end
		
		-- MOGGY
		if MoggyValue == 0 then
			moggy_null = moggy_null + 1;
		elseif MoggyValue == 1 then
			moggy_area51 = moggy_area51 + 1;
		elseif MoggyValue == 2 then
			moggy_cave = moggy_cave + 1;
		elseif MoggyValue == 3 then
			moggy_dodgems = moggy_dodgems + 1;
		end
		
		-- GROGGY
		if GroggyValue == 0 then
			groggy_null = groggy_null + 1;
		elseif GroggyValue == 1 then
			groggy_train = groggy_train + 1;
		elseif GroggyValue == 2 then
			groggy_inferno = groggy_inferno + 1;
		elseif GroggyValue == 3 then
			groggy_dodgems = groggy_dodgems + 1;
		end
		
		if SoggyValue == 1 and MoggyValue == 1 and GroggyValue == 1 then
			sat = sat + 1;
		elseif SoggyValue == 1 and MoggyValue == 1 and GroggyValue == 2 then
			sai = sai + 1;
		elseif SoggyValue == 1 and MoggyValue == 1 and GroggyValue == 3 then
			sad = sad + 1;
		elseif SoggyValue == 1 and MoggyValue == 2 and GroggyValue == 1 then
			sct = sct + 1;
		elseif SoggyValue == 1 and MoggyValue == 2 and GroggyValue == 2 then
			sci = sci + 1;
		elseif SoggyValue == 1 and MoggyValue == 2 and GroggyValue == 3 then
			scd = scd + 1;
		elseif SoggyValue == 1 and MoggyValue == 3 and GroggyValue == 1 then
			sdt = sdt + 1;
		elseif SoggyValue == 1 and MoggyValue == 3 and GroggyValue == 2 then
			sdi = sdi + 1;
		elseif SoggyValue == 1 and MoggyValue == 3 and GroggyValue == 3 then
			sdd = sdd + 1;
		elseif SoggyValue == 2 and MoggyValue == 1 and GroggyValue == 1 then
			iat = iat + 1;
		elseif SoggyValue == 2 and MoggyValue == 1 and GroggyValue == 2 then
			iai = iai + 1;
		elseif SoggyValue == 2 and MoggyValue == 1 and GroggyValue == 3 then
			iad = iad + 1;
		elseif SoggyValue == 2 and MoggyValue == 2 and GroggyValue == 1 then
			ict = ict + 1;
		elseif SoggyValue == 2 and MoggyValue == 2 and GroggyValue == 2 then
			ici = ici + 1;
		elseif SoggyValue == 2 and MoggyValue == 2 and GroggyValue == 3 then
			icd = icd + 1;
		elseif SoggyValue == 2 and MoggyValue == 3 and GroggyValue == 1 then
			idt = idt + 1;
		elseif SoggyValue == 2 and MoggyValue == 3 and GroggyValue == 2 then
			idi = idi + 1;
		elseif SoggyValue == 2 and MoggyValue == 3 and GroggyValue == 3 then
			idd = idd + 1;
		elseif SoggyValue == 3 and MoggyValue == 1 and GroggyValue == 1 then
			cat = cat + 1;
		elseif SoggyValue == 3 and MoggyValue == 1 and GroggyValue == 2 then
			cai = cai + 1;
		elseif SoggyValue == 3 and MoggyValue == 1 and GroggyValue == 3 then
			cad = cad + 1;
		elseif SoggyValue == 3 and MoggyValue == 2 and GroggyValue == 1 then
			cct = cct + 1;
		elseif SoggyValue == 3 and MoggyValue == 2 and GroggyValue == 2 then
			cci = cci + 1;
		elseif SoggyValue == 3 and MoggyValue == 2 and GroggyValue == 3 then
			ccd = ccd + 1;
		elseif SoggyValue == 3 and MoggyValue == 3 and GroggyValue == 1 then
			cdt = cdt + 1;
		elseif SoggyValue == 3 and MoggyValue == 3 and GroggyValue == 2 then
			cdi = cdi + 1;
		elseif SoggyValue == 3 and MoggyValue == 3 and GroggyValue == 3 then
			cdd = cdd + 1;
		end
		
		-- TOTAL ITERATIONS
		total_iterations = total_iterations + 1;
		
		iterations = iterations - 1;
		
		if total_iterations > 0 then
			soggy_null_percentage = (1/100) * math.floor(10000 * (soggy_null / total_iterations));
			soggy_star_percentage = (1/100) * math.floor(10000 * (soggy_star / total_iterations));
			soggy_inferno_percentage = (1/100) * math.floor(10000 * (soggy_inferno / total_iterations));
			soggy_castle_percentage = (1/100) * math.floor(10000 * (soggy_castle / total_iterations));
			
			moggy_null_percentage = (1/100) * math.floor(10000 * (moggy_null / total_iterations));
			moggy_area51_percentage = (1/100) * math.floor(10000 * (moggy_area51 / total_iterations));
			moggy_cave_percentage = (1/100) * math.floor(10000 * (moggy_cave / total_iterations));
			moggy_dodgems_percentage = (1/100) * math.floor(10000 * (moggy_dodgems / total_iterations));
			
			groggy_null_percentage = (1/100) * math.floor(10000 * (groggy_null / total_iterations));
			groggy_train_percentage = (1/100) * math.floor(10000 * (groggy_train / total_iterations));
			groggy_inferno_percentage = (1/100) * math.floor(10000 * (groggy_inferno / total_iterations));
			groggy_dodgems_percentage = (1/100) * math.floor(10000 * (groggy_dodgems / total_iterations));
			
			sat_percentage = (1/100) * math.floor(10000 * (sat / total_iterations));
			sai_percentage = (1/100) * math.floor(10000 * (sai / total_iterations));
			sad_percentage = (1/100) * math.floor(10000 * (sad / total_iterations));
			sct_percentage = (1/100) * math.floor(10000 * (sct / total_iterations));
			sci_percentage = (1/100) * math.floor(10000 * (sci / total_iterations));
			scd_percentage = (1/100) * math.floor(10000 * (scd / total_iterations));
			sdt_percentage = (1/100) * math.floor(10000 * (sdt / total_iterations));
			sdi_percentage = (1/100) * math.floor(10000 * (sdi / total_iterations));
			sdd_percentage = (1/100) * math.floor(10000 * (sdd / total_iterations));
			iat_percentage = (1/100) * math.floor(10000 * (iat / total_iterations));
			iai_percentage = (1/100) * math.floor(10000 * (iai / total_iterations));
			iad_percentage = (1/100) * math.floor(10000 * (iad / total_iterations));
			ict_percentage = (1/100) * math.floor(10000 * (ict / total_iterations));
			ici_percentage = (1/100) * math.floor(10000 * (ici / total_iterations));
			icd_percentage = (1/100) * math.floor(10000 * (icd / total_iterations));
			idt_percentage = (1/100) * math.floor(10000 * (idt / total_iterations));
			idi_percentage = (1/100) * math.floor(10000 * (idi / total_iterations));
			idd_percentage = (1/100) * math.floor(10000 * (idd / total_iterations));
			cat_percentage = (1/100) * math.floor(10000 * (cat / total_iterations));
			cai_percentage = (1/100) * math.floor(10000 * (cai / total_iterations));
			cad_percentage = (1/100) * math.floor(10000 * (cad / total_iterations));
			cct_percentage = (1/100) * math.floor(10000 * (cct / total_iterations));
			cci_percentage = (1/100) * math.floor(10000 * (cci / total_iterations));
			ccd_percentage = (1/100) * math.floor(10000 * (ccd / total_iterations));
			cdt_percentage = (1/100) * math.floor(10000 * (cdt / total_iterations));
			cdi_percentage = (1/100) * math.floor(10000 * (cdi / total_iterations));
			cdd_percentage = (1/100) * math.floor(10000 * (cdd / total_iterations));
		else
			soggy_null_percentage = 0;
			soggy_star_percentage = 0;
			soggy_inferno_percentage = 0;
			soggy_castle_percentage = 0;
			
			moggy_null_percentage = 0;
			moggy_area51_percentage = 0;
			moggy_cave_percentage = 0;
			moggy_dodgems_percentage = 0;
			
			groggy_null_percentage = 0;
			groggy_train_percentage = 0;
			groggy_inferno_percentage = 0;
			groggy_dodgems_percentage = 0;
			
			sat_percentage = 0;
			sai_percentage = 0;
			sad_percentage = 0;
			sct_percentage = 0;
			sci_percentage = 0;
			scd_percentage = 0;
			sdt_percentage = 0;
			sdi_percentage = 0;
			sdd_percentage = 0;
			iat_percentage = 0;
			iai_percentage = 0;
			iad_percentage = 0;
			ict_percentage = 0;
			ici_percentage = 0;
			icd_percentage = 0;
			idt_percentage = 0;
			idi_percentage = 0;
			idd_percentage = 0;
			cat_percentage = 0;
			cai_percentage = 0;
			cad_percentage = 0;
			cct_percentage = 0;
			cci_percentage = 0;
			ccd_percentage = 0;
			cdt_percentage = 0;
			cdi_percentage = 0;
			cdd_percentage = 0;
		end
		
		if iterations == 0 then
			print("Kidsbot.lua results");
			print("Iterations: "..total_iterations);
			print(" ");
			print("SOGGY");
			print("Star Spinner: "..soggy_star.." ("..soggy_star_percentage.."%)");
			print("Inferno: "..soggy_inferno.." ("..soggy_inferno_percentage.."%)");
			print("Crazy Castle Stockade: "..soggy_castle.." ("..soggy_castle_percentage.."%)");
			print("Waiting to decide: "..soggy_null.." ("..soggy_null_percentage.."%)");
			print(" ");
			print("MOGGY");
			print("Area 51: "..moggy_area51.." ("..moggy_area51_percentage.."%)");
			print("Cave of Horrors: "..moggy_cave.." ("..moggy_cave_percentage.."%)");
			print("Dodgem Dome Lobby: "..moggy_dodgems.." ("..moggy_dodgems_percentage.."%)");
			print("Waiting to decide: "..moggy_null.." ("..moggy_null_percentage.."%)");
			print(" ");
			print("GROGGY");
			print("Train Station: "..groggy_train.." ("..groggy_train_percentage.."%)");
			print("Inferno: "..groggy_inferno.." ("..groggy_inferno_percentage.."%)");
			print("Outside Dodgem Dome: "..groggy_dodgems.." ("..groggy_dodgems_percentage.."%)");
			print("Waiting to decide: "..groggy_null.." ("..groggy_null_percentage.."%)");
			print(" ");
			print("COMBINATIONS");
			print("Star Area51 Train: "..sat.." ("..sat_percentage.."%)");
			print("Star Area51 Inferno(G): "..sai.." ("..sai_percentage.."%)");
			print("Star Area51 Dodgem(G): "..sad.." ("..sad_percentage.."%)");
			print("Star Cave Train: "..sct.." ("..sct_percentage.."%)");
			print("Star Cave Inferno(G): "..sci.." ("..sci_percentage.."%)");
			print("Star Cave Dodgem(G): "..scd.." ("..scd_percentage.."%)");
			print("Star Dodgem(M) Train: "..sdt.." ("..sdt_percentage.."%)");
			print("Star Dodgem(M) Inferno(G): "..sdi.." ("..sdi_percentage.."%)");
			print("Star Dodgem(M) Dodgem(G): "..sdd.." ("..sdd_percentage.."%)");
			print("Inferno(S) Area51 Train: "..iat.." ("..iat_percentage.."%)");
			print("Inferno(S) Area51 Inferno(G): "..iai.." ("..iai_percentage.."%)");
			print("Inferno(S) Area51 Dodgem(G): "..iad.." ("..iad_percentage.."%)");
			print("Inferno(S) Cave Train: "..ict.." ("..ict_percentage.."%)");
			print("Inferno(S) Cave Inferno(G): "..ici.." ("..ici_percentage.."%)");
			print("Inferno(S) Cave Dodgem(G): "..icd.." ("..icd_percentage.."%)");
			print("Inferno(S) Dodgem(M) Train: "..idt.." ("..idt_percentage.."%)");
			print("Inferno(S) Dodgem(M) Inferno(G): "..idi.." ("..idi_percentage.."%)");
			print("Inferno(S) Dodgem(M) Dodgem(G): "..idd.." ("..idd_percentage.."%)");
			print("Castle Area51 Train: "..cat.." ("..cat_percentage.."%)");
			print("Castle Area51 Inferno(G): "..cai.." ("..cai_percentage.."%)");
			print("Castle Area51 Dodgem(G): "..cad.." ("..cad_percentage.."%)");
			print("Castle Cave Train: "..cct.." ("..cct_percentage.."%)");
			print("Castle Cave Inferno(G): "..cci.." ("..cci_percentage.."%)");
			print("Castle Cave Dodgem(G): "..ccd.." ("..ccd_percentage.."%)");
			print("Castle Dodgem(M) Train: "..cdt.." ("..cdt_percentage.."%)");
			print("Castle Dodgem(M) Inferno(G): "..cdi.." ("..cdi_percentage.."%)");
			print("Castle Dodgem(M) Dodgem(G): "..cdd.." ("..cdd_percentage.."%)");
			print(" ");
		end
		
		emu.frameadvance();
	end