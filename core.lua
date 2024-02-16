-- By D4KiR
local _, LocMessages = ...
local L = LibStub("AceLocale-3.0"):GetLocale("D4KIRLOCMessagesHelper")
function LocMessages:AllowedTo()
	local _channel = LocMessages:GetConfig("channelchat", "AUTO")
	if (GetNumGroupMembers() > 0 or GetNumSubgroupMembers() > 0) and LocMessages:GetConfig("printnothing", false) == false then return true end

	return false
end

function LocMessages:ToCurrentChat(msg)
	local _channel = "AUTO"
	local inInstance, _ = IsInInstance()
	local role = ""
	if GetSpecialization and GetSpecializationRole then
		local id = GetSpecialization()
		if id ~= nil then
			role = GetSpecializationRole(id)
		end
	end

	local canUseRole = false
	if UnitGroupRolesAssigned and LocMessages:GetWoWBuildNr() > 19999 then
		canUseRole = true
		role = UnitGroupRolesAssigned("PLAYER")
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
	if GetNumGroupMembers() > 0 or GetNumSubgroupMembers() > 0 then
		local inArena = IsActiveBattlefieldArena and IsActiveBattlefieldArena()
		local inBg = (inArena == nil or inArena == false) and UnitInBattleground("player")
		local inRaid = UnitInRaid("player")
		if LocMessages:GetConfig("printnothing", false) == true then
		elseif inArena and LocMessages:GetConfig("showinarenas", true) == false then
		elseif inBg and LocMessages:GetConfig("showinbgs", false) == false then
		elseif inRaid and LocMessages:GetConfig("showinraids", false) == false then
		elseif not inInstance and LocMessages:GetConfig("showoutsideofinstance", false) == false then
		elseif (canUseRole == false) or not LocMessages:GetConfig("onlyasheal", false) or (LocMessages:GetConfig("onlyasheal", false) and role == "HEALER") then
			if mes ~= nil then
				SendChatMessage(mes, _channel)
			end
		end
	end
end

function LocMessages:SetupLOC()
	if LocMessages:GetSetup() then
		if not InCombatLockdown() then
			LocMessages:SetSetup(false)
			LocMessages:InitSetting()
		else
			C_Timer.After(
				0.1,
				function()
					LocMessages:SetupLOC()
				end
			)
		end
	end
end

local function LOCGetSchoolType(sid)
	for i = 1, 6 do
		local _, _, _, dispelType, _, _, _, _, _, spellId = UnitAura("player", i, "HARMFUL")
		if spellId and spellId == sid then return dispelType end
	end

	return nil
end

local LOCTypes = {"CHARM", "CONFUSE", "DISARM", "FEAR", "FEAR_MECHANIC", "NONE", "PACIFY", "PACIFYSILENCE", "POSSESS", "ROOT", "SCHOOL_INTERRUPT", "SILENCE", "STUN", "STUN_MECHANIC"}
local locsEng = {
	["CHARM"] = "Charmed",
	["CONFUSE"] = "Confused",
	["DISARM"] = "Disarmed",
	["FEAR"] = "Feared",
	["FEAR_MECHANIC"] = "Feared",
	["NONE"] = "None",
	["PACIFY"] = "Pacified",
	["PACIFYSILENCE"] = "Disabled",
	["POSSESS"] = "Possessed",
	["ROOT"] = "Rooted",
	["SCHOOL_INTERRUPT"] = "Interrupted",
	["SILENCE"] = "Silenced",
	["STUN"] = "Stunned",
	["STUN_MECHANIC"] = "Stunned",
}

local locEng = "%s (For %i seconds)"
local locs = {}
local f_loc = CreateFrame("FRAME")
f_loc.past = {}
f_loc:SetScript(
	"OnEvent",
	function(self, event, unitToken, eventIndex, ...)
		local loctype, text, duration, spellID, dispelType
		-- fix for old one
		if eventIndex == nil then
			eventIndex = unitToken
		end

		if eventIndex == nil then return end
		if C_LossOfControl.GetEventInfo ~= nil then
			loctype, spellID, text, _, _, _, duration, _, _, _ = C_LossOfControl.GetEventInfo(eventIndex) --C_LossOfControl.GetEventInfo(id)
		elseif C_LossOfControl.GetActiveLossOfControlData ~= nil then
			local tab = C_LossOfControl.GetActiveLossOfControlData(eventIndex)
			loctype = tab["locType"]
			text = tab["displayText"]
			duration = tab["duration"]
			spellID = tab["spellID"]
		else
			print("[LOC] FAILED - API not found")
		end

		dispelType = LOCGetSchoolType(spellID)
		if LocMessages:GetConfig("showinenglishonly", false) and text ~= nil and loctype ~= nil then
			if locsEng[loctype] then
				if dispelType ~= nil then
					dispelType = locsEng[loctype]
				end

				text = locsEng[loctype]
			else
				LocMessages:MSG(format("MISSING TRANSLATION FOR %s", loctype))
			end
		end

		if loctype ~= nil and duration ~= nil then
			if dispelType ~= nil and string.lower(text) ~= string.lower(dispelType) then
				dispelType = string.upper(dispelType)
				if LocMessages:GetConfig("showdispelltype", true) then
					text = text .. " [" .. dispelType .. "]"
				end
			end

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
						local loctypePrefix = LocMessages:GetConfig("prefix_" .. loctype, "")
						if loctypePrefix ~= "" then
							text = loctypePrefix .. " " .. text
						end

						local loctypeSuffix = LocMessages:GetConfig("suffix_" .. loctype, "")
						if loctypeSuffix ~= "" then
							text = text .. " " .. loctypeSuffix
						end

						if LocMessages:GetConfig("showinenglishonly", false) then
							LocMessages:ToCurrentChat(string.format(locEng, text, LocMessages:MathR(duration, 1)))
						else
							LocMessages:ToCurrentChat(string.format(L["loctext"], text, LocMessages:MathR(duration, 1)))
						end
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
	end
)

f_loc:RegisterEvent("LOSS_OF_CONTROL_ADDED")
-- CMDS --
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