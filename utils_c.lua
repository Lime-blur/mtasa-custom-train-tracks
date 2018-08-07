-- LIME'S PROJECTS DEV.
-- CUSTOM TRAIN TRACKS

function getElementSpeed(element, unit)
	if (unit == nil) then unit = 0 end
	if (isElement(element)) then
		local x, y, z = getElementVelocity(element)
		return (x^2 + y^2 + z^2) ^ 0.5 * 1.61 * 100
	end
end

function isEventHandlerAdded(sEventName, pElementAttachedTo, func)
	if type(sEventName) == "string" and isElement(pElementAttachedTo) and type(func) == "function" then
		local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
		if type(aAttachedFunctions) == "table" and #aAttachedFunctions > 0 then
			for i, v in ipairs(aAttachedFunctions) do
				if v == func then
					return true
				end
			end
		end
	end
	return false
end
