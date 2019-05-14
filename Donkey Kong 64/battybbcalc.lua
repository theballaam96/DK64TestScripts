reels = {
	[1] = {"Pineapple", "Coconut", "GB", "Watermelon", "Grape", "GB"},
	[2] = {"Grape", "Coconut", "Watermelon", "GB", "Pineapple", "GB"},
	[3] = {"GB", "Pineapple", "Grape", "GB", "Watermelon", "Coconut"},
	[4] = {"Pineapple", "GB", "Coconut", "GB", "Grape", "Watermelon"},
};

-- Factory
--[[
reels = {
	[1] = {"Grape", "GB", "Pineapple", "Coconut", "GB", "Watermelon"},
	[2] = {"Watermelon", "GB", "Pineapple", "GB", "Grape", "Coconut"},
	[3] = {"Watermelon", "Coconut", "GB", "Pineapple", "Grape", "GB"},
	[4] = {"Pineapple", "GB", "Coconut", "GB", "Grape", "Watermelon"},
};
]]--

bestSlots = {
	[1] = 0,
	[2] = 0,
	[3] = 0,
	[4] = 0,
};

winTarget = "GB";
winPoints = 3;
instaHitPossible = false;

bestTotal = winPoints * (#reels[1] + #reels[2] + #reels[3] + #reels[4]);

function getWinSlots()
	reelWinSlots = {};
	for i = 1, #reels do
		reelWinSlots[i] = {};
		for j = 1, #reels[i] do
			if reels[i][j] == winTarget then
				reelWinSlots[i][#reelWinSlots[i] + 1] = j;
			end
		end
		capReelWin = #reelWinSlots[i];
		for k = 1, #reels do
			for j = 1, #reelWinSlots[i] do
				reelWinSlots[i][(k * capReelWin) + j] = reelWinSlots[i][j] + (k * #reels[1]);
			end
		end
	end
end

function getDistancesToWin(slotNumber, slotSelection)
	distances = {};
	if slotNumber == 1 and instaHitPossible then
		comparisonSlotSelect = slotSelection - 1;
	else
		comparisonSlotSelect = slotSelection;
	end
	for i = 1, #reelWinSlots[slotNumber] do
		if reelWinSlots[slotNumber][i] > comparisonSlotSelect then
			distances[#distances + 1] = reelWinSlots[slotNumber][i] - slotSelection;
		end
	end
	return distances;
end

function getLowestNumberInArrayAboveValue(array,value)
	arrayToCheck = array;
	minValueSelected = false;
	for i = 1, #arrayToCheck do
		if not minValueSelected and arrayToCheck[i] > value then
			minValue = arrayToCheck[i];
			minValueSelected = true;
		end
	end
	if minValue ~= nil then
		return minValue;
	end
end

function compressReelValue(reelSize,reelValue)
	compressionValue = math.mod(reelValue,reelSize);
	if compressionValue == 0 then
		compressionValue = reelSize;
	end
	return compressionValue;
end

function getPointsOfCurrentSlotSelection(r1,r2,r3,r4)
	distanceToWin = {};
	pointsOfSelection = 0;
	start1 = r1;
	start2 = r2;
	start3 = r3;
	start4 = r4;
	for i = 1, winPoints do
		distancesReel1 = getDistancesToWin(1, start1);
		distancesReel2 = getDistancesToWin(2, start2);
		distancesReel3 = getDistancesToWin(3, start3);
		distancesReel4 = getDistancesToWin(4, start4);
		
		distanceSelectedReel1 = distancesReel1[1];
		distanceSelectedReel2 = getLowestNumberInArrayAboveValue(distancesReel2, distanceSelectedReel1);
		distanceSelectedReel3 = getLowestNumberInArrayAboveValue(distancesReel3, distanceSelectedReel2);
		distanceSelectedReel4 = getLowestNumberInArrayAboveValue(distancesReel4, distanceSelectedReel3);
		
		pointsOfSelection = pointsOfSelection + distanceSelectedReel4;
		start1 = compressReelValue(#reels[1], start1 + distanceSelectedReel1);
		start2 = compressReelValue(#reels[2], start2 + distanceSelectedReel2);
		start3 = compressReelValue(#reels[3], start3 + distanceSelectedReel3);
		start4 = compressReelValue(#reels[4], start4 + distanceSelectedReel4);
	end
	return pointsOfSelection
end

function calculateBestStart()
	getWinSlots();
	matchCases = {};
	for reel1 = 1, #reels[1] do
		for reel2 = 1, #reels[2] do
			for reel3 = 1, #reels[3] do
				for reel4 = 1, #reels[4] do
					reel1Prog = reel1;
					reel2Prog = reel2;
					reel3Prog = reel3;
					reel4Prog = reel4;
					points = getPointsOfCurrentSlotSelection(reel1, reel2, reel3, reel4);
					if points < bestTotal then
						bestSlots = {
							[1] = reel1,
							[2] = reel2,
							[3] = reel3,
							[4] = reel4,
						};
						bestTotal = points;
						matchCases = {
							[1] = {reel1, reel2, reel3, reel4};
						};
					elseif points == bestTotal then
						matchCases[#matchCases + 1] = {reel1, reel2, reel3, reel4};
					end
				end
			end
		end
	end
	print("BEST SLOT STARTS");
	for i = 1, #reels do
		print("Reel "..i..": "..reels[i][bestSlots[i]].." ("..bestSlots[i]..")");
	end
	print("");
	print("Number of Matches: "..#matchCases);
	print("");
	if #matchCases > 1 then
		for i = 2, #matchCases do
			print("MATCH #"..(i-1))
			for j = 1, #reels do
				print("Reel "..j..": "..reels[j][matchCases[i][j]].." ("..matchCases[i][j]..")");
			end
			print("");
		end
	end
end