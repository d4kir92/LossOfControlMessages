-- Config

LOCname = "LossOfControlMessages |T135860/:16:16:0:0|t by |cff3FC7EBD4KiR |T132115/:16:16:0:0|t"

SetCVar("ScriptErrors", 1)
LOCDEBUG = false

LOCTABPC = LOCTABPC or {}

function LOCGetConfig(str, val)
	local setting = val
	if LOCTABPC ~= nil then
		if LOCTABPC[str] == nil then
			LOCTABPC[str] = val
		end
		setting = LOCTABPC[str]
	else
		LOCTABPC = LOCTABPC or {}
	end
	return setting
end
