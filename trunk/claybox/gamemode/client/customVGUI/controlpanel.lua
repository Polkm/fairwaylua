//
//  ___  ___   _   _   _    __   _   ___ ___ __ __
// |_ _|| __| / \ | \_/ |  / _| / \ | o \ o \\ V /
//  | | | _| | o || \_/ | ( |_n| o ||   /   / \ / 
//  |_| |___||_n_||_| |_|  \__/|_n_||_|\\_|\\ |_|  2009
//										 
//
//	Note: This is only really here as a layer between the spawnmenu
//			and the DForm Derma control. You shouldn't ever really be
//			calling AddControl. If you're writing new code - don't call
//			AddControl!! Add stuff directly using the DForm member functions!
//
local PANEL = {}

AccessorFunc(PANEL, "m_bInitialized", "Initialized")

function PANEL:Init()
	self:SetInitialized(false)
	self:SetPadding(5)
	self:SetSpacing(5)
end

function PANEL:ClearControls()
	self:Clear()
end

function PANEL:GetEmbeddedPanel()
	return self
end

function PANEL:FillViaTable(tblInfo)
	self:SetInitialized(true)
	self:SetName(tblInfo.Text)
	--If we have a function to create the control panel, use that
	if tblInfo.ControlPanelBuildFunction then
		local b, e = pcall(tblInfo.ControlPanelBuildFunction, self)
		if !b then Error("ControlPanelBuildFunction Error: ", e) end
	--If not, use the txt file
	elseif tblInfo.Controls then 
		self:LoadControlsFromTextFile(tblInfo.Controls)
	end
	self:InvalidateLayout()
end

--[[-------------------------------------------------------
	Please don't use this. Ever. 
	This is just here for backwards compatibility. 
	Don't rely on it staying around. 
---------------------------------------------------------]]
function PANEL:LoadControlsFromTextFile(strName)
	local strFile = file.Read("../settings/controls/" .. strName .. ".txt")
	if !strFile then return end
	local tblKeyValues = KeyValuesToTablePreserveOrder(strFile)
	if !tblKeyValues then return end
	for _, tblData in pairs(tblKeyValues) do
		if type(tblData.Value) == "table" then
			local tblKeyValues = table.CollapseKeyValue(tblData.Value)
			local pnlControl = self:AddControl(tblData.Key, tblKeyValues)
		end
	end
end

function PANEL:AddPanel(pnl)
	self:AddItem(pnl, nil)
	self:InvalidateLayout()
end

