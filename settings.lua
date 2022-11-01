-- By D4KiR

local L = LibStub("AceLocale-3.0"):GetLocale("D4KIRLOCMessagesHelper")

LOCBUILD = "CLASSIC"
if select(4, GetBuildInfo()) >= 100000 then
	LOCBUILD = "RETAIL"
elseif select(4, GetBuildInfo()) > 29999 then
	LOCBUILD = "WRATH"
elseif select(4, GetBuildInfo()) > 19999 then
	LOCBUILD = "TBC"
end

function LOCInitSetting()
	local LOCTAB_Settings = {}
	LOCTAB_Settings.panel = CreateFrame("Frame", "LOCTAB_Settings", UIParent)
	LOCTAB_Settings.panel.name = LOCname

	local BR = 16
	local HR = 20
	local DR = 30
	local SR = 40
	local Y = -10

	local settings_header = {}
	settings_header.frame = LOCTAB_Settings.panel
	settings_header.parent = LOCTAB_Settings.panel
	settings_header.x = 10
	settings_header.y = Y
	settings_header.text = LOCname
	settings_header.textsize = 24
	LOCCreateText(settings_header)
	Y = Y - 30

	local settings_printnothing = {}
	settings_printnothing.name = "printnothing"
	settings_printnothing.parent = LOCTAB_Settings.panel
	settings_printnothing.checked = LOCGetConfig("printnothing", false)
	settings_printnothing.text = L["printnothing"]
	settings_printnothing.x = 10
	settings_printnothing.y = Y
	settings_printnothing.dbvalue = "printnothing"
	LOCCreateCheckBox(settings_printnothing)
	Y = Y - BR

	local settings_showinraids = {}
	settings_showinraids.name = "showinraids"
	settings_showinraids.parent = LOCTAB_Settings.panel
	settings_showinraids.checked = LOCGetConfig("showinraids", false)
	settings_showinraids.text = L["showinraids"]
	settings_showinraids.x = 10
	settings_showinraids.y = Y
	settings_showinraids.dbvalue = "showinraids"
	LOCCreateCheckBox(settings_showinraids)
	Y = Y - BR

	local settings_showinbgs = {}
	settings_showinbgs.name = "showinbgs"
	settings_showinbgs.parent = LOCTAB_Settings.panel
	settings_showinbgs.checked = LOCGetConfig("showinbgs", false)
	settings_showinbgs.text = L["showinbgs"]
	settings_showinbgs.x = 10
	settings_showinbgs.y = Y
	settings_showinbgs.dbvalue = "showinbgs"
	LOCCreateCheckBox(settings_showinbgs)
	Y = Y - BR
	
	local settings_showdispelltype = {}
	settings_showdispelltype.name = "showdispelltype"
	settings_showdispelltype.parent = LOCTAB_Settings.panel
	settings_showdispelltype.checked = LOCGetConfig("showdispelltype", true)
	settings_showdispelltype.text = L["showdispelltype"]
	settings_showdispelltype.x = 10
	settings_showdispelltype.y = Y
	settings_showdispelltype.dbvalue = "showdispelltype"
	LOCCreateCheckBox(settings_showdispelltype)
	Y = Y - DR

	Y = Y - HR
	local settings_showlocchat = {}
	settings_showlocchat.name = "showlocchat"
	settings_showlocchat.parent = LOCTAB_Settings.panel
	settings_showlocchat.checked = LOCGetConfig("showlocchat", true)
	settings_showlocchat.text = L["showlocchat"]
	settings_showlocchat.x = 10
	settings_showlocchat.y = Y
	settings_showlocchat.dbvalue = "showlocchat"
	LOCCreateCheckBox(settings_showlocchat)
	Y = Y - BR

	local settings_showlocemote = {}
	settings_showlocemote.name = "showlocemote"
	settings_showlocemote.parent = LOCTAB_Settings.panel
	settings_showlocemote.checked = LOCGetConfig("showlocemote", true)
	settings_showlocemote.text = L["showlocemote"]
	settings_showlocemote.x = 10
	settings_showlocemote.y = Y
	settings_showlocemote.dbvalue = "showlocemote"
	LOCCreateCheckBox(settings_showlocemote)
	Y = Y - DR



	local settings_channel = {}
	settings_channel.name = "channelchat"
	settings_channel.parent = LOCTAB_Settings.panel
	settings_channel.text = "channelchat"
	settings_channel.value = LOCGetConfig("channelchat", "AUTO")
	settings_channel.x = 0
	settings_channel.y = Y
	settings_channel.dbvalue = "channelchat"
	settings_channel.tab = {
		{ Name = "Auto", Code = "AUTO" },
		{ Name = "Party", Code = "PARTY" },
		{ Name = "Raid", Code = "RAID" },
		{ Name = "Raid Warning", Code = "RAID_WARNING" },
		{ Name = "Say", Code = "SAY" },
		{ Name = "Yell", Code = "YELL" },
		{ Name = "Instance Chat", Code = "INSTANCE_CHAT" }
	}
	LOCCreateComboBox(settings_channel)

	local settings_showtranslation = {}
	settings_showtranslation.name = "showtranslation"
	settings_showtranslation.parent = LOCTAB_Settings.panel
	settings_showtranslation.checked = LOCGetConfig("showtranslation", true)
	settings_showtranslation.text = "Show Translation"
	settings_showtranslation.x = 210
	settings_showtranslation.y = Y
	settings_showtranslation.dbvalue = "showtranslation"
	LOCCreateCheckBox(settings_showtranslation)
	Y = Y - SR

	local settings_prefix = {}
	settings_prefix.name = "prefix"
	settings_prefix.parent = LOCTAB_Settings.panel
	settings_prefix.value = LOCGetConfig("prefix", "[LOC]")
	settings_prefix.text = L["prefix"] .. " (ALL)"
	settings_prefix.x = 10
	settings_prefix.y = Y
	settings_prefix.dbvalue = "prefix"
	LOCCreateTextBox(settings_prefix)

	local settings_suffix = {}
	settings_suffix.name = "suffix"
	settings_suffix.parent = LOCTAB_Settings.panel
	settings_suffix.value = LOCGetConfig("suffix", "")
	settings_suffix.text = L["suffix"] .. " (ALL)"
	settings_suffix.x = 10 + 300 + 10
	settings_suffix.y = Y
	settings_suffix.dbvalue = "suffix"
	LOCCreateTextBox(settings_suffix)
	Y = Y - BR

	local LOCTypes = {
		"DISARM",
		"STUN_MECHANIC",
		"STUN",
		"PACIFYSILENCE",
		"SILENCE",
		"FEAR",
		"CHARM",
		"PACIFY",
		"CONFUSE",
		"POSSESS",
		"SCHOOL_INTERRUPT",
		"ROOT",
		"FEAR_MECHANIC",
		"NONE"
	}

	for i, v in pairs( LOCTypes ) do
		local settings_prefix = {}
		settings_prefix.name = "prefix"
		settings_prefix.parent = LOCTAB_Settings.panel
		settings_prefix.value = LOCGetConfig("prefix_" .. v, "")
		settings_prefix.text = L["prefix"] .. " (" .. v .. ")"
		settings_prefix.x = 10
		settings_prefix.y = Y
		settings_prefix.dbvalue = "prefix_" .. v
		LOCCreateTextBox(settings_prefix)
	
		local settings_suffix = {}
		settings_suffix.name = "suffix"
		settings_suffix.parent = LOCTAB_Settings.panel
		settings_suffix.value = LOCGetConfig("suffix_" .. v, "")
		settings_suffix.text = L["suffix"] .. " (" .. v .. ")"
		settings_suffix.x = 10 + 300 + 10
		settings_suffix.y = Y
		settings_suffix.dbvalue = "suffix_" .. v
		LOCCreateTextBox(settings_suffix)
		Y = Y - BR
	end

	-- RIGHT
	local LX = 300
	local LY = -46
	local c = 0
	for i, loctype in pairs(LOCTypes) do
		loctype = string.lower(loctype)
		local settings_logtest = {}
		settings_logtest.name = loctype
		settings_logtest.parent = LOCTAB_Settings.panel
		if loctype == "disarm" then
			settings_logtest.checked = LOCGetConfig(loctype, false)
		else
			settings_logtest.checked = LOCGetConfig(loctype, true)
		end
		settings_logtest.text = loctype
		settings_logtest.x = LX
		settings_logtest.y = LY
		settings_logtest.dbvalue = loctype
		LOCCreateCheckBox(settings_logtest)

		LY = LY - 16
		c = c + 1
		if c == 7 then
			c = 0
			LX = LX + 160
			LY = -46
		end
	end


	InterfaceOptions_AddCategory(LOCTAB_Settings.panel)
end

LOCloaded = false
LOCSETUP = false

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
		C_Timer.After(0, function()
			LOCSETUP = true

			SetupLOC()
		end)
	end
end
frame:SetScript("OnEvent", frame.OnEvent)
