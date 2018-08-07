-- LIME'S PROJECTS DEV.
-- CUSTOM TRAIN TRACKS

-- DEVELOPMENT PART

local namespace = {
	createTrack,
	createTrain,
	getNextTrackPoint
}

local trainsTable = {
	[1] = 3585 -- TEMP
}
local tracksTable= {
	[1] = {
		tracks = {
			{2305.3078613281, -2144.0087890625, 13.546875},
			{2231.5627441406, -2070.2041015625, 13.546875},
			{2227.08203125, -2066.517578125, 13.546875},
			{2218.8703613281, -2062.0993652344, 13.6484375},
			{2212.0278320313, -2056.3122558594, 13.546875},
			{2172.2092285156, -2016.5144042969, 13.546875},
			{2161.3571777344, -2005.5109863281, 13.546875},
			{2155.48046875, -1999.5493164063, 13.546875},
			{2144.2888183594, -1988.7912597656, 13.546875},
			{2138.3771972656, -1983.5979003906, 13.546875},
			{2133.3796386719, -1979.65625, 13.546875},
			{2128.0275878906, -1976.5532226563, 13.546875},
			{2123.1469726563, -1974.61328125, 13.546875},
			{2095.244140625, -1964.4417724609, 13.546875}
		}
	}
}

namespace.getNextTrackPoint = function(trackID, trackPoint)
	assert(trackID, "Missing argument 'trackID' at namespace.getNextTrackPoint")
	assert(trackPoint, "Missing argument 'trackPoint' at namespace.getNextTrackPoint")
	if type(trackID) ~= "number" then outputDebugString("Bad argument @ 'namespace.getNextTrackPoint' [Excepted number at argument 1, got " .. type(trackID) .. "]", 2) return false end
	if type(trackPoint) ~= "number" then outputDebugString("Bad argument @ 'namespace.getNextTrackPoint' [Excepted number at argument 2, got " .. type(trackPoint) .. "]", 2) return false end
	if (tracksTable[trackID].tracks[trackPoint+1] <= #tracksTable[trackID].tracks) then
		return tracksTable[trackID].tracks[trackPoint+1]
	else
		return tracksTable[trackID].tracks[1]
	end
end

namespace.createTrain = function(trackID, trackPoint, trainID)
	assert(trackID, "Missing argument 'trackID' at namespace.createTrain")
	assert(trackPoint, "Missing argument 'trackPoint' at namespace.createTrain")
	assert(trainID, "Missing argument 'trainID' at namespace.createTrain")
	if type(trackID) ~= "number" then outputDebugString("Bad argument @ 'namespace.createTrain' [Excepted number at argument 1, got " .. type(trackID) .. "]", 2) return false end
	if type(trackPoint) ~= "number" then outputDebugString("Bad argument @ 'namespace.createTrain' [Excepted number at argument 2, got " .. type(trackPoint) .. "]", 2) return false end
	if type(trainID) ~= "number" then outputDebugString("Bad argument @ 'namespace.createTrain' [Excepted number at argument 3, got " .. type(trainID) .. "]", 2) return false end
	local customTrain = createObject(trainsTable[trainID], tracksTable[trackID].tracks[trackPoint][1], tracksTable[trackID].tracks[trackPoint][2], tracksTable[trackID].tracks[trackPoint][3])
	setElementData(customTrain, "trainTracks.id", trainID)
	return customTrain
end

namespace.createTrack = function(trackID)
	assert(trackID, "Missing argument 'trackID' at namespace.createTrack")
	if type(trackID) ~= "number" then outputDebugString("Bad argument @ 'namespace.createTrack' [Excepted number at argument 1, got " .. type(trackID) .. "]", 2) return false end
	local customTrack = createElement("customTrainTrack")
	setElementData(customTrack, "trainTracks.id", trackID)
	setElementData(customTrack, "trainTracks.tracks", tracksTable[trackID].tracks)
	return customTrack
end

-- USER PART

local customTrains = {}
local customTracks = {}
local thisResource = getThisResource()

function createTracksOnResourceStart()
	if not customTracks[1] then customTracks[1] = {} end
	if not customTrains[1] then customTrains[1] = {} end
	customTracks[1].myTrack = namespace.createTrack(1)
	customTracks[1].tracks = getElementData(customTracks[1].myTrack, "trainTracks.tracks")
	customTrains[1].myTrain= namespace.createTrain(1, 2, 1)
end
addEventHandler("onResourceStart", getResourceRootElement(thisResource), createTracksOnResourceStart)