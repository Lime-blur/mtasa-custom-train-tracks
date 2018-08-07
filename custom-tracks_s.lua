-- LIME'S PROJECTS DEV.
-- CUSTOM TRAIN TRACKS

-- DEVELOPMENT PART

local namespace = {
	createTrack,
	createTrain,
	getNextTrackPoint
}

namespace.getNextTrackPoint = function(trackID, trackPoint)
	assert(trackID, "Missing argument 'trackID' at namespace.getNextTrackPoint")
	assert(trackPoint, "Missing argument 'trackPoint' at namespace.getNextTrackPoint")
	if type(trackID) ~= "number" then outputDebugString("Bad argument @ 'namespace.getNextTrackPoint' [Excepted number at argument 1, got " .. type(trackID) .. "]", 2) return false end
	if type(trackPoint) ~= "number" then outputDebugString("Bad argument @ 'namespace.getNextTrackPoint' [Excepted number at argument 2, got " .. type(trackPoint) .. "]", 2) return false end
	if (tracksTable[trackID].tracks[trackPoint+1] < #tracksTable[trackID].tracks) then
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
	if (trainID == 1) then
		triggerClientEvent(root, "trainTracks.onClientTrainSpawn", root)
	end
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
	setTimer(function()
		if not customTracks[1] then customTracks[1] = {} end
		if not customTrains[1] then customTrains[1] = {} end
		customTracks[1].myTrack = namespace.createTrack(1)
		customTracks[1].tracks = getElementData(customTracks[1].myTrack, "trainTracks.tracks")
		customTrains[1].myTrain = namespace.createTrain(1, 2, 1)
	end, 2000, 1)
end
addEventHandler("onResourceStart", getResourceRootElement(thisResource), createTracksOnResourceStart)