-- LIME'S PROJECTS DEV.
-- CUSTOM TRAIN TRACKS

function findRotation3D(x1, y1, z1, x2, y2, z2)
	local rotx = math.atan2(z2 - z1, getDistanceBetweenPoints2D(x2, y2, x1, y1))
	rotx = math.deg(rotx)
	local rotz = -math.deg(math.atan2(x2 - x1, y2 - y1))
	rotz = rotz < 0 and rotz + 360 or rotz
	return rotx, 0, rotz
end

function getElementSpeed(element, unit)
	if (unit == nil) then unit = 0 end
	if (isElement(element)) then
		local x, y, z = getElementVelocity(element)
		return (x^2 + y^2 + z^2) ^ 0.5 * 1.61 * 100
	end
end

function isEventHandlerAdded(sEventName, pElementAttachedTo, func)
	if type(sEventName) == "string" and isElement(pElementAttachedTo) and type(func) == "function" then
		local aAttachedFunctions = getEventHandlers(sEventName, pElementAttachedTo)
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
