-- LIB Math

function LOCMathR(num, dec)
	dec = dec or 2
	num = num or 0
	return tonumber(string.format("%." .. dec .. "f", num))
end

function LOCRGBToDec(rgb)
	return LOCMathR(rgb / 255, 2)
end
