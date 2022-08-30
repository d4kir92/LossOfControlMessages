-- By D4KiR

local L = LibStub("AceLocale-3.0"):GetLocale("D4KIRLOCMessagesHelper")

function LOCAllowedTo()
	local _channel = LOCGetConfig("channelchat", "AUTO")
	if (GetNumGroupMembers() > 0 or GetNumSubgroupMembers() > 0 or _channel == "SAY" or _channel == "YELL") and LOCGetConfig("printnothing", false) == false then
		return true
	end
	return false
end

function LOCToCurrentChat(msg)
	local _channel = "SAY"
	local inInstance, instanceType = IsInInstance()

	if LOCGetConfig("channelchat", "AUTO") == "AUTO" then
		if IsInRaid(LE_PARTY_CATEGORY_HOME) then
			_channel = "RAID"
		elseif IsInRaid(LE_PARTY_CATEGORY_INSTANCE) or IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
			_channel = "INSTANCE_CHAT"
		elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
			_channel = "PARTY"
		end
	else
		_channel = LOCGetConfig("channelchat", "AUTO")
	end

	local prefix = LOCGetConfig("prefix", "[LOC]")
	local suffix = LOCGetConfig("suffix", "")

	if prefix ~= "" and prefix ~= " " then
		prefix = prefix .. " "
	elseif prefix == " " then
		prefix = ""
	end
	if suffix ~= "" and suffix ~= " " then
		suffix = " " .. suffix
	elseif suffix == " " then
		suffix = ""
	end

	if GetNumGroupMembers() > 0 or GetNumSubgroupMembers() > 0 or _channel == "SAY" or _channel == "YELL" then
		if LOCGetConfig("printnothing", false) == true then
			-- print nothing
		elseif UnitInBattleground("player") ~= nil and LOCGetConfig("showinbgs", false) == false then
			-- dont print in bg
		elseif UnitInRaid("player") ~= nil and LOCGetConfig("showinraids", false) == false then
			-- dont print in raid
		elseif (_channel == "SAY" or _channel == "YELL") and not inInstance then
			-- ERROR: SAY and YELL only works in instance
		else
			local mes = prefix .. msg .. suffix
			if mes ~= nil then
				SendChatMessage(mes, _channel)
			end
		end
	end
end

function SetupLOC()
	if LOCSETUP then
		if not InCombatLockdown() then
			LOCSETUP = false

			LOCInitSetting()

		else
			C_Timer.After(0.1, function()	
				SetupLOC()
			end)
		end
	end
end

local function LOCGetSchoolType( sid )
	for i = 1, 6 do
		local name, _, _, dispelType, _, _, _, _, _, spellId = UnitAura( "player", i, "HARMFUL" )		
		if spellId and spellId == sid then
			return dispelType
		end
	end
	return nil
end

local dispellableDebuffTypes = { Magic = true, Curse = true, Disease = true, Poison = true};

local locs = {}
local f_loc = CreateFrame("FRAME")
f_loc.past = {}
f_loc:SetScript("OnEvent", function(self, event, id)
	local loctype, text, duration, spellID, dispelType
	if C_LossOfControl.GetEventInfo ~= nil then
		loctype, spellID, text, _, _, _, duration, _, _, _ = C_LossOfControl.GetEventInfo(id) --C_LossOfControl.GetEventInfo(id)
	elseif C_LossOfControl.GetActiveLossOfControlData ~= nil then
		local tab = C_LossOfControl.GetActiveLossOfControlData(id)
		loctype = tab["locType"]
		text = tab["displayText"]
		duration = tab["duration"]
		spellID = tab["spellID"]
	else
		print("[LOC] FAILED - API not found")
	end

	--print( GetSpellInfo( spellID ) )

	dispelType = LOCGetSchoolType( spellID )

	if loctype ~= nil and duration ~= nil then
		if dispelType then
			dispelType = string.upper( dispelType )
			if _G["STRING_SCHOOL_" .. dispelType] then
				--dispelType = _G["STRING_SCHOOL_" .. dispelType]
			end
			if LOCGetConfig("showdispelltype", true) then
				text = text .. " [" .. dispelType .. "]"
			end
		end

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

		if tContains(LOCTypes, loctype) and duration ~= nil then
			-- Safe LOCTYPE
			if locs[text] ~= nil then
				if locs[text] < GetTime() then
					locs[text] = nil
				elseif locs[text] > GetTime() then
					return
				end
			else
				locs[text] = GetTime() + duration
			end

			if text and (not self.past[text] or GetTime() > self.past[text]) and LOCGetConfig(string.lower(loctype), false) and not LOCGetConfig("printnothing", false) and loctype ~= "NONE" then
				self.past[text] = GetTime() + duration
				if LOCGetConfig("showlocchat", true) and LOCAllowedTo() then
					LOCToCurrentChat(string.format(L["loctext"], text, LOCMathR(duration, 1)))
				end
				if LOCGetConfig("showlocemote", true) and LOCAllowedTo() then
					DoEmote("helpme")
				end
			end
		elseif not tContains(LOCTypes, loctype) then
			local gam = "CLASSIC"
			if LOCBUILD ~= "CLASSIC" then
				gam = "RETAIL"
			end
			print("[SEND THIS TO THE DEV OF: " .. tostring(LOCname) .. "] [" .. gam .. "]")
			print("Missing LOC Type: " .. loctype .. " text: " .. text)
			print("[SEND THIS TO THE DEV OF: " .. tostring(LOCname) .. "] [" .. gam .. "]")
		end
	end
end)
f_loc:RegisterEvent("LOSS_OF_CONTROL_ADDED")



-- CMDS --
local name, realm = UnitFullName("player")
local cmds = {}

cmds["!loc"] = function()
	LOCmsg("------------------------------------------")
	LOCmsg("!loc help => Shows Help Text")
	LOCmsg("!loc off => Turns LOC Messages off")
	LOCmsg("!loc on => Turns LOC Messages on")
	LOCmsg("------------------------------------------")
end
cmds["!loc help"] = cmds["!loc"]

cmds["!loc off"] = function()
	LOCGetConfig("printnothing", true)
	LOCTABPC["printnothing"] = true

	LOCmsg("Turned off")
end

cmds["!loc on"] = function()
	LOCGetConfig("printnothing", false)
	LOCTABPC["printnothing"] = false

	LOCmsg("Turned on")
end

