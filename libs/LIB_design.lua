-- LIB Design
local _, LocMessages = ...
local CBS = {}
function LocMessages:CreateText(tab)
	tab.textsize = tab.textsize or 12
	local text = tab.frame:CreateFontString(nil, "ARTWORK")
	text:SetFont(STANDARD_TEXT_FONT, tab.textsize, "OUTLINE")
	text:SetPoint("TOPLEFT", tab.parent, "TOPLEFT", tab.x, tab.y)
	text:SetText(tab.text)

	return text
end

function LocMessages:CreateTextBox(tab)
	tab = tab or {}
	tab.parent = tab.parent or UIParent
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	local f = CreateFrame("Frame", nil, tab.parent)
	f:SetPoint("TOPLEFT", tab.x, tab.y)
	f:SetSize(300, 25)
	tab.frame = f
	tab.parent = f
	tab.x = 4
	tab.y = -4
	tab.text = tab.text
	f.header = LocMessages:CreateText(tab)
	f.Text = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
	f.Text:SetPoint("TOPLEFT", 200, 0)
	f.Text:SetPoint("BOTTOMRIGHT", 0, 0)
	f.Text:SetMultiLine(false)
	f.Text:SetMaxLetters(20)
	f.Text:SetFontObject(GameFontNormal)
	f.Text:SetAutoFocus(false)
	tab.value = tab.value or ""
	tab.value = string.gsub(tab.value, "\n", "")
	f.Text:SetText(tab.value or "")
	f.Text:SetCursorPosition(0)
	f.Text:SetScript(
		"OnTextChanged",
		function(sel)
			local text = sel:GetText()
			sel:SetText(text)
			LOCTABPC[tab.dbvalue] = text
			LocMessages:SetupLOC()
		end
	)

	return f
end

function LocMessages:CreateCheckBox(tab)
	tab = tab or {}
	tab.parent = tab.parent or UIParent
	tab.tooltip = tab.tooltip or ""
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	local CB = CreateFrame("CheckButton", nil, tab.parent, "ChatConfigCheckButtonTemplate")
	CB:SetPoint("TOPLEFT", tab.x, tab.y)
	CB.tooltip = tab.tooltip
	CB:SetChecked(tab.checked)
	CB:SetScript(
		"OnClick",
		function(sel)
			local status = CB:GetChecked()
			sel:SetChecked(status)
			LOCTABPC[tab.dbvalue] = status
			LocMessages:SetupLOC()
		end
	)

	local entry = {}
	entry.ele = CB
	entry.dbvalue = tab.dbvalue
	table.insert(CBS, entry)
	tab.frame = CB
	tab.x = tab.x + 26
	tab.y = tab.y - 6
	CB.text = LocMessages:CreateText(tab)

	return CB
end

function LocMessages:CreateComboBox(tab)
	tab = tab or {}
	tab.parent = tab.parent or UIParent
	tab.tooltip = tab.tooltip or ""
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	local t = {}
	for i, v in pairs(tab.tab) do
		if v.Code then
			tinsert(t, v.Code)
		else
			tinsert(t, v)
		end
	end

	local rows = {
		["name"] = tab.name,
		["parent"] = tab.parent,
		["title"] = tab.text,
		["items"] = t,
		["defaultVal"] = tab.value,
		["changeFunc"] = function(dropdown_frame, dropdown_val)
			--dropdown_val = tonumber( dropdown_val )
			if LOCTABPC and tab.dbvalue and dropdown_val then
				LOCTABPC[tab.dbvalue] = dropdown_val
			end
		end
	}

	local DD = LocMessages:CreateDropdown(rows)
	DD:SetPoint("TOPLEFT", tab.parent, "TOPLEFT", tab.x, tab.y)

	return DD
end

function LocMessages:CreateSlider(tab)
	tab = tab or {}
	tab.parent = tab.parent or UIParent
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.value = tab.value or 0
	local SL = CreateFrame("Slider", tab.name, tab.parent, "UISliderTemplate")
	SL:SetPoint("TOPLEFT", tab.x, tab.y)
	if SL.Low == nil then
		SL.Low = SL:CreateFontString(nil, nil, "GameFontNormal")
		SL.Low:SetPoint("BOTTOMLEFT", SL, "BOTTOMLEFT", 0, -12)
		SL.Low:SetFont(STANDARD_TEXT_FONT, 10, "THINOUTLINE")
		SL.Low:SetTextColor(1, 1, 1)
	end

	if SL.High == nil then
		SL.High = SL:CreateFontString(nil, nil, "GameFontNormal")
		SL.High:SetPoint("BOTTOMRIGHT", SL, "BOTTOMRIGHT", 0, -12)
		SL.High:SetFont(STANDARD_TEXT_FONT, 10, "THINOUTLINE")
		SL.High:SetTextColor(1, 1, 1)
	end

	if SL.Text == nil then
		SL.Text = SL:CreateFontString(nil, nil, "GameFontNormal")
		SL.Text:SetPoint("TOP", SL, "TOP", 0, 16)
		SL.Text:SetFont(STANDARD_TEXT_FONT, 12, "THINOUTLINE")
		SL.Text:SetTextColor(1, 1, 1)
	end

	SL.Low:SetText(tab.min)
	SL.High:SetText(tab.max)
	SL:SetMinMaxValues(tab.min, tab.max)
	SL:SetValue(tab.value)
	SL:SetSize(500, 16)
	SL:SetObeyStepOnDrag(1)
	tab.steps = tab.steps or 1
	SL:SetValueStep(tab.steps)
	SL.decimals = tab.decimals or 0
	SL:SetScript(
		"OnValueChanged",
		function(sel, val)
			val = LocMessages:MathR(val, sel.decimals)
			val = val - val % tab.steps
			LOCTABPC[tab.dbvalue] = val
			local trans = {}
			trans["VALUE"] = val
			SL.Text:SetText(tab.text)
			if tab.func ~= nil then
				tab:func()
			end
		end
	)

	hooksecurefunc(
		"UpdateLanguage",
		function()
			local trans = {}
			trans["VALUE"] = SL:GetValue()
			SL.Text:SetText(tab.text)
		end
	)

	return EB
end

function LocMessages:CTexture(frame, tab)
	tab.layer = tab.layer or "BACKGROUND"
	local texture = frame:CreateTexture(nil, tab.layer)
	tab.texture = tab.texture or ""
	if tab.texture ~= "" then
		tab.color.r = tab.color.r or 1
		tab.color.g = tab.color.g or 0
		tab.color.b = tab.color.b or 0
		tab.color.a = tab.color.a or 1
		texture:SetTexture(tab.texture)
		texture:SetVertexColor(tab.color.r, tab.color.g, tab.color.b, tab.color.a)
	elseif tab.color ~= nil then
		tab.color.r = tab.color.r or 1
		tab.color.g = tab.color.g or 0
		tab.color.b = tab.color.b or 0
		tab.color.a = tab.color.a or 1
		texture:SetColorTexture(tab.color.r, tab.color.g, tab.color.b, tab.color.a)
	else
		texture:SetTexture(tab.texture)
	end

	if tab.autoresize then
		texture:SetAllPoints(frame)
	else
		tab.w = tab.w or frame:GetWidth()
		tab.h = tab.h or frame:GetHeight()
		texture:SetSize(tab.w, tab.h)
		tab.x = tab.x or 0
		tab.y = tab.y or 0
		texture:SetPoint(tab.align or "TOPLEFT", frame, tab.x, tab.y)
	end

	return texture
end

function LocMessages:CreateF(tab)
	tab.w = tab.w or 2
	tab.h = tab.h or 2
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.align = tab.align or "CENTER"
	tab.text = tab.text or "Unnamed"
	tab.textalign = tab.textalign or "CENTER"
	tab.textsize = tab.textsize or tonumber(string.format("%.0f", tab.h * 0.69))
	tab.parent = tab.parent or UIParent
	local frame = CreateFrame("FRAME", nil, tab.parent)
	frame:SetWidth(tab.w)
	frame:SetHeight(tab.h)
	frame:ClearAllPoints()
	frame:SetPoint(tab.align, tab.parent, tab.align, tab.x, tab.y)
	tab.layer = tab.layer or "BACKGROUND"
	frame.texture = LocMessages:CTexture(frame, tab)
	tab.textlayer = tab.textlayer or "ARTWORK"
	frame.text = frame:CreateFontString(nil, tab.textlayer)
	frame.text:SetFont(STANDARD_TEXT_FONT, tab.textsize, "OUTLINE")
	frame.text:SetPoint(tab.textalign, 0, 0)
	frame.text:SetText(tab.text)
	function frame:SetText(text)
		frame.text:SetText(text)
	end

	return frame
end

function LocMessages:UpdateOptions()
	-- CHECKBOXES
	for i, v in pairs(CBS) do
		if LocMessages:GetConfig(v.dbvalue) ~= nil then
			v.ele:SetChecked(LocMessages:GetConfig(v.dbvalue))
		end
	end
end