function PANEL:AddControl(strControl, tblData)
	strControl = string.lower(strControl)
	tblData = table.LowerKeyNames(tblData)

	--Retired
	if strControl == "header" then return end
	if strControl == "textbox" then
		local pnlControl = self:TextEntry(tblData.label or "Untitled", tblData.command)
		if tblData.description then pnlControl:SetTooltip(tblData.description) end
		return pnlControl
	end
	if strControl == "label"  then
		local pnlControl = self:Help(tblData.text)
		if tblData.description then pnlControl:SetTooltip(tblData.description) end
		return pnlControl
	end
	if strControl == "checkbox" or strControl == "toggle" then
		local pnlControl = self:CheckBox(tblData.label or "Untitled", tblData.command)
		if tblData.description then pnlControl:SetTooltip(tblData.description) end
		return pnlControl
	end
	if strControl == "slider" then
		local intDecimals = 0
		if tblData.type and string.lower(tblData.type) == "float" then intDecimals = 2 end
		local pnlControl = vgui.Create("FSlider", self)
		pnlControl:SetText(tblData.label or "Untitled")
		pnlControl:SetMinMax(tblData.min or 0, tblData.max or 100)
		if intDecimals != nil then pnlControl:SetDecimals(intDecimals) end
		pnlControl:SetConVar(tblData.command)
		pnlControl:SizeToContents()
		if tblData.description then pnlControl:SetTooltip(tblData.description) end
		self:AddItem(pnlControl, nil)
		return pnlControl
	end
	if strControl == "propselect" then
		local pnlControl = vgui.Create("PropSelect", self)
		pnlControl:ControlValues(tblData) --Yack.
		self:AddPanel(pnlControl)
		if tblData.description then pnlControl:SetTooltip(tblData.description) end
		return pnlControl
	end
	if strControl == "matselect" then
		local pnlControl = vgui.Create("MatSelect", self)
		pnlControl:ControlValues(tblData) --Yack.
		self:AddPanel(pnlControl)
		if tblData.description then pnlControl:SetTooltip(tblData.description) end
		return pnlControl
	end
	if strControl == "ropematerial" then
		local pnlControl = vgui.Create("RopeMaterial", self)
		pnlControl:SetConVar(tblData.convar)
		self:AddPanel(pnlControl)
		if tblData.description then pnlControl:SetTooltip(tblData.description) end
		return pnlControl
	end
	if strControl == "button" then
		--If the control has args then use the new way, if not use the old way
		if tblData.args then
			local pnlControl = self:Button(tblData.label or tblData.text or "No Label", tblData.command, unpack(tblData.args))
			if tblData.description then pnlControl:SetTooltip(tblData.description) end
			return pnlControl
		else
			--Note: Buttons created this way use the old method of calling commands,
			--via LocalPlayer:ConCommand. This way is flawed. This way is legacy.
			--The new way is to make buttons via controlpanel:Button( name, command, commandarg1, commandarg2 ) etc
			local pnlControl = vgui.Create("DButton", self)
			if tblData.command then
				function pnlControl:DoClick() LocalPlayer():ConCommand(tblData.command) end
			end
			pnlControl:SetText(tblData.label or tblData.text or "No Label")
			self:AddPanel(pnlControl)
			if tblData.description then pnlControl:SetTooltip(tblData.description) end
			return pnlControl
		end
	end
	if strControl == "numpad" then
		local pnlControl = vgui.Create("CtrlNumPad", self)
		pnlControl:SetConVar1(tblData.command)
		pnlControl:SetConVar2(tblData.command2)
		pnlControl:SetLabel1(tblData.label)
		pnlControl:SetLabel2(tblData.label2)
		self:AddPanel(pnlControl)
		if tblData.description then pnlControl:SetTooltip(tblData.description) end
		return pnlControl
	end
	if strControl == "color" then
		local pnlControl = vgui.Create("CtrlColor", self)
		pnlControl:SetConVarR(tblData.red)
		pnlControl:SetConVarG(tblData.green)
		pnlControl:SetConVarB(tblData.blue)
		pnlControl:SetConVarA(tblData.alpha)
		self:AddPanel(pnlControl)
		if tblData.description then pnlControl:SetTooltip(tblData.description) end
		return pnlControl
	end
	if strControl == "combobox" then
		if tostring(tblData.menubutton) == "1" then
			local pnlControl = vgui.Create("ControlPresets", self)
			pnlControl:SetPreset(tblData.folder)
			if tblData.options then
				for k, v in pairs(tblData.options) do
					if string.lower(k) != "id" then
						pnlControl:AddOption(k, v)
					end
				end
			end
			if tblData.cvars then
				for k, v in pairs(tblData.cvars) do
					pnlControl:AddConVar(v)
				end
			end
			self:AddPanel(pnlControl)
			if tblData.description then pnlControl:SetTooltip(tblData.description) end
			return pnlControl
		end
		strControl = "listbox"
	end
	if strControl == "listbox" then
		if tblData.height then
			local pnlControl = vgui.Create("DListView")
			pnlControl:SetMultiSelect(false)
			self:AddPanel(pnlControl)
			pnlControl:AddColumn(tblData.label or "unknown")
			if tblData.options then
				for k, v in pairs(tblData.options) do
					v.id = nil
					local line = pnlControl:AddLine(k)
					line.data = v
					--This is kind of broken because it only checks one convar
					--instead of all of them. But this is legacy. It will do for now.
					for k, v in pairs(line.data) do
						if GetConVarString(k) == v then
							line:SetSelected(true)
						end
					end
				end
			end
			pnlControl:SetTall(tblData.height)
			pnlControl:SortByColumn(1, false)
			function pnlControl:OnRowSelected(LineID, Line)
				for k, v in pairs(Line.data) do
					RunConsoleCommand(k, v)
				end
			end
		else
			local pnlControl = vgui.Create("CtrlListBox", self)
			if tblData.options then
				for k, v in pairs(tblData.options) do
					v.id = nil --Some txt file configs still have an `ID'. But these are redundant now.
					pnlControl:AddOption(k, v)
				end
			end
			self:AddPanel(pnlControl)
		end
		if pnlControl and tblData.description then pnlControl:SetTooltip(tblData.description) end
		return pnlControl
	end 
	if strControl == "materialgallery" then
		local pnlControl = vgui.Create("MatSelect", self)
		--pnlControl:ControlValues(tblData) --Yack.
		pnlControl:SetItemWidth(tblData.width or 32)
		pnlControl:SetItemHeight(tblData.height or 32)
		pnlControl:SetNumRows(tblData.rows or 4)
		pnlControl:SetConVar(tblData.convar or nil)
		for strName, tblInfo in pairs(tblData.options) do
			local strMaterial = tblInfo.material
			local value = tblInfo.value
			tblInfo.material = nil
			tblInfo.value = nil
			pnlControl:AddMaterialEx(strName, strMaterial, value, tblInfo)
		end
		self:AddPanel(pnlControl)
		if pnlControl and tblData.description then pnlControl:SetTooltip(tblData.description) end
		return pnlControl
	end
	local pnlControl = vgui.Create(strControl, self)
	if pnlControl then
		if pnlControl.ControlValues then
			pnlControl:ControlValues(tblData) 
		end
		self:AddPanel(pnlControl)
		if tblData.description then pnlControl:SetTooltip(tblData.description) end
		return pnlControl
	end
	
	MsgN("UNHANDLED CONTROL: ", pnlControl)
	PrintTable(tblData)
	MsgN("\n\n")
end

function PANEL:MatSelect(strConVar, tblOptions, bAutoStretch, iWidth, iHeight)
	local MatSelect = vgui.Create("MatSelect", self)
		MatSelect:SetConVar(strConVar)
		if bAutoStretch != nil then MatSelect:SetAutoHeight(bAutoStretch) end
		if iWidth != nil then MatSelect:SetItemWidth(iWidth) end
		if iHeight != nil then MatSelect:SetItemHeight(iHeight) end
		if tblOptions != nil then
			for k, v in pairs(tblOptions) do
				MatSelect:AddMaterial(v, v)
			end
		end
	self:AddPanel(MatSelect)
	return MatSelect
end

--These are retired. If you're using them - you shouldn't be.
function PANEL:AddDefaultControls()
end
function PANEL:AddHeader()
end
function PANEL:GetPanel()
end
vgui.Register("ControlPanel", PANEL, "DForm")