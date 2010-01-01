GM.PapperDollEditor = {}
GM.PapperDollEditor.CurrentSlot = nil
GM.PapperDollEditor.CurrentAddedVector = Vector(0, 0, 0)
GM.PapperDollEditor.CurrentAddedAngle = Angle(0, 0, 0)
function OpenPapperDollEditor()
	GAMEMODE.PapperDollEditor.PapperDollFrame = vgui.Create("DFrame")
	GAMEMODE.PapperDollEditor.PapperDollFrame:SetPos(50, 50)
	GAMEMODE.PapperDollEditor.PapperDollFrame:SetSize(300, 350)
	GAMEMODE.PapperDollEditor.PapperDollFrame:SetTitle("Papper Doll Editor")
	GAMEMODE.PapperDollEditor.PapperDollFrame:SetVisible(true)
	GAMEMODE.PapperDollEditor.PapperDollFrame:SetDraggable(true)
	GAMEMODE.PapperDollEditor.PapperDollFrame:ShowCloseButton(true)
	GAMEMODE.PapperDollEditor.PapperDollFrame:MakePopup()
	
	local intYoffset = 30
	local mlcSlotSellector = vgui.Create("DMultiChoice", GAMEMODE.PapperDollEditor.PapperDollFrame)
	mlcSlotSellector:SetPos(5, intYoffset)
	mlcSlotSellector:SetSize(GAMEMODE.PapperDollEditor.PapperDollFrame:GetWide() - 10, 20)
	for name, slot in pairs(GAMEMODE.DataBase.Slots) do
		mlcSlotSellector:AddChoice(name)
	end
	mlcSlotSellector.OnSelect = function(index, value, data)
		GAMEMODE.PapperDollEditor.CurrentSlot = data
		local strItem = GAMEMODE.Paperdoll[data]
		local tblItemTable = GAMEMODE.DataBase.Items[strItem]
		if tblItemTable && tblItemTable.Model[1] then
			GAMEMODE.PapperDollEditor.CurrentAddedVector = tblItemTable.Model[1].Position
			GAMEMODE.PapperDollEditor.CurrentAddedAngle = tblItemTable.Model[1].Angle
			local slrNumberSlider = nil
			slrNumberSlider = GAMEMODE.PapperDollEditor.PapperDollFrame.nmsXAxis
			slrNumberSlider:SetValue(tblItemTable.Model[1].Position.x)
			slrNumberSlider.Slider:SetSlideX(slrNumberSlider.Wang:GetFraction())
			slrNumberSlider = GAMEMODE.PapperDollEditor.PapperDollFrame.nmsYAxis
			slrNumberSlider:SetValue(tblItemTable.Model[1].Position.y)
			slrNumberSlider.Slider:SetSlideX(slrNumberSlider.Wang:GetFraction())
			slrNumberSlider = GAMEMODE.PapperDollEditor.PapperDollFrame.nmsZAxis
			slrNumberSlider:SetValue(tblItemTable.Model[1].Position.z)
			slrNumberSlider.Slider:SetSlideX(slrNumberSlider.Wang:GetFraction())
			slrNumberSlider = GAMEMODE.PapperDollEditor.PapperDollFrame.nmsPitch
			slrNumberSlider:SetValue(tblItemTable.Model[1].Angle.p)
			slrNumberSlider.Slider:SetSlideX(slrNumberSlider.Wang:GetFraction())
			slrNumberSlider = GAMEMODE.PapperDollEditor.PapperDollFrame.nmsYaw
			slrNumberSlider:SetValue(tblItemTable.Model[1].Angle.y)
			slrNumberSlider.Slider:SetSlideX(slrNumberSlider.Wang:GetFraction())
			slrNumberSlider = GAMEMODE.PapperDollEditor.PapperDollFrame.nmsRoll
			slrNumberSlider:SetValue(tblItemTable.Model[1].Angle.r)
			slrNumberSlider.Slider:SetSlideX(slrNumberSlider.Wang:GetFraction())
		end
	end
	intYoffset = intYoffset + mlcSlotSellector:GetTall() + 5
	
	GAMEMODE.PapperDollEditor.AddVectorControls()
	GAMEMODE.PapperDollEditor.AddAngleControls()
	
	local btnPrintButton = vgui.Create("DButton", GAMEMODE.PapperDollEditor.PapperDollFrame)
	btnPrintButton:SetPos(5, GAMEMODE.PapperDollEditor.PapperDollFrame:GetTall() - 25)
	btnPrintButton:SetSize(GAMEMODE.PapperDollEditor.PapperDollFrame:GetWide() - 10, 20)
	btnPrintButton:SetText("Print Dementions")
	btnPrintButton.DoClick = function(btnPrintButton)
		GAMEMODE.PapperDollEditor.PrintNewDementions()
	end

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

function GM.PapperDollEditor.AddVectorControls()
	local parent = GAMEMODE.PapperDollEditor.PapperDollFrame
	local intYoffset = 55
	local nmsXAxis = vgui.Create("DNumSlider", parent)
	nmsXAxis:SetPos(5, intYoffset)
	nmsXAxis:SetWide(parent:GetWide() - 10)
	nmsXAxis:SetText("X Axis")
	nmsXAxis:SetMin(-30)
	nmsXAxis:SetMax(30)
	nmsXAxis:SetDecimals(1)
	nmsXAxis.ValueChanged = function(self, value)
		GAMEMODE.PapperDollEditor.CurrentAddedVector.x = value
	end
	GAMEMODE.PapperDollEditor.PapperDollFrame.nmsXAxis = nmsXAxis
	intYoffset = intYoffset + nmsXAxis:GetTall() + 5
	
	local nmsYAxis = vgui.Create("DNumSlider", parent)
	nmsYAxis:SetPos(5, intYoffset)
	nmsYAxis:SetWide(parent:GetWide() - 10)
	nmsYAxis:SetText("Y Axis")
	nmsYAxis:SetMin(-30)
	nmsYAxis:SetMax(30)
	nmsYAxis:SetDecimals(1)
	nmsYAxis.ValueChanged = function(self, value)
		GAMEMODE.PapperDollEditor.CurrentAddedVector.y = value
	end
	GAMEMODE.PapperDollEditor.PapperDollFrame.nmsYAxis = nmsYAxis
	intYoffset = intYoffset + nmsYAxis:GetTall() + 5
	
	local nmsZAxis = vgui.Create("DNumSlider", parent)
	nmsZAxis:SetPos(5, intYoffset)
	nmsZAxis:SetWide(parent:GetWide() - 10)
	nmsZAxis:SetText("Z Axis")
	nmsZAxis:SetMin(-30)
	nmsZAxis:SetMax(30)
	nmsZAxis:SetDecimals(1)
	nmsZAxis.ValueChanged = function(self, value)
		GAMEMODE.PapperDollEditor.CurrentAddedVector.z = value
	end
	GAMEMODE.PapperDollEditor.PapperDollFrame.nmsZAxis = nmsZAxis
	intYoffset = intYoffset + nmsZAxis:GetTall() + 5
end

function GM.PapperDollEditor.AddAngleControls()
	local parent = GAMEMODE.PapperDollEditor.PapperDollFrame
	local intYoffset = 200
	local nmsPitch = vgui.Create("DNumSlider", parent)
	nmsPitch:SetPos(5, intYoffset)
	nmsPitch:SetWide(parent:GetWide() - 10)
	nmsPitch:SetText("Pitch")
	nmsPitch:SetMin(-180)
	nmsPitch:SetMax(180)
	nmsPitch:SetDecimals(1)
	nmsPitch.ValueChanged = function(self, value)
		GAMEMODE.PapperDollEditor.CurrentAddedAngle.p = value
	end
	GAMEMODE.PapperDollEditor.PapperDollFrame.nmsPitch = nmsPitch
	intYoffset = intYoffset + nmsPitch:GetTall() + 5
	
	local nmsYaw = vgui.Create("DNumSlider", parent)
	nmsYaw:SetPos(5, intYoffset)
	nmsYaw:SetWide(parent:GetWide() - 10)
	nmsYaw:SetText("Yaw")
	nmsYaw:SetMin(-180)
	nmsYaw:SetMax(180)
	nmsYaw:SetDecimals(1)
	nmsYaw.ValueChanged = function(self, value)
		GAMEMODE.PapperDollEditor.CurrentAddedAngle.y = value
	end
	GAMEMODE.PapperDollEditor.PapperDollFrame.nmsYaw = nmsYaw
	intYoffset = intYoffset + nmsYaw:GetTall() + 5
	
	local nmsRoll = vgui.Create("DNumSlider", parent)
	nmsRoll:SetPos(5, intYoffset)
	nmsRoll:SetWide(parent:GetWide() - 10)
	nmsRoll:SetText("Roll")
	nmsRoll:SetMin(-180)
	nmsRoll:SetMax(180)
	nmsRoll:SetDecimals(1)
	nmsRoll.ValueChanged = function(self, value)
		GAMEMODE.PapperDollEditor.CurrentAddedAngle.r = value
	end
	GAMEMODE.PapperDollEditor.PapperDollFrame.nmsRoll = nmsRoll
	intYoffset = intYoffset + nmsRoll:GetTall() + 5
end
concommand.Add("UD_Dev_EditPapperDoll", OpenPapperDollEditor)