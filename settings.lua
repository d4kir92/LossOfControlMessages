-- By D4KiR
local AddonName, LocMessages = ...
local L = LibStub("AceLocale-3.0"):GetLocale("D4KIRLOCMessagesHelper")
local BuildNr = select(4, GetBuildInfo())
local Build = "CLASSIC"
if BuildNr >= 100000 then
	Build = "RETAIL"
elseif BuildNr > 29999 then
	Build = "WRATH"
elseif BuildNr > 19999 then
	Build = "TBC"
end

function LocMessages:GetWoWBuildNr()
	return BuildNr
end

function LocMessages:GetWoWBuild()
	return Build
end

function LocMessages:InitSetting()
	local LOCTAB_Settings = {}
	D4:SetVersion(AddonName, 135860, "1.2.4")
	LOCTAB_Settings.panel = CreateFrame("Frame", "LOCTAB_Settings", UIParent)
	LOCTAB_Settings.panel.name = "LossOfControlMessages |T135860:16:16:0:0|t by |cff3FC7EBD4KiR |T132115:16:16:0:0|t"
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
	settings_header.text = LOCTAB_Settings.panel.name
	settings_header.textsize = 24
	LocMessages:CreateText(settings_header)
	Y = Y - 30
	local settings_printnothing = {}
	settings_printnothing.name = "printnothing"
	settings_printnothing.parent = LOCTAB_Settings.panel
	settings_printnothing.checked = LocMessages:GetConfig("printnothing", false)
	settings_printnothing.text = L["printnothing"]
	settings_printnothing.x = 10
	settings_printnothing.y = Y
	settings_printnothing.dbvalue = "printnothing"
	LocMessages:CreateCheckBox(settings_printnothing)
	Y = Y - BR
	if UnitGroupRolesAssigned and LocMessages:GetWoWBuildNr() > 19999 then
		local settings_onlyasheal = {}
		settings_onlyasheal.name = "onlyasheal"
		settings_onlyasheal.parent = LOCTAB_Settings.panel
		settings_onlyasheal.checked = LocMessages:GetConfig("onlyasheal", false)
		settings_onlyasheal.text = L["onlyasheal"]
		settings_onlyasheal.x = 10
		settings_onlyasheal.y = Y
		settings_onlyasheal.dbvalue = "onlyasheal"
		LocMessages:CreateCheckBox(settings_onlyasheal)
		Y = Y - BR
	end

	local settings_showinarenas = {}
	settings_showinarenas.name = "showinarenas"
	settings_showinarenas.parent = LOCTAB_Settings.panel
	settings_showinarenas.checked = LocMessages:GetConfig("showinarenas", true)
	settings_showinarenas.text = L["showinarenas"]
	settings_showinarenas.x = 10
	settings_showinarenas.y = Y
	settings_showinarenas.dbvalue = "showinarenas"
	LocMessages:CreateCheckBox(settings_showinarenas)
	Y = Y - BR
	local settings_showinraids = {}
	settings_showinraids.name = "showinraids"
	settings_showinraids.parent = LOCTAB_Settings.panel
	settings_showinraids.checked = LocMessages:GetConfig("showinraids", false)
	settings_showinraids.text = L["showinraids"]
	settings_showinraids.x = 10
	settings_showinraids.y = Y
	settings_showinraids.dbvalue = "showinraids"
	LocMessages:CreateCheckBox(settings_showinraids)
	Y = Y - BR
	local settings_showoutsideofinstance = {}
	settings_showoutsideofinstance.name = "showoutsideofinstance"
	settings_showoutsideofinstance.parent = LOCTAB_Settings.panel
	settings_showoutsideofinstance.checked = LocMessages:GetConfig("showoutsideofinstance", false)
	settings_showoutsideofinstance.text = L["showoutsideofinstance"]
	settings_showoutsideofinstance.x = 10
	settings_showoutsideofinstance.y = Y
	settings_showoutsideofinstance.dbvalue = "showoutsideofinstance"
	LocMessages:CreateCheckBox(settings_showoutsideofinstance)
	Y = Y - BR
	local settings_showinenglishonly = {}
	settings_showinenglishonly.name = "showinenglishonly"
	settings_showinenglishonly.parent = LOCTAB_Settings.panel
	settings_showinenglishonly.checked = LocMessages:GetConfig("showinenglishonly", false)
	settings_showinenglishonly.text = L["showinenglishonly"]
	settings_showinenglishonly.x = 10
	settings_showinenglishonly.y = Y
	settings_showinenglishonly.dbvalue = "showinenglishonly"
	LocMessages:CreateCheckBox(settings_showinenglishonly)
	Y = Y - DR
	local settings_showinbgs = {}
	settings_showinbgs.name = "showinbgs"
	settings_showinbgs.parent = LOCTAB_Settings.panel
	settings_showinbgs.checked = LocMessages:GetConfig("showinbgs", false)
	settings_showinbgs.text = L["showinbgs"]
	settings_showinbgs.x = 10
	settings_showinbgs.y = Y
	settings_showinbgs.dbvalue = "showinbgs"
	LocMessages:CreateCheckBox(settings_showinbgs)
	Y = Y - BR
	local settings_showdispelltype = {}
	settings_showdispelltype.name = "showdispelltype"
	settings_showdispelltype.parent = LOCTAB_Settings.panel
	settings_showdispelltype.checked = LocMessages:GetConfig("showdispelltype", true)
	settings_showdispelltype.text = L["showdispelltype"]
	settings_showdispelltype.x = 10
	settings_showdispelltype.y = Y
	settings_showdispelltype.dbvalue = "showdispelltype"
	LocMessages:CreateCheckBox(settings_showdispelltype)
	Y = Y - DR
	Y = Y - HR
	local settings_showlocchat = {}
	settings_showlocchat.name = "showlocchat"
	settings_showlocchat.parent = LOCTAB_Settings.panel
	settings_showlocchat.checked = LocMessages:GetConfig("showlocchat", true)
	settings_showlocchat.text = L["showlocchat"]
	settings_showlocchat.x = 10
	settings_showlocchat.y = Y
	settings_showlocchat.dbvalue = "showlocchat"
	LocMessages:CreateCheckBox(settings_showlocchat)
	Y = Y - BR
	local settings_showlocemote = {}
	settings_showlocemote.name = "showlocemote"
	settings_showlocemote.parent = LOCTAB_Settings.panel
	settings_showlocemote.checked = LocMessages:GetConfig("showlocemote", true)
	settings_showlocemote.text = L["showlocemote"]
	settings_showlocemote.x = 10
	settings_showlocemote.y = Y
	settings_showlocemote.dbvalue = "showlocemote"
	LocMessages:CreateCheckBox(settings_showlocemote)
	Y = Y - DR
	local settings_channel = {}
	settings_channel.name = "channelchat"
	settings_channel.parent = LOCTAB_Settings.panel
	settings_channel.text = "channelchat"
	settings_channel.value = LocMessages:GetConfig("channelchat", "AUTO")
	settings_channel.x = 0
	settings_channel.y = Y
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
		}
	}

	LocMessages:CreateComboBox(settings_channel)
	--[[local settings_showtranslation = {}
	settings_showtranslation.name = "showtranslation"
	settings_showtranslation.parent = LOCTAB_Settings.panel
	settings_showtranslation.checked = LocMessages:GetConfig("showtranslation", true)
	settings_showtranslation.text = "Show Translation"
	settings_showtranslation.x = 210
	settings_showtranslation.y = Y
	settings_showtranslation.dbvalue = "showtranslation"
	LocMessages:CreateCheckBox(settings_showtranslation)]]
	Y = Y - SR
	local settings_prefix = {}
	settings_prefix.name = "prefix"
	settings_prefix.parent = LOCTAB_Settings.panel
	settings_prefix.value = LocMessages:GetConfig("prefix", "[LOC]")
	settings_prefix.text = L["prefix"] .. " (ALL)"
	settings_prefix.x = 10
	settings_prefix.y = Y
	settings_prefix.dbvalue = "prefix"
	LocMessages:CreateTextBox(settings_prefix)
	local settings_suffix = {}
	settings_suffix.name = "suffix"
	settings_suffix.parent = LOCTAB_Settings.panel
	settings_suffix.value = LocMessages:GetConfig("suffix", "")
	settings_suffix.text = L["suffix"] .. " (ALL)"
	settings_suffix.x = 10 + 300 + 10
	settings_suffix.y = Y
	settings_suffix.dbvalue = "suffix"
	LocMessages:CreateTextBox(settings_suffix)
	Y = Y - BR
	local LOCTypes = {"DISARM", "STUN_MECHANIC", "STUN", "PACIFYSILENCE", "SILENCE", "FEAR", "CHARM", "PACIFY", "CONFUSE", "POSSESS", "SCHOOL_INTERRUPT", "ROOT", "FEAR_MECHANIC", "NONE"}
	for i, v in pairs(LOCTypes) do
		local prefix = {}
		prefix.name = "prefix"
		prefix.parent = LOCTAB_Settings.panel
		prefix.value = LocMessages:GetConfig("prefix_" .. v, "")
		prefix.text = L["prefix"] .. " (" .. v .. ")"
		prefix.x = 10
		prefix.y = Y
		prefix.dbvalue = "prefix_" .. v
		LocMessages:CreateTextBox(prefix)
		local suffix = {}
		suffix.name = "suffix"
		suffix.parent = LOCTAB_Settings.panel
		suffix.value = LocMessages:GetConfig("suffix_" .. v, "")
		suffix.text = L["suffix"] .. " (" .. v .. ")"
		suffix.x = 10 + 300 + 10
		suffix.y = Y
		suffix.dbvalue = "suffix_" .. v
		LocMessages:CreateTextBox(suffix)
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
			settings_logtest.checked = LocMessages:GetConfig(loctype, false)
		else
			settings_logtest.checked = LocMessages:GetConfig(loctype, true)
		end

		settings_logtest.text = loctype
		settings_logtest.x = LX
		settings_logtest.y = LY
		settings_logtest.dbvalue = loctype
		LocMessages:CreateCheckBox(settings_logtest)
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