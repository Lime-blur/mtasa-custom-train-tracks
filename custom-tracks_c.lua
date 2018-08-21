-- LIME'S PROJECTS DEV.
-- CUSTOM TRAIN TRACKS

-- DEVELOPING PART

local thisResource = getThisResource()
local progress = nil
local isAllowed = false

-- REPLACE MODELS

function replaceTrainModels()
	local txd = engineLoadTXD("files/freight.txd", 14814)
	engineImportTXD(txd, 14814)
	local dff = engineLoadDFF("files/freight.dff", 14814)
	engineReplaceModel(dff, 14814)
end
addEventHandler("onClientResourceStart", getResourceRootElement(thisResource), replaceTrainModels)

-- EVENT WHEN TRAIN SPAWNS

function spawnClientTrain()
	progress = 0
	isAllowed = true
	if not isEventHandlerAdded("onClientRender", root, updateTrainSounds) then
		addEventHandler("onClientRender", root, updateTrainSounds)
	end
end
addEvent("trainTracks.onClientTrainSpawn", true)
addEventHandler("trainTracks.onClientTrainSpawn", root, spawnClientTrain)

-- TRAIN'S SOUND

local trainSounds = {}
local currentTrainSound = {}
local trainPaths = {
	brake = "files/train_brake.wav",
	run = "files/train_run.wav"
}

-- DESTROY ANY TRAIN'S SOUNDS

addEventHandler("onClientElementDestroy", root,
	function()
		if getElementType(source) == "object" then
			if trainSounds[source] then
				destroyElement(trainSounds[source])
				trainSounds[source] = nil
			end
		end
	end
)

-- UPDATE TRAIN'S SOUND AND ROTATION

function updateTrainSounds()
	progress = progress + 0.005
	local trains = getElementsByType("object", getResourceRootElement(thisResource))
	local interior = getElementInterior(localPlayer)
	local dimension = getElementDimension(localPlayer)
	for i, train in ipairs(trains) do
		-- SPEED
		local cX, cY, cZ = unpack(getElementData(train, "trainTracks.currentTrainXYZ"))
		local nX, nY, nZ = unpack(getElementData(train, "trainTracks.nextTrainXYZ"))
		setElementRotation(train, findRotation3D(cX, cY, cZ, nX, nY, nZ))
		local resX, resY, resZ = interpolateBetween(cX, cY, cZ, nX, nY, nZ, progress, "Linear")
		setElementVelocity(train, (cX-resX)/progress, (cY-resY)/progress, (cZ-resZ)/progress)
		if (progress >= 1) and (isAllowed == true) then
			triggerServerEvent("trainTracks.onSetTrackPoint", localPlayer, train)
			isAllowed = false
		end
		-- SOUND
		if (getElementInterior(train) == interior) and (getElementDimension(train) == dimension) then
			local trainID = getElementData(train, "trainTracks.id")
			if trainsTable[trainID] then
				local X, Y, Z = getElementPosition(train)
				if getElementSpeed(train, "kmh") < 10 and currentTrainSound[train] ~= 0 then
					if trainSounds[train] then
						destroyElement(trainSounds[train])
						trainSounds[train] = nil
					end
					trainSounds[train] = playSound3D(trainPaths.run, X, Y, Z, true)
					attachElements(trainSounds[train], train)
					setSoundMaxDistance(trainSounds[train], 60)
					currentTrainSound[train] = 0
				elseif getElementSpeed(train, "kmh") > 10 and currentTrainSound[train] ~= 1 then
					if trainSounds[train] then
						destroyElement(trainSounds[train])
						trainSounds[train] = nil
					end
					local X, Y, Z = getElementPosition(train)
					trainSounds[train] = playSound3D(trainPaths.run, X, Y, Z, true)
					attachElements(trainSounds[train], train)
					setSoundMaxDistance(trainSounds[train], 60)
					currentTrainSound[train] = 1
				elseif getElementSpeed(train, "kmh") > 10 and currentTrainSound[train] == 1 then
					local soundSpeed = getElementSpeed(train, "kmh") / 2000
					if trainSounds[train] then
						setSoundSpeed(trainSounds[train], soundSpeed)
					else
						if isElement(trainSounds[train]) then
							destroyElement(trainSounds[train])
							trainSounds[train] = nil
						end
					end
				end
			end
		else
			if trainSounds[train] and getElementType(trainSounds[train]) == "sound" then
				destroyElement(trainSounds[train])
				trainSounds[train] = nil
			end
		end
	end
end