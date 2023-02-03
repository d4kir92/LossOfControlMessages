-- By D4KiR

local AddOnName, LocMessages = ...

local L = LibStub("AceLocale-3.0"):GetLocale("D4KIRLOCMessagesHelper")

function LocMessages:AllowedTo()
	local _channel = LocMessages:GetConfig("channelchat", "AUTO")
	if (GetNumGroupMembers() > 0 or GetNumSubgroupMembers() > 0 or _channel == "SAY" or _channel == "YELL") and LocMessages:GetConfig("printnothing", false) == false then
		return true
	end
	return false
end

function LocMessages:ToCurrentChat(msg)
	local _channel = "SAY"
	local inInstance, instanceType = IsInInstance()
	local role = ""

	if GetSpecialization and GetSpecializationRole then
		local id = GetSpecialization()
		if id ~= nil then
			role = GetSpecializationRole( id )
		end
	end
	if UnitGroupRolesAssigned then
		role = UnitGroupRolesAssigned( "PLAYER" )
	end

	if LocMessages:GetConfig("channelchat", "AUTO") == "AUTO" then
		if IsInRaid(LE_PARTY_CATEGORY_HOME) then
			_channel = "RAID"
		elseif IsInRaid(LE_PARTY_CATEGORY_INSTANCE) or IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
			_channel = "INSTANCE_CHAT"
		elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
			_channel = "PARTY"
		end
	else
		_channel = LocMessages:GetConfig("channelchat", "AUTO")
	end

	local prefix = LocMessages:GetConfig("prefix", "[LOC]")
	local suffix = LocMessages:GetConfig("suffix", "")

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
	local mes = prefix .. msg .. suffix
	if GetNumGroupMembers() > 0 or GetNumSubgroupMembers() > 0 or _channel == "SAY" or _channel == "YELL" then
		local inArena = IsActiveBattlefieldArena and IsActiveBattlefieldArena()
		local inBg = (inArena == nil or inArena == false) and UnitInBattleground("player")
		local inRaid = UnitInRaid("player")

		if LocMessages:GetConfig("printnothing", false) == true then
			-- print nothing
		elseif inArena and LocMessages:GetConfig("showinarenas", true) == false then
			-- print nothing
		elseif inBg and LocMessages:GetConfig("showinbgs", false) == false then
			-- dont print in bg
		elseif inRaid and LocMessages:GetConfig("showinraids", false) == false then
			-- dont print in raid
		elseif (_channel == "SAY" or _channel == "YELL") and not inInstance then
			-- ERROR: SAY and YELL only works in instance
		elseif not LocMessages:GetConfig("onlyasheal", false) or ( LocMessages:GetConfig("onlyasheal", false) and role == "HEALER" ) then
			if mes ~= nil then
				SendChatMessage(mes, _channel)
			end
		end
	end
end

function LocMessages:SetupLOC()
	if LocMessages:GetSetup() then
		if not InCombatLockdown() then
			LocMessages:SetSetup( false )

			LocMessages:InitSetting()

		else
			C_Timer.After(0.1, function()	
				LocMessages:SetupLOC()
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
			if LocMessages:GetConfig("showdispelltype", true) then
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

			if text and (not self.past[text] or GetTime() > self.past[text]) and LocMessages:GetConfig(string.lower(loctype), false) and not LocMessages:GetConfig("printnothing", false) and loctype ~= "NONE" then
				self.past[text] = GetTime() + duration
				if LocMessages:GetConfig("showlocchat", true) and LocMessages:AllowedTo() then
					local loctypePrefix = LocMessages:GetConfig( "prefix_" .. loctype, "" )
					if loctypePrefix ~= "" then
						text = loctypePrefix .. " " .. text
					end
					local loctypeSuffix = LocMessages:GetConfig( "suffix_" .. loctype, "" )
					if loctypeSuffix ~= "" then
						text = text .. " " .. loctypeSuffix
					end
					LocMessages:ToCurrentChat(string.format(L["loctext"], text, LocMessages:MathR(duration, 1)))
				end
				if LocMessages:GetConfig("showlocemote", true) and LocMessages:AllowedTo() then
					DoEmote("helpme")
				end
			end
		elseif not tContains(LOCTypes, loctype) then
			local gam = "CLASSIC"
			if LocMessages:GetWoWBuild() ~= "CLASSIC" then
				gam = "RETAIL"
			end
			print("[SEND THIS TO THE DEV OF: " .. "LossOfControlMessages" .. "] [" .. gam .. "]")
			print("Missing LOC Type: " .. loctype .. " text: " .. text)
			print("[SEND THIS TO THE DEV OF: " .. "LossOfControlMessages" .. "] [" .. gam .. "]")
		end
	end
end)
f_loc:RegisterEvent("LOSS_OF_CONTROL_ADDED")



-- CMDS --
local name, realm = UnitFullName("player")
local cmds = {}

cmds["!loc"] = function()
	LocMessages:MSG("------------------------------------------")
	LocMessages:MSG("!loc help => Shows Help Text")
	LocMessages:MSG("!loc off => Turns LOC Messages off")
	LocMessages:MSG("!loc on => Turns LOC Messages on")
	LocMessages:MSG("------------------------------------------")
end
cmds["!loc help"] = cmds["!loc"]

cmds["!loc off"] = function()
	LocMessages:GetConfig("printnothing", true)
	LOCTABPC["printnothing"] = true

	LocMessages:MSG("Turned off")
end

cmds["!loc on"] = function()
	LocMessages:GetConfig("printnothing", false)
	LOCTABPC["printnothing"] = false

	LocMessages:MSG("Turned on")
end

