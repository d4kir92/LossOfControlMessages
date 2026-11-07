-- By D4KiR
local _, LocMessages = ...
local function IsChatMessagingLocked()
	return C_ChatInfo and C_ChatInfo.InChatMessagingLockdown and C_ChatInfo.InChatMessagingLockdown()
end

function LocMessages:AllowedTo()
	local _channel = LocMessages:GetConfig("channelchat", "AUTO")
	if (GetNumGroupMembers() > 0 or GetNumSubgroupMembers() > 0) and LocMessages:GetConfig("printnothing", false) == false then return true end

	return false
end

function LocMessages:DebugValue(value)
	if LocMessages:IsSecret(value) then return "<secret>" end

	return tostring(value)
end

function LocMessages:Debug(msg)
	if LOCTABPC and LOCTABPC["debug"] then
		print("|cff00ccff[LOC Debug]|r " .. msg)
	end
end

SLASH_LOCMESSAGESDEBUG1 = "/locdebug"
SlashCmdList["LOCMESSAGESDEBUG"] = function()
	LOCTABPC = LOCTABPC or {}
	LOCTABPC["debug"] = not LOCTABPC["debug"]
	print("|cff00ccff[LOC Debug]|r " .. (LOCTABPC["debug"] and "ON" or "OFF"))
end

function LocMessages:ToCurrentChat(msg)
	if IsChatMessagingLocked() then
		LocMessages:Debug("Not sent: chat messaging lockdown active (Blizzard restriction)")

		return
	end

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
		if IsInRaid() then
			_channel = "RAID"
		elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
			_channel = "INSTANCE_CHAT"
		elseif IsInGroup() then
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
			LocMessages:Debug("Not sent: messages turned off")
		elseif inArena and LocMessages:GetConfig("showinarenas", true) == false then
			LocMessages:Debug("Not sent: disabled in arenas")
		elseif inBg and LocMessages:GetConfig("showinbgs", false) == false then
			LocMessages:Debug("Not sent: disabled in battlegrounds")
		elseif inRaid and LocMessages:GetConfig("showinraids", false) == false then
			LocMessages:Debug("Not sent: disabled in raids")
		elseif not inInstance and LocMessages:GetConfig("showoutsideofinstance", false) == false then
			LocMessages:Debug("Not sent: disabled outside of instances")
		else
			if canUseRole then
				if role == "HEALER" and not LocMessages:GetConfig("showashealer", true) then
					LocMessages:Debug("Not sent: disabled for role HEALER")

					return false
				elseif role == "DAMAGER" and not LocMessages:GetConfig("showasdamager", false) then
					LocMessages:Debug("Not sent: disabled for role DAMAGER")

					return false
				elseif role == "TANK" and not LocMessages:GetConfig("showastank", false) then
					LocMessages:Debug("Not sent: disabled for role TANK")

					return false
				end
			end

			if mes ~= nil then
				LocMessages:Debug("Sending to " .. tostring(_channel) .. ": " .. LocMessages:DebugValue(mes))
				if C_ChatInfo and C_ChatInfo.SendChatMessage then
					C_ChatInfo.SendChatMessage(mes, _channel)
				else
					SendChatMessage(mes, _channel)
				end
			end
		end
	else
		LocMessages:Debug("Not sent: not in a group")
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

local function LOCGetAuraDispel(index)
	local _, _, _, dispelType, _, _, _, _, _, spellId = LocMessages:UnitAura("player", index, "HARMFUL")

	return dispelType, spellId
end

local function LOCGetSchoolType(sid)
	for i = 1, 6 do
		local ok, dispelType, spellId = pcall(LOCGetAuraDispel, i)
		if not ok then return nil end
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
		if C_LossOfControl then
			if C_LossOfControl.GetEventInfo ~= nil then
				loctype, spellID, text, _, _, _, duration, _, _, _ = C_LossOfControl.GetEventInfo(eventIndex) --C_LossOfControl.GetEventInfo(id)
			elseif C_LossOfControl.GetActiveLossOfControlData ~= nil or nil then
				if unitToken ~= "player" then return end
				local tab = C_LossOfControl.GetActiveLossOfControlData(eventIndex)
				if tab ~= nil then
					loctype = tab["locType"]
					text = tab["displayText"]
					duration = tab["duration"]
					spellID = tab["spellID"]
				else
					print("[LOC] C_LossOfControl.GetActiveLossOfControlData is broken?", tab)
				end
			else
				print("[LOC] FAILED - API BROKEN? NO FUNCTION FOUND")
			end
		else
			print("[LOC] C_LossOfControl is not valid.")
		end

		LocMessages:Debug(format("%s type=%s text=%s duration=%s spellID=%s", event, LocMessages:DebugValue(loctype), LocMessages:DebugValue(text), LocMessages:DebugValue(duration), LocMessages:DebugValue(spellID)))
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
						LocMessages:Debug("Skipped: same effect still active")

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
							LocMessages:ToCurrentChat(string.format(LocMessages:Trans("LID_loctext"), text, LocMessages:MathR(duration, 1)))
						end
					else
						LocMessages:Debug("Not sent: chat output disabled or not in a group")
					end

					if LocMessages:GetConfig("showlocemote", true) and LocMessages:AllowedTo() and not IsChatMessagingLocked() then
						if C_ChatInfo and C_ChatInfo.PerformEmote then
							C_ChatInfo.PerformEmote("helpme")
						else
							DoEmote("helpme")
						end
					end
				else
					LocMessages:Debug(format("Skipped: type %s disabled, turned off or repeated", LocMessages:DebugValue(loctype)))
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

if f_loc.RegisterUnitEvent then
	f_loc:RegisterUnitEvent("LOSS_OF_CONTROL_ADDED", "player")
else
	f_loc:RegisterEvent("LOSS_OF_CONTROL_ADDED")
end

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
