GM.ItemEditor = nil
GM.ItemEditorSettings = {}
GM.ItemEditorSettings.CurrentEditingSlot = nil
GM.ItemEditorSettings.CurrentEditingItemModel = 1
GM.ItemEditorSettings.CurrentEditingVector = Vector(0, 0, 0)
GM.ItemEditorSettings.CurrentEditingAngle = Angle(0, 0, 0)
GM.ItemEditorSettings.CurrentEditingMat = nil
GM.ItemEditorSettings.CurrentCamRotation = nil
GM.ItemEditorSettings.CurrentCamDistance = nil
local intGlobalPadding = 5
local intToolBarIconSize = 16
local tblUsableMats = {}
tblUsableMats[1] = "Models/props_c17/FurnitureMetal002a.vtf"
tblUsableMats[2] = "Models/Gibs/metalgibs/metal_gibs.vtf"
tblUsableMats[3] = "Models/props_building_details/courtyard_template001c_bars.vtf"
tblUsableMats[4] = "Models/props_building_details/courtyard_template001c_bars_dark.vtf"
tblUsableMats[5] = "Models/props_c17/Metalladder001.vtf"
tblUsableMats[6] = "Models/props_c17/Metalladder002.vtf"
tblUsableMats[7] = "Models/props_c17/Metalladder003.vtf"
tblUsableMats[8] = "Models/props_junk/rock_junk001a.vtf"
tblUsableMats[9] = "Models/props_lab/door_klab01.vtf"

PANEL = {}
function PANEL:Init()
	self.Frame = CreateGenericFrame("Item Editor", true, true)
	self.Frame.btnClose.DoClick = function(pnlPanel)
		GAMEMODE.ItemEditor.Frame:Close()
		GAMEMODE.ItemEditor = nil
		GAMEMODE.ItemEditorSettings.CurrentCamRotation = nil
		GAMEMODE.ItemEditorSettings.CurrentCamDistance = nil
	end
	
	self.ToolBar = CreateGenericList(self.Frame, intGlobalPadding, true, false)
	self:AddToolButton("gui/silkicons/folder_go", "Load Item", function()
		local function fncGivePlayerItem(strItem)
			RunConsoleCommand("udk_edit_items_giveitem", strItem)
		end
		local mnuLoadItems = DermaMenu()
		local smnWeapons = mnuLoadItems:AddSubMenu("Weapons")
			local smnWeaponsRanged = smnWeapons:AddSubMenu("Ranged")
			local smnWeaponsMelee = smnWeapons:AddSubMenu("Melee")
		local smnArmor = mnuLoadItems:AddSubMenu("Armor")
			local smnArmorHelm = smnArmor:AddSubMenu("Helm")
			local smnArmorChest = smnArmor:AddSubMenu("Chest")
			local smnArmorShield = smnArmor:AddSubMenu("Shield")
			local smnArmorShoulder = smnArmor:AddSubMenu("Shoulder")
		for strItem, tblItemTable in pairs(GAMEMODE.DataBase.Items) do
			if string.find(strItem, "weapon_") then
				if string.find(strItem, "_ranged_") then
					smnWeaponsRanged:AddOption(strItem, function() fncGivePlayerItem(strItem) end)
				elseif string.find(strItem, "_melee_") then
					smnWeaponsMelee:AddOption(strItem, function() fncGivePlayerItem(strItem) end)
				else
					smnWeapons:AddOption(strItem, function() fncGivePlayerItem(strItem) end)
				end
			end
			if string.find(strItem, "armor_") then
				if string.find(strItem, "_helm_") then
					smnArmorHelm:AddOption(strItem, function() fncGivePlayerItem(strItem) end)
				elseif string.find(strItem, "_chest_") then
					smnArmorChest:AddOption(strItem, function() fncGivePlayerItem(strItem) end)
				elseif string.find(strItem, "_sheild_") or string.find(strItem, "_shield_") then --Fuck my spelling ><
					smnArmorShield:AddOption(strItem, function() fncGivePlayerItem(strItem) end)
				elseif string.find(strItem, "_shoulder_") then
					smnArmorShoulder:AddOption(strItem, function() fncGivePlayerItem(strItem) end)
				else
					smnArmor:AddOption(strItem, function() fncGivePlayerItem(strItem) end)
				end
			end
		end
		mnuLoadItems:Open()
	end)
	self:AddToolButton("gui/silkicons/check_off", "Clear Paperdoll", function()
		RunConsoleCommand("udk_edit_items_clearpaperdoll")
	end)
	self:AddToolButton("gui/silkicons/page", "Copy Dementions to clip board", function() self:PrintNewDementions() end)
	self.SlotSwitch, self.ObjectSwitch = self:AddSlotControls()
	
	self.ControlsList = CreateGenericList(self.Frame, intGlobalPadding, false, true)
	self.VectorControls = self:AddControl(self:AddVectorControls())
	self.AngleControls = self:AddControl(self:AddAngleControls())
	self.MatControls = self:AddControl(self:AddMatControls())
	self.CammeraControls = self:AddControl(self:AddCammeraControls())
	
	
	self.Frame:MakePopup()
	self:PerformLayout()
end

function PANEL:PerformLayout()
	self.Frame:SetPos(self:GetPos())
	self.Frame:SetSize(self:GetSize())
	self.ToolBar:SetPos(intGlobalPadding, 25)
	self.ToolBar:SetSize(self:GetWide() - (intGlobalPadding * 2), intToolBarIconSize + (intGlobalPadding * 2))
	self.ControlsList:SetPos(intGlobalPadding, 25 + self.ToolBar:GetTall() + intGlobalPadding)
	self.ControlsList:SetSize(self:GetWide() - (intGlobalPadding * 2), self:GetTall() - (25 + self.ToolBar:GetTall() + (intGlobalPadding * 2)))
	for _, pnlIcon in pairs(self.MatControls.Icons or {}) do
		pnlIcon:SetSize(38, 38)
	end
end

function PANEL:UpdateSellectors(strSlot)
	self.SlotSwitch:Clear()
	for strInSlot, _ in pairs(LocalPlayer().Data.Paperdoll or {}) do
		self.SlotSwitch:AddChoice(strInSlot)
	end
	timer.Simple(0.1, function() self.SlotSwitch:ChooseOption(strSlot) end)
end

function PANEL:AddToolButton(strImage, strToolTip, fncFunction)
	local ibnNewToolButton = CreateGenericImageButton(nil, strImage, strToolTip, fncFunction)
	ibnNewToolButton:SetSize(intToolBarIconSize, intToolBarIconSize)
	self.ToolBar:AddItem(ibnNewToolButton)
end

function PANEL:AddControl(pnlControl)
	self.ControlsList:AddItem(pnlControl)
	return pnlControl
end

function PANEL:AddSlotControls()
	local mlcSlotSellector = CreateGenericMultiChoice()
	mlcSlotSellector:SetSize(120, intToolBarIconSize)
	self.ToolBar:AddItem(mlcSlotSellector)
	
	local mlcObjectSellector = CreateGenericMultiChoice()
	mlcObjectSellector:SetSize(50, intToolBarIconSize)
	self.ToolBar:AddItem(mlcObjectSellector)
	
	mlcSlotSellector.OnSelect = function(index, value, data)
		if !LocalPlayer().Data.Paperdoll[data] then return false end
		GAMEMODE.ItemEditorSettings.CurrentEditingSlot = data
		mlcObjectSellector:Clear()
		mlcObjectSellector:AddChoice(1)
		mlcObjectSellector:ChooseOptionID(1)
		if GAMEMODE.PapperDollEnts[LocalPlayer():EntIndex()] && GAMEMODE.PapperDollEnts[LocalPlayer():EntIndex()][data] then
			for k, v in pairs(GAMEMODE.PapperDollEnts[LocalPlayer():EntIndex()][data].Children or {}) do
				mlcObjectSellector:AddChoice(k + 1)
			end
		end
	end
	mlcObjectSellector.OnSelect = function(index, value, data)
		data = tonumber(data)
		GAMEMODE.ItemEditorSettings.CurrentEditingItemModel = data
		local strItem = LocalPlayer().Data.Paperdoll[GAMEMODE.ItemEditorSettings.CurrentEditingSlot]
		local tblItemTable = GAMEMODE.DataBase.Items[strItem]
		if tblItemTable && tblItemTable.Model[data] then
			GAMEMODE.ItemEditorSettings.CurrentEditingVector = tblItemTable.Model[data].Position
			GAMEMODE.ItemEditorSettings.CurrentEditingAngle = tblItemTable.Model[data].Angle
			GAMEMODE.ItemEditorSettings.CurrentEditingMat = tblItemTable.Model[data].Material
			self.VectorControls.UpdateNewValues(tblItemTable.Model[data].Position)
			self.AngleControls.UpdateNewValues(tblItemTable.Model[data].Angle)
		end
	end
	return mlcSlotSellector, mlcObjectSellector
end

function PANEL:AddVectorControls()
	local cpcNewCollapseCat = CreateGenericCollapse(nil, "Offset Controls", intGlobalPadding, false)
	local nmsNewXSlider = CreateGenericSlider(nil, "X Axis", -40, 40, 2)
	nmsNewXSlider.ValueChanged = function(self, value) GAMEMODE.ItemEditorSettings.CurrentEditingVector.x = value end
	cpcNewCollapseCat.List:AddItem(nmsNewXSlider)
	local nmsNewYSlider = CreateGenericSlider(nil, "Y Axis", -40, 40, 2)
	nmsNewYSlider.ValueChanged = function(self, value) GAMEMODE.ItemEditorSettings.CurrentEditingVector.y = value end
	cpcNewCollapseCat.List:AddItem(nmsNewYSlider)
	local nmsNewZSlider = CreateGenericSlider(nil, "Z Axis", -40, 40, 2)
	nmsNewZSlider.ValueChanged = function(self, value) GAMEMODE.ItemEditorSettings.CurrentEditingVector.z = value end
	cpcNewCollapseCat.List:AddItem(nmsNewZSlider)
	cpcNewCollapseCat.UpdateNewValues = function(vecNewOffset)
		nmsNewXSlider.UpdateSlider(vecNewOffset.x)
		nmsNewYSlider.UpdateSlider(vecNewOffset.y)
		nmsNewZSlider.UpdateSlider(vecNewOffset.z)
	end
	return cpcNewCollapseCat
end

function PANEL:AddAngleControls()
	local cpcNewCollapseCat = CreateGenericCollapse(nil, "Angle Controls", intGlobalPadding, false)
	local nmsNewXSlider = CreateGenericSlider(nil, "Pitch", -180, 180, 2)
	nmsNewXSlider.ValueChanged = function(self, value) GAMEMODE.ItemEditorSettings.CurrentEditingAngle.p = value end
	cpcNewCollapseCat.List:AddItem(nmsNewXSlider)
	local nmsNewYSlider = CreateGenericSlider(nil, "Yaw", -180, 180, 2)
	nmsNewYSlider.ValueChanged = function(self, value) GAMEMODE.ItemEditorSettings.CurrentEditingAngle.y = value end
	cpcNewCollapseCat.List:AddItem(nmsNewYSlider)
	local nmsNewZSlider = CreateGenericSlider(nil, "Roll", -180, 180, 2)
	nmsNewZSlider.ValueChanged = function(self, value) GAMEMODE.ItemEditorSettings.CurrentEditingAngle.r = value end
	cpcNewCollapseCat.List:AddItem(nmsNewZSlider)
	cpcNewCollapseCat.UpdateNewValues = function(vecNewOffset)
		nmsNewXSlider.UpdateSlider(vecNewOffset.p)
		nmsNewYSlider.UpdateSlider(vecNewOffset.y)
		nmsNewZSlider.UpdateSlider(vecNewOffset.r)
	end
	return cpcNewCollapseCat
end

function PANEL:AddMatControls()
	local cpcNewCollapseCat = CreateGenericCollapse(nil, "Material Controls", intGlobalPadding, true)
	cpcNewCollapseCat.Icons = {}
	local ibnNewMatButton = CreateGenericImageButton(nil, "null", "", function() GAMEMODE.ItemEditorSettings.CurrentEditingMat = "" end)
	cpcNewCollapseCat.List:AddItem(ibnNewMatButton)
	table.insert(cpcNewCollapseCat.Icons, ibnNewMatButton)
	for _, strTexture in pairs(tblUsableMats or {}) do
		local ibnNewMatButton = CreateGenericImageButton(nil, strTexture, strTexture, function() GAMEMODE.ItemEditorSettings.CurrentEditingMat = strTexture end)
		cpcNewCollapseCat.List:AddItem(ibnNewMatButton)
		table.insert(cpcNewCollapseCat.Icons, ibnNewMatButton)
	end
	return cpcNewCollapseCat
end

function PANEL:AddCammeraControls()
	local cpcNewCollapseCat = CreateGenericCollapse(nil, "Cammera Controls", intGlobalPadding, false)
	local nmsNewRotationSlider = CreateGenericSlider(nil, "Rotation", -180, 180, 3)
	nmsNewRotationSlider.ValueChanged = function(self, value) GAMEMODE.ItemEditorSettings.CurrentCamRotation = value end
	cpcNewCollapseCat.List:AddItem(nmsNewRotationSlider)
	local nmsNewDistanceSlider = CreateGenericSlider(nil, "Distance", -120, 50)
	nmsNewDistanceSlider.ValueChanged = function(self, value) GAMEMODE.ItemEditorSettings.CurrentCamDistance = value end
	cpcNewCollapseCat.List:AddItem(nmsNewDistanceSlider)
	return cpcNewCollapseCat
end

function PANEL:PrintNewDementions()
	local vecVector = GAMEMODE.ItemEditorSettings.CurrentEditingVector
	local intX, intY, intZ = math.Round(vecVector.x * 10) / 10, math.Round(vecVector.y * 10) / 10, math.Round(vecVector.z * 10) / 10
	local strVector = tostring(intX .. ", " .. intY .. ", " .. intZ)
	local angAngle = GAMEMODE.ItemEditorSettings.CurrentEditingAngle
	local intPitch, intYaw, intRoll = math.Round(angAngle.p * 10) / 10, math.Round(angAngle.y * 10) / 10, math.Round(angAngle.r * 10) / 10
	local strAngle = tostring(intPitch .. ", " .. intYaw .. ", " .. intRoll)
	local strMat = GAMEMODE.ItemEditorSettings.CurrentEditingMat
	if strMat then strMat = '"' .. tostring(strMat) .. '"' end
	if !strMat then strMat = "nil" end
	print("Vector(" .. strVector .. "), Angle(" .. strAngle .. "), nil, " .. strMat)
	SetClipboardText("Vector(" .. strVector .. "), Angle(" .. strAngle .. "), nil, " .. strMat)
end
vgui.Register("editor_items", PANEL, "Panel")

concommand.Add("udk_edit_items", function(ply, command, args)
	GAMEMODE.ItemEditor = GAMEMODE.ItemEditor or vgui.Create("editor_items")
	GAMEMODE.ItemEditor:SetSize(390, 450)
	GAMEMODE.ItemEditor:SetPos(50, 50)
end)

