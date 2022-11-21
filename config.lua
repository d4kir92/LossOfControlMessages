-- Config

local AddOnName, LocMessages = ...

function LocMessages:GetConfig(str, val)
	LOCTABPC = LOCTABPC or {}

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
