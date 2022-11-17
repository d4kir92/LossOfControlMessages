-- LIB Math

local AddOnName, LocMessages = ...

function LocMessages:MathR(num, dec)
	dec = dec or 2
	num = num or 0
	return tonumber(string.format("%." .. dec .. "f", num))
end
