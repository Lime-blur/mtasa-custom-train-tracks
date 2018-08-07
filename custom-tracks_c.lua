-- LIME'S PROJECTS DEV.
-- CUSTOM TRAIN TRACKS

function replaceTrainModels()
	local txd = engineLoadTXD("freight.txd", 14814)
	engineImportTXD(txd, 14814)
	local dff = engineLoadDFF("freight.dff", 14814)
	engineReplaceModel(dff, 14814)
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), replaceTrainModels)