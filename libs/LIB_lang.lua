local _, LocMessages = ...
LocMessages:SetAddonOutput("LossOfControlMessages", 135860)
local L = LibStub("AceLocale-3.0"):GetLocale("D4KIRLOCMessagesHelper")
function LocMessages:GT(str)
	return L[str] or str
end
