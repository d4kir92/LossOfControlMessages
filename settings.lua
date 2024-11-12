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
	LOCTABPC = LOCTABPC or {}
	LocMessages:SetVersion(AddonName, 135860, "1.2.50")
	loc_settings = LocMessages:CreateFrame(
		{
			["name"] = "LOC Messages",
			["pTab"] = {"CENTER"},
			["sw"] = 520,
			["sh"] = 520,
			["title"] = format("LOC Messages |T135860:16:16:0:0|t v|cff3FC7EB%s", "1.2.50")
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
		LocMessages:AppendCheckbox("onlyasheal", false)
	end

	LocMessages:AppendCheckbox("showlocchat", true)
	LocMessages:AppendCheckbox("showlocemote", true)
	LocMessages:AppendCheckbox("showinenglishonly", false)
	LocMessages:AppendCheckbox("showdispelltype", true)
	local settings_channel = {}
	settings_channel.name = "channelchat"
	settings_channel.parent = loc_settings.SC
	settings_channel.text = "channelchat"
	settings_channel.value = LocMessages:GetConfig("channelchat", "AUTO")
	settings_channel.x = 0
	settings_channel.y = LocMessages:GetAppendY()
	settings_channel.dbvalue = "channelchat"
	settings_channel.tab = {
		{
			Name = "Auto",
			Code = "AUTO"
		},
		{
			Name = "Party",
			Code = "PARTY"
		},
		{
			Name = "Raid",
			Code = "RAID"
		},
		{
			Name = "Raid Warning",
			Code = "RAID_WARNING"
		},
		{
			Name = "Instance Chat",
			Code = "INSTANCE_CHAT"
		},
		{
			Name = "Yell (Higher range as Say)",
			Code = "YELL"
		},
		{
			Name = "Say (Local-Range Message)",
			Code = "SAY"
		}
	}

	LocMessages:CreateComboBox(settings_channel)
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
	for i, v in pairs(LOCTypes) do
		local prefix = {}
		prefix.name = "prefix"
		prefix.parent = loc_settings.SC
		prefix.value = LocMessages:GetConfig("prefix_" .. v, "")
		prefix.text = LocMessages:Trans("prefix") .. " (" .. v .. ")"
		prefix.x = 10
		prefix.y = LocMessages:GetAppendY()
		prefix.dbvalue = "prefix_" .. v
		LocMessages:CreateTextBox(prefix)
		LocMessages:SetAppendY(LocMessages:GetAppendY() - BR)
	end

	LocMessages:AppendCategory("suffix")
	for i, v in pairs(LOCTypes) do
		local suffix = {}
		suffix.name = "suffix"
		suffix.parent = loc_settings.SC
		suffix.value = LocMessages:GetConfig("suffix_" .. v, "")
		suffix.text = LocMessages:Trans("suffix") .. " (" .. v .. ")"
		suffix.x = 10
		suffix.y = LocMessages:GetAppendY()
		suffix.dbvalue = "suffix_" .. v
		LocMessages:CreateTextBox(suffix)
		LocMessages:SetAppendY(LocMessages:GetAppendY() - BR)
	end

	LocMessages:CreateMinimapButton(
		{
			["name"] = "LocMessages",
			["icon"] = 135860,
			["dbtab"] = LOCTABPC,
			["vTT"] = {{"LocMessages |T135860:16:16:0:0|t", "v|cff3FC7EB1.2.50"}, {"Leftclick", "Toggle Settings"}, {"Rightclick", "Hide Minimap Icon"}},
			["funcL"] = function()
				LocMessages:ToggleSettings()
			end,
			["funcR"] = function()
				LocMessages:SV(LOCTABPC, "MMBTN", false)
				LocMessages:MSG("Minimap Button is now hidden.")
				LocMessages:HideMMBtn("LocMessages")
			end,
		}
	)

	LocMessages:AddSlash("loc", LocMessages.ToggleSettings)
	LocMessages:AddSlash("locmsg", LocMessages.ToggleSettings)
	LocMessages:AddSlash("locmessages", LocMessages.ToggleSettings)
	if LocMessages:GV(LOCTABPC, "MMBTN", true) then
		LocMessages:ShowMMBtn("LocMessages")
	else
		LocMessages:HideMMBtn("LocMessages")
	end
end

local LOCloaded = false
local LOCSETUP = false
function LocMessages:GetSetup()
	return LOCSETUP
end

function LocMessages:SetSetup(val)
	LOCSETUP = val
end

local vars = false
local addo = false
local frame = CreateFrame("FRAME")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("VARIABLES_LOADED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
function frame:OnEvent(event)
	if event == "VARIABLES_LOADED" then
		vars = true
	end

	if event == "ADDON_LOADED" then
		addo = true
	end

	if vars and addo and not LOCloaded then
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
