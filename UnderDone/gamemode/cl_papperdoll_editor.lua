GM.PapperDollEditor = {}
GM.PapperDollEditor.CurrentSlot = nil
GM.PapperDollEditor.CurrentObject = 1
GM.PapperDollEditor.CurrentAddedVector = Vector(0, 0, 0)
GM.PapperDollEditor.CurrentAddedAngle = Angle(0, 0, 0)

function GM.PapperDollEditor.OpenPapperDollEditor()
	local frmPapperDollFrame = vgui.Create("DFrame")
	local pnlControlsList = vgui.Create("DPanelList", frmPapperDollFrame)
	local mlcSlotSellector = vgui.Create("DMultiChoice")
	pnlControlsList:AddItem(mlcSlotSellector)
	local mlcObjectSellector = vgui.Create("DMultiChoice")
	pnlControlsList:AddItem(mlcObjectSellector)
	local sldrXAxis, sldrYAxis, sldrZAxis = GAMEMODE.PapperDollEditor.AddVectorControls(pnlControlsList)
	local sldrPitch, sldrYaw, sldrZRoll = GAMEMODE.PapperDollEditor.AddAngleControls(pnlControlsList)
	local btnPrintButton = vgui.Create("DButton")
	pnlControlsList:AddItem(btnPrintButton)
	
	frmPapperDollFrame:SetPos(50, 50)
	frmPapperDollFrame:SetSize(300, 370)
	frmPapperDollFrame:SetTitle("Papper Doll Editor")
	frmPapperDollFrame:SetVisible(true)
	frmPapperDollFrame:SetDraggable(true)
	frmPapperDollFrame:ShowCloseButton(true)
	frmPapperDollFrame:MakePopup()
	
	pnlControlsList:SetPos(5, 30)
	pnlControlsList:SetSize(frmPapperDollFrame:GetWide() - 10, frmPapperDollFrame:GetTall() - 35)
	pnlControlsList:EnableHorizontal(false)
	pnlControlsList:EnableVerticalScrollbar(true)
	pnlControlsList:SetSpacing(5)
	pnlControlsList:SetPadding(5)
	
	for name, slot in pairs(GAMEMODE.DataBase.Slots) do
		mlcSlotSellector:AddChoice(name)
	end
	mlcSlotSellector.OnSelect = function(index, value, data)
		GAMEMODE.PapperDollEditor.CurrentSlot = data
		mlcObjectSellector:Clear()
		mlcObjectSellector:AddChoice(1)
		mlcObjectSellector:ChooseOptionID(1)
		if LocalPlayer().PapperDollEnts then
			for k, v in pairs(LocalPlayer().PapperDollEnts[data].Children or {}) do
				mlcObjectSellector:AddChoice(k + 1)
			end
		end
	end
	
	mlcObjectSellector.OnSelect = function(index, value, data)
		data = tonumber(data)
		GAMEMODE.PapperDollEditor.CurrentObject = data
		local strItem = GAMEMODE.Paperdoll[GAMEMODE.PapperDollEditor.CurrentSlot]
		local tblItemTable = GAMEMODE.DataBase.Items[strItem]
		if tblItemTable && tblItemTable.Model[data] then
			GAMEMODE.PapperDollEditor.CurrentAddedVector = tblItemTable.Model[data].Position
			GAMEMODE.PapperDollEditor.CurrentAddedAngle = tblItemTable.Model[data].Angle
			sldrXAxis.UpdateSlider(tblItemTable.Model[data].Position.x)
			sldrYAxis.UpdateSlider(tblItemTable.Model[data].Position.y)
			sldrZAxis.UpdateSlider(tblItemTable.Model[data].Position.z)
			sldrPitch.UpdateSlider(tblItemTable.Model[data].Angle.p)
			sldrYaw.UpdateSlider(tblItemTable.Model[data].Angle.y)
			sldrZRoll.UpdateSlider(tblItemTable.Model[data].Angle.r)
		end
	end
	
	btnPrintButton:SetText("Print Dementions")
	btnPrintButton.DoClick = function(btnPrintButton) GAMEMODE.PapperDollEditor.PrintNewDementions() end
end
concommand.Add("UD_Dev_EditPapperDoll", function() GAMEMODE.PapperDollEditor.OpenPapperDollEditor() end)

function GM.PapperDollEditor.AddVectorControls(pnlAddList)
	local nmsNewXSlider = GAMEMODE.PapperDollEditor.CreateGenericSlider(pnlAddList, "X Axis", 30)
	nmsNewXSlider.ValueChanged = function(self, value) GAMEMODE.PapperDollEditor.CurrentAddedVector.x = value end
	local nmsNewYSlider = GAMEMODE.PapperDollEditor.CreateGenericSlider(pnlAddList, "Y Axis", 30)
	nmsNewYSlider.ValueChanged = function(self, value) GAMEMODE.PapperDollEditor.CurrentAddedVector.y = value end
	local nmsNewZSlider = GAMEMODE.PapperDollEditor.CreateGenericSlider(pnlAddList, "Z Axis", 30)
	nmsNewZSlider.ValueChanged = function(self, value) GAMEMODE.PapperDollEditor.CurrentAddedVector.z = value end
	return nmsNewXSlider, nmsNewYSlider,nmsNewZSlider
end

function GM.PapperDollEditor.AddAngleControls(pnlAddList)
	local nmsNewPitchSlider = GAMEMODE.PapperDollEditor.CreateGenericSlider(pnlAddList, "Pitch", 180)
	nmsNewPitchSlider.ValueChanged = function(self, value) GAMEMODE.PapperDollEditor.CurrentAddedAngle.p = value end
	local nmsNewYawSlider = GAMEMODE.PapperDollEditor.CreateGenericSlider(pnlAddList, "Yaw", 180)
	nmsNewYawSlider.ValueChanged = function(self, value) GAMEMODE.PapperDollEditor.CurrentAddedAngle.y = value end
	local nmsNewRoolSlider = GAMEMODE.PapperDollEditor.CreateGenericSlider(pnlAddList, "Roll", 180)
	nmsNewRoolSlider.ValueChanged = function(self, value) GAMEMODE.PapperDollEditor.CurrentAddedAngle.r = value end
	return nmsNewPitchSlider, nmsNewYawSlider, nmsNewRoolSlider
end

function GM.PapperDollEditor.CreateGenericSlider(pnlAddList, strName, intRange)
	local nmsNewSlider = vgui.Create("DNumSlider")
	nmsNewSlider:SetText(strName)
	nmsNewSlider:SetMin(-intRange)
	nmsNewSlider:SetMax(intRange)
	nmsNewSlider:SetDecimals(1)
	nmsNewSlider.UpdateSlider = function(intNewValue)
		nmsNewSlider:SetValue(intNewValue)
		nmsNewSlider.Slider:SetSlideX(nmsNewSlider.Wang:GetFraction())
	end
	pnlAddList:AddItem(nmsNewSlider)
	return nmsNewSlider
end

function GM.PapperDollEditor.PrintNewDementions()
	local vecVector = GAMEMODE.PapperDollEditor.CurrentAddedVector
	local intX, intY, intZ = math.Round(vecVector.x * 10) / 10, math.Round(vecVector.y * 10) / 10, math.Round(vecVector.z * 10) / 10
	local strVector = tostring(intX .. ", " .. intY .. ", " .. intZ)
	local angAngle = GAMEMODE.PapperDollEditor.CurrentAddedAngle
	local intPitch, intYaw, intRoll = math.Round(angAngle.p * 10) / 10, math.Round(angAngle.y * 10) / 10, math.Round(angAngle.r * 10) / 10
	local strAngle = tostring(intPitch .. ", " .. intYaw .. ", " .. intRoll)
	print("Position = Vector(" .. strVector .. "), Angle = Angle(" .. strAngle .. ")")
end