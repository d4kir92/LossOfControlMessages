-- By D4KiR
local AddonName, LocMessages = ...
local locset = nil
local DEFAULT_WIDTH = 520
local DEFAULT_HEIGHT = 520
function LocMessages:ToggleSettings()
	if locset == nil then return end
	locset:Toggle()
end

local LOCTypes = {"CHARM", "CONFUSE", "DISARM", "FEAR", "FEAR_MECHANIC", "PACIFY", "PACIFYSILENCE", "POSSESS", "ROOT", "SCHOOL_INTERRUPT", "SILENCE", "STUN", "STUN_MECHANIC"}
local function GetCollapsed(key)
	if key == nil then return nil end
	if type(LOCTABPC) ~= "table" then return nil end
	if type(LOCTABPC["COLLAPSED"]) ~= "table" then return nil end
	return LOCTABPC["COLLAPSED"][key]
end

local function SetCollapsed(key, collapsed)
	if key == nil then return end
	if type(LOCTABPC) ~= "table" then return end
	if type(LOCTABPC["COLLAPSED"]) ~= "table" then LOCTABPC["COLLAPSED"] = {} end
	if collapsed then
		LOCTABPC["COLLAPSED"][key] = true
	else
		LOCTABPC["COLLAPSED"][key] = nil
	end
end

local function AddCategory(key, label, level, collapsed)
	locset:AddCategory({
		["label"] = label or ("LID_" .. key),
		["key"] = key,
		["search"] = key,
		["level"] = level,
		["collapsed"] = collapsed
	})
end

local function AddCheckbox(key, default, func)
	locset:AddCheckbox({
		["label"] = "LID_" .. key,
		["search"] = key,
		["value"] = LocMessages:GetConfig(key, default),
		["func"] = function(value)
			LOCTABPC[key] = value
			if func then func(value) end
		end
	})
end

local function AddEditbox(key, label, search)
	locset:AddEditbox({
		["label"] = label or ("LID_" .. key),
		["search"] = search or key,
		["value"] = LocMessages:GetConfig(key, ""),
		["maxLetters"] = 20,
		["func"] = function(value) LOCTABPC[key] = value end
	})
end

local function AddAffixes(prefix, label)
	AddCategory(string.upper(prefix), label, 2, true)
	AddEditbox(prefix, "LID_ALLTYPES", prefix)
	for _, loctype in ipairs(LOCTypes) do
		AddEditbox(prefix .. "_" .. loctype, "LID_" .. string.lower(loctype), prefix .. " " .. loctype)
	end
end

function LocMessages:InitSetting()
	LOCTABPC = LOCTABPC or {}
	locset = LocMessages:CreateUIWindow({
		["name"] = "LossOfControlMessagesSettings",
		["pTab"] = {"CENTER"},
		["width"] = LocMessages:GetConfig("WINDOWWIDTH", DEFAULT_WIDTH),
		["height"] = LocMessages:GetConfig("WINDOWHEIGHT", DEFAULT_HEIGHT),
		["minWidth"] = 360,
		["minHeight"] = 240,
		["onResize"] = function(width, height)
			LOCTABPC["WINDOWWIDTH"] = width
			LOCTABPC["WINDOWHEIGHT"] = height
		end,
		["getCollapsed"] = function(key) return GetCollapsed(key) end,
		["setCollapsed"] = function(key, collapsed) SetCollapsed(key, collapsed) end,
		["title"] = format("|T135860:16:16:0:0|t LossOfControlMessages by |cff55d2ffD4KiR |T132115:16:16:0:0|t v%s", LocMessages:GetVersion())
	})

	locset:SuspendLayout()
	locset:AddSearch()
	AddCategory("GENERAL")
	AddCheckbox("MMBTN", true, function(value)
		if value then
			LocMessages:ShowMMBtn("LocMessages")
		else
			LocMessages:HideMMBtn("LocMessages")
		end
	end)

	AddCheckbox("printnothing", false)
	AddCategory("LOCTYPES")
	for _, loctype in ipairs(LOCTypes) do
		AddCheckbox(string.lower(loctype), true)
	end

	AddCategory("VISIBILITY")
	AddCheckbox("showinarenas", true)
	AddCheckbox("showinbgs", false)
	AddCheckbox("showinraids", false)
	AddCheckbox("showoutsideofinstance", false)
	if UnitGroupRolesAssigned and LocMessages:GetWoWBuildNr() > 19999 then
		AddCategory("ROLES", nil, 2)
		AddCheckbox("showashealer", true)
		AddCheckbox("showasdamager", false)
		AddCheckbox("showastank", false)
	end

	AddCategory("OUTPUT")
	AddCheckbox("showlocchat", true)
	AddCheckbox("showlocemote", true)
	AddCheckbox("showdispelltype", true)
	AddCheckbox("showinenglishonly", false)
	locset:AddDropdown({
		["label"] = "LID_channelchat",
		["search"] = "channelchat",
		["value"] = LocMessages:GetConfig("channelchat", "AUTO"),
		["choices"] = {
			{
				["value"] = "AUTO",
				["label"] = "LID_tAUTO"
			},
			{
				["value"] = "PARTY",
				["label"] = "LID_tPARTY"
			},
			{
				["value"] = "RAID",
				["label"] = "LID_tRAID"
			},
			{
				["value"] = "RAID_WARNING",
				["label"] = "LID_tRAID_WARNING"
			},
			{
				["value"] = "INSTANCE_CHAT",
				["label"] = "LID_tINSTANCE_CHAT"
			},
			{
				["value"] = "YELL",
				["label"] = "LID_tYELL"
			},
			{
				["value"] = "SAY",
				["label"] = "LID_tSAY"
			},
		},
		["func"] = function(value) LOCTABPC["channelchat"] = value end
	})

	AddAffixes("prefix", "LID_prefix")
	AddAffixes("suffix", "LID_suffix")
	locset:ResumeLayout()
	LocMessages:AddSlash("loc", LocMessages.ToggleSettings)
	LocMessages:AddSlash("locm", LocMessages.ToggleSettings)
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
		LocMessages:SetVersion(135860, "1.3.0")
		LocMessages:CreateMinimapButton({
			["name"] = "LocMessages",
			["icon"] = 135860,
			["dbtab"] = LOCTABPC,
			["vTT"] = {{"|T135860:16:16:0:0|t LossOfControlMessages", "v" .. LocMessages:GetVersion()}, {LocMessages:Trans("LID_LEFTCLICK"), LocMessages:Trans("LID_OPENSETTINGS")}, {LocMessages:Trans("LID_RIGHTCLICK"), LocMessages:Trans("LID_HIDEMINIMAPBUTTON")}},
			["funcL"] = function() LocMessages:ToggleSettings() end,
			["funcR"] = function()
				LocMessages:SV(LOCTABPC, "MMBTN", false)
				LocMessages:MSG("Minimap Button is now hidden.")
				LocMessages:HideMMBtn("LocMessages")
			end,
			["dbkey"] = "MMBTN"
		})
	elseif event == "PLAYER_LOGIN" and not LOCloaded then
		frame:UnregisterEvent("PLAYER_LOGIN")
		LOCloaded = true
		C_Timer.After(0, function()
			LocMessages:SetSetup(true)
			LocMessages:SetupLOC()
		end)
	end
end

frame:SetScript("OnEvent", frame.OnEvent)
