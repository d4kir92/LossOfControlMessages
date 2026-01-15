-- By D4KiR
local AddonName, LocMessages = ...
local loc_settings = nil
function LocMessages:ToggleSettings()
	if loc_settings then
		if loc_settings:IsShown() then
			loc_settings:Hide()
		else
			loc_settings:Show()
		end
	end
end

local BR = 16
local LOCTypes = {"DISARM", "STUN_MECHANIC", "STUN", "PACIFYSILENCE", "SILENCE", "FEAR", "CHARM", "PACIFY", "CONFUSE", "POSSESS", "SCHOOL_INTERRUPT", "ROOT", "FEAR_MECHANIC", "NONE"}
function LocMessages:InitSetting()
	loc_settings = LocMessages:CreateWindow(
		{
			["name"] = "LOC Messages",
			["pTab"] = {"CENTER"},
			["sw"] = 520,
			["sh"] = 520,
			["title"] = format("|T135860:16:16:0:0|t L|cff3FC7EBoss|rO|cff3FC7EBf|rC|cff3FC7EBontrol|rM|cff3FC7EBessages|r v|cff3FC7EB%s", LocMessages:GetVersion())
		}
	)

	loc_settings.SF = CreateFrame("ScrollFrame", "loc_settings_SF", loc_settings, "UIPanelScrollFrameTemplate")
	loc_settings.SF:SetPoint("TOPLEFT", loc_settings, 8, -26)
	loc_settings.SF:SetPoint("BOTTOMRIGHT", loc_settings, -32, 8)
	loc_settings.SC = CreateFrame("Frame", "loc_settings_SC", loc_settings.SF)
	loc_settings.SC:SetSize(loc_settings.SF:GetSize())
	loc_settings.SC:SetPoint("TOPLEFT", loc_settings.SF, "TOPLEFT", 0, 0)
	loc_settings.SF:SetScrollChild(loc_settings.SC)
	local y = 0
	LocMessages:SetAppendY(y)
	LocMessages:SetAppendParent(loc_settings.SC)
	LocMessages:SetAppendTab(LOCTABPC)
	LocMessages:AppendCategory("GENERAL")
	LocMessages:AppendCheckbox(
		"MMBTN",
		true,
		function(sel, checked)
			if checked then
				LocMessages:ShowMMBtn("LocMessages")
			else
				LocMessages:HideMMBtn("LocMessages")
			end
		end
	)

	LocMessages:AppendCategory("OUTPUT")
	LocMessages:AppendCheckbox("printnothing", false)
	if UnitGroupRolesAssigned and LocMessages:GetWoWBuildNr() > 19999 then
		LocMessages:AppendCheckbox("showashealer", true)
		LocMessages:AppendCheckbox("showasdamager", false)
		LocMessages:AppendCheckbox("showastank", false)
	end

	LocMessages:AppendCheckbox("showlocchat", true)
	LocMessages:AppendCheckbox("showlocemote", true)
	LocMessages:AppendCheckbox("showinenglishonly", false)
	LocMessages:AppendCheckbox("showdispelltype", true)
	LocMessages:AppendDropdown(
		"channelchat",
		"AUTO",
		{
			["AUTO"] = "tAUTO",
			["PARTY"] = "tPARTY",
			["RAID"] = "tRAID",
			["RAID_WARNING"] = "tRAID_WARNING",
			["INSTANCE_CHAT"] = "tINSTANCE_CHAT",
			["YELL"] = "tYELL",
			["SAY"] = "tSAY",
		},
		function(val)
			if LOCTABPC and val then
				LOCTABPC["channelchat"] = val
			end
		end
	)

	LocMessages:SetAppendY(LocMessages:GetAppendY() - BR)
	LocMessages:AppendCategory("LOCATION")
	LocMessages:AppendCheckbox("showinarenas", true)
	LocMessages:AppendCheckbox("showinraids", false)
	LocMessages:AppendCheckbox("showoutsideofinstance", false)
	LocMessages:AppendCheckbox("showinbgs", false)
	LocMessages:AppendCategory("LOCTYPES")
	for i, loctype in pairs(LOCTypes) do
		loctype = string.lower(loctype)
		LocMessages:AppendCheckbox(loctype, true)
	end

	LocMessages:AppendCategory("prefix")
	local pre = {}
	pre.name = "prefix"
	pre.parent = loc_settings.SC
	pre.value = LocMessages:GetConfig("prefix", "")
	pre.text = LocMessages:Trans("LID_prefix")
	pre.x = 10
	pre.y = LocMessages:GetAppendY()
	pre.dbvalue = "prefix"
	LocMessages:CreateTextBox(pre)
	LocMessages:SetAppendY(LocMessages:GetAppendY() - BR)
	for i, v in pairs(LOCTypes) do
		local prefix = {}
		prefix.name = "prefix"
		prefix.parent = loc_settings.SC
		prefix.value = LocMessages:GetConfig("prefix_" .. v, "")
		prefix.text = LocMessages:Trans("LID_prefix") .. " (" .. v .. ")"
		prefix.x = 10
		prefix.y = LocMessages:GetAppendY()
		prefix.dbvalue = "prefix_" .. v
		LocMessages:CreateTextBox(prefix)
		LocMessages:SetAppendY(LocMessages:GetAppendY() - BR)
	end

	LocMessages:AppendCategory("suffix")
	local suf = {}
	suf.name = "suffix"
	suf.parent = loc_settings.SC
	suf.value = LocMessages:GetConfig("suffix", "")
	suf.text = LocMessages:Trans("LID_suffix")
	suf.x = 10
	suf.y = LocMessages:GetAppendY()
	suf.dbvalue = "suffix"
	LocMessages:CreateTextBox(suf)
	LocMessages:SetAppendY(LocMessages:GetAppendY() - BR)
	for i, v in pairs(LOCTypes) do
		local suffix = {}
		suffix.name = "suffix"
		suffix.parent = loc_settings.SC
		suffix.value = LocMessages:GetConfig("suffix_" .. v, "")
		suffix.text = LocMessages:Trans("LID_suffix") .. " (" .. v .. ")"
		suffix.x = 10
		suffix.y = LocMessages:GetAppendY()
		suffix.dbvalue = "suffix_" .. v
		LocMessages:CreateTextBox(suffix)
		LocMessages:SetAppendY(LocMessages:GetAppendY() - BR)
	end

	LocMessages:AddSlash("loc", LocMessages.ToggleSettings)
	LocMessages:AddSlash("locmsg", LocMessages.ToggleSettings)
	LocMessages:AddSlash("locmessages", LocMessages.ToggleSettings)
end

local LOCloaded = false
local LOCSETUP = false
function LocMessages:GetSetup()
	return LOCSETUP
end

function LocMessages:SetSetup(val)
	LOCSETUP = val
end

local frame = CreateFrame("FRAME")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
function frame:OnEvent(event, addonName, ...)
	if event == "ADDON_LOADED" and addonName == AddonName then
		frame:UnregisterEvent("ADDON_LOADED")
		LOCTABPC = LOCTABPC or {}
		LocMessages:SetVersion(135860, "1.2.83")
		LocMessages:CreateMinimapButton(
			{
				["name"] = "LocMessages",
				["icon"] = 135860,
				["dbtab"] = LOCTABPC,
				["vTT"] = {{"|T135860:16:16:0:0|t L|cff3FC7EBoss|rO|cff3FC7EBf|rC|cff3FC7EBontrol|rM|cff3FC7EBessages|r", "v|cff3FC7EB" .. LocMessages:GetVersion()}, {LocMessages:Trans("LID_LEFTCLICK"), LocMessages:Trans("LID_OPENSETTINGS")}, {LocMessages:Trans("LID_RIGHTCLICK"), LocMessages:Trans("LID_HIDEMINIMAPBUTTON")}},
				["funcL"] = function()
					LocMessages:ToggleSettings()
				end,
				["funcR"] = function()
					LocMessages:SV(LOCTABPC, "MMBTN", false)
					LocMessages:MSG("Minimap Button is now hidden.")
					LocMessages:HideMMBtn("LocMessages")
				end,
				["dbkey"] = "MMBTN"
			}
		)
	elseif event == "PLAYER_LOGIN" and not LOCloaded then
		frame:UnregisterEvent("PLAYER_LOGIN")
		LOCloaded = true
		C_Timer.After(
			0,
			function()
				LocMessages:SetSetup(true)
				LocMessages:SetupLOC()
			end
		)
	end
end

frame:SetScript("OnEvent", frame.OnEvent)
