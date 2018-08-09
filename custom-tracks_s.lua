-- LIME'S PROJECTS DEV.
-- CUSTOM TRAIN TRACKS

-- DEVELOPMENT PART

local namespace = {
	createTrack,
	createTrain,
	getNextTrackPoint,
	moveTrain
}

-- RETURN NEXT TRACK POINT

namespace.getNextTrackPoint = function(trackID, trackPoint, returnNumber)
	assert(trackID, "Missing argument 'trackID' at namespace.getNextTrackPoint")
	assert(trackPoint, "Missing argument 'trackPoint' at namespace.getNextTrackPoint")
	if type(trackID) ~= "number" then outputDebugString("Bad argument @ 'namespace.getNextTrackPoint' [Excepted number at argument 1, got " .. type(trackID) .. "]", 2) return false end
	if type(trackPoint) ~= "number" then outputDebugString("Bad argument @ 'namespace.getNextTrackPoint' [Excepted number at argument 2, got " .. type(trackPoint) .. "]", 2) return false end
	if (tonumber(trackPoint+1) < #tracksTable[trackID].tracks) then
		if (returnNumber) then
			return trackPoint+1
		else
			return tracksTable[trackID].tracks[trackPoint+1]
		end
	else
		if (returnNumber) then
			return 1
		else
			return tracksTable[trackID].tracks[1]
		end
	end
end

-- RETURN NEW TRAIN

namespace.createTrain = function(trackID, trackPoint, trainID)
	assert(trackID, "Missing argument 'trackID' at namespace.createTrain")
	assert(trackPoint, "Missing argument 'trackPoint' at namespace.createTrain")
	assert(trainID, "Missing argument 'trainID' at namespace.createTrain")
	if type(trackID) ~= "number" then outputDebugString("Bad argument @ 'namespace.createTrain' [Excepted number at argument 1, got " .. type(trackID) .. "]", 2) return false end
	if type(trackPoint) ~= "number" then outputDebugString("Bad argument @ 'namespace.createTrain' [Excepted number at argument 2, got " .. type(trackPoint) .. "]", 2) return false end
	if type(trainID) ~= "number" then outputDebugString("Bad argument @ 'namespace.createTrain' [Excepted number at argument 3, got " .. type(trainID) .. "]", 2) return false end
	local customTrain = createObject(trainsTable[trainID], tracksTable[trackID].tracks[trackPoint][1], tracksTable[trackID].tracks[trackPoint][2], tracksTable[trackID].tracks[trackPoint][3])
	setElementData(customTrain, "trainTracks.id", trainID) -- TRAIN MODEL ID
	setElementData(customTrain, "trainTracks.trackID", trackID) -- TRACK ID
	if (trainID == 1) then
		triggerClientEvent(root, "trainTracks.onClientTrainSpawn", root) -- NOTIFY CLIENT ABOUT TRAIN CREATING
	end
	return customTrain
end

-- RETURN NEW TRACK

namespace.createTrack = function(trackID)
	assert(trackID, "Missing argument 'trackID' at namespace.createTrack")
	if type(trackID) ~= "number" then outputDebugString("Bad argument @ 'namespace.createTrack' [Excepted number at argument 1, got " .. type(trackID) .. "]", 2) return false end
	local customTrack = createElement("customTrainTrack")
	setElementData(customTrack, "trainTracks.id", trackID) -- WAY NUMBER
	setElementData(customTrack, "trainTracks.tracks", tracksTable[trackID].tracks) -- POINTS TABLE
	return customTrack
end

--[[ MOVE TRAIN TO THE NEXT POINT (TEST)

namespace.moveTrain = function(trackID, train, currentTrainPoint, tX, tY, tZ)
	moveObject(train, 5000, tX, tY, tZ)
	setElementData(train, "trainTracks.currentTrainPoint", namespace.getNextTrackPoint(trackID, currentTrainPoint, true))
	local nextPosition = getElementData(train, "trainTracks.nextTrainXYZ")
	setElementData(train, "trainTracks.currentTrainXYZ", nextPosition)
	nextPosition = namespace.getNextTrackPoint(trackID, namespace.getNextTrackPoint(trackID, currentTrainPoint, true))
	setElementData(train, "trainTracks.nextTrainXYZ", nextPosition)
	setTimer(function()
		local nextPoint = getElementData(train, "trainTracks.currentTrainPoint")
		setElementData(train, "trainTracks.currentTrainPoint", namespace.getNextTrackPoint(trackID, nextPoint, true))
		local nextPosition = getElementData(train, "trainTracks.nextTrainXYZ")
		setElementData(train, "trainTracks.currentTrainXYZ", nextPosition)
		nextPosition = namespace.getNextTrackPoint(trackID, nextPoint)
		setElementData(train, "trainTracks.nextTrainXYZ", nextPosition)
		local nX, nY, nZ = unpack(nextPosition)
		moveObject(train, 5000, nX, nY, nZ)
	end, 5000, 0)
end

]]

-- USER PART - BUILDING NEW TRACK WITH NEW TRAIN

local customTrains = {}
local customTracks = {}
local thisResource = getThisResource()

function createTracksOnResourceStart()
	setTimer(function()
		local myTrackID, myTrainPoint = 1, 2 -- FIRST WAY, SECOND POINT
		if not customTracks[myTrackID] then customTracks[myTrackID] = {} end
		if not customTrains[myTrackID] then customTrains[myTrackID] = {} end
		customTracks[myTrackID].myTrack = namespace.createTrack(myTrackID) -- CREATING TRACK
		customTracks[myTrackID].tracks = getElementData(customTracks[myTrackID].myTrack, "trainTracks.tracks") -- GET TRACK'S POINT TABLE
		for i = 1, #customTracks[myTrackID].tracks do
			local currentPoint = createElement("customTrainTrack.point") -- EACH POINT IS ELEMENT
			setElementData(currentPoint, "trainTracks.currentTrackXYZ", tracksTable[myTrackID].tracks[i]) -- SET POINT POSITION DATA
			setElementData(currentPoint, "trainTracks.nextTrackXYZ", namespace.getNextTrackPoint(myTrackID, i)) -- NEXT POSITION
		end
		customTrains[myTrackID].myTrain = namespace.createTrain(myTrackID, myTrainPoint, 1) -- CREATING TRAIN
		setElementData(customTrains[myTrackID].myTrain, "trainTracks.currentTrainPoint", myTrainPoint) -- SET TRAIN CURRENT POINT
		setElementData(customTrains[myTrackID].myTrain, "trainTracks.currentTrainXYZ", tracksTable[myTrackID].tracks[myTrainPoint]) -- SET TRAIN CURRENT POINT DATA
		setElementData(customTrains[myTrackID].myTrain, "trainTracks.nextTrainXYZ", namespace.getNextTrackPoint(myTrackID, myTrainPoint)) -- NEXT POINT
		-- TESTING HOW TRAIN'S MOVING
		-- namespace.moveTrain(myTrackID, customTrains[myTrackID].myTrain, myTrainPoint, unpack(namespace.getNextTrackPoint(myTrackID, myTrainPoint)))
	end, 2000, 1)
end
addEventHandler("onResourceStart", getResourceRootElement(thisResource), createTracksOnResourceStart)

function setNewTrackPoint(train)
	local trackID = getElementData(train, "trainTracks.trackID")
	local nextPoint = getElementData(train, "trainTracks.currentTrainPoint")
	setElementData(train, "trainTracks.currentTrainPoint", namespace.getNextTrackPoint(trackID, nextPoint, true))
	local nextPosition = getElementData(train, "trainTracks.nextTrainXYZ")
	setElementData(train, "trainTracks.currentTrainXYZ", nextPosition)
	nextPosition = namespace.getNextTrackPoint(trackID, nextPoint)
	setElementData(train, "trainTracks.nextTrainXYZ", nextPosition)
	triggerClientEvent(root, "trainTracks.onClientTrainSpawn", root)
end
addEvent("trainTracks.onSetTrackPoint", true)
addEventHandler("trainTracks.onSetTrackPoint", root, setNewTrackPoint)