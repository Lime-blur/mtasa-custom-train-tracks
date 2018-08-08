-- LIME'S PROJECTS DEV.
-- CUSTOM TRAIN TRACKS

-- DEVELOPING PART

local thisResource = getThisResource()

function replaceTrainModels()
	local txd = engineLoadTXD("files/freight.txd", 14814)
	engineImportTXD(txd, 14814)
	local dff = engineLoadDFF("files/freight.dff", 14814)
	engineReplaceModel(dff, 14814)
end
addEventHandler("onClientResourceStart", getResourceRootElement(thisResource), replaceTrainModels)

function spawnClientTrain()
	if not isEventHandlerAdded("onClientRender", root, updateTrainSounds) then
		addEventHandler("onClientRender", root, updateTrainSounds)
	end
end
addEvent("trainTracks.onClientTrainSpawn", true)
addEventHandler("trainTracks.onClientTrainSpawn", root, spawnClientTrain)

local trainSounds = {}
local currentTrainSound = {}
local trainPaths = {
	brake = "files/train_brake.wav",
	run = "files/train_run.wav"
}

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

function updateTrainSounds()
	local trains = getElementsByType("object", getResourceRootElement(thisResource))
	local interior = getElementInterior(localPlayer)
	local dimension = getElementDimension(localPlayer)
	for i, train in ipairs(trains) do
		local cX, cY, cZ = getElementPosition(train)
		local rX, rY, rZ = getElementRotation(train)
		local nX, nY, nZ = unpack(getElementData(train, "trainTracks.nextTrainXYZ"))
		setElementRotation(train, findRotation3D(cX, cY, cZ, nX, nY, nZ))
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
					local soundSpeed = getElementSpeed(train, "kmh") / 10 -- TEMP
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