--This code is a mess but its basicly a dump for useful functions we cant live with out.
local Entity = FindMetaTable("Entity")
local Player = FindMetaTable("Player")

function StringatizeVector(vecVector)
	local tblVector = {}
	tblVector[1] = math.Round(vecVector.x * 100) / 100
	tblVector[2] = math.Round(vecVector.y * 100) / 100
	tblVector[3] = math.Round(vecVector.z * 100) / 100
	return table.concat(tblVector, "!")
end

function VectortizeString(strVectorString)
	local tblDecodeTable = string.Explode("!", strVectorString)
	return Vector(tblDecodeTable[1], tblDecodeTable[2], tblDecodeTable[3])
end

function table.Split(tblTable)
	if tblTable.r && tblTable.g && tblTable.b then
		return tblTable.r, tblTable.g, tblTable.b, tblTable.a
	end
	return tblTable[1], tblTable[2], tblTable[3], tblTable[4], tblTable[5], tblTable[6], tblTable[7]
end

function ColorCopy(clrToCopy, intAlpha)
	return Color(clrToCopy.r, clrToCopy.g, clrToCopy.b, intAlpha or clrToCopy.a)
end


if SERVER then
	function SendUsrMsg(strName, plyTarget, tblArgs)
		umsg.Start(strName, plyTarget)
		for _, value in pairs(tblArgs or {}) do
			if type(value) == "string" then umsg.String(value)
			elseif type(value) == "number" then umsg.Long(value)
			elseif type(value) == "boolean" then umsg.Bool(value)
			elseif type(value) == "Entity" or type(value) == "Player" then umsg.Entity(value)
			elseif type(value) == "Vector" then umsg.Vector(value)
			elseif type(value) == "Angle" then umsg.Angle(value)
			elseif type(value) == "table" then umsg.String(glon.encode(value)) end
		end
		umsg.End()
	end
	
	function GM:RemoveAll(strClass, intTime)
		table.foreach(ents.FindByClass(strClass .. "*"), function(_, ent) SafeRemoveEntityDelayed(ent, intTime or 0) end)
	end
end

if CLIENT then
	function CreateGenericFrame(strTitle, boolDrag, boolClose)
		local frmNewFrame = vgui.Create("DFrame")
		frmNewFrame:SetTitle(strTitle)
		frmNewFrame:SetDraggable(boolDrag)
		frmNewFrame:ShowCloseButton(boolClose)
		frmNewFrame:SetAlpha(255)
		frmNewFrame.Paint = function()
			local tblPaintPanel = jdraw.NewPanel()
			tblPaintPanel:SetDemensions(0, 0, frmNewFrame:GetWide(), frmNewFrame:GetTall())
			tblPaintPanel:SetStyle(4, clrTan)
			tblPaintPanel:SetBoarder(1, clrDrakGray)
			jdraw.DrawPanel(tblPaintPanel)
			local tblPaintPanel = jdraw.NewPanel()
			tblPaintPanel:SetDemensions(5, 5, frmNewFrame:GetWide() - 10, 15)
			tblPaintPanel:SetStyle(4, clrGray)
			tblPaintPanel:SetBoarder(1, clrDrakGray)
			jdraw.DrawPanel(tblPaintPanel)
		end
		return frmNewFrame
	end

	function CreateGenericList(pnlParent, intSpacing, boolHorz, boolScrollz)
		local pnlNewList = vgui.Create("DPanelList", pnlParent)
		pnlNewList:SetSpacing(intSpacing)
		pnlNewList:SetPadding(intSpacing)
		pnlNewList:EnableHorizontal(boolHorz)
		pnlNewList:EnableVerticalScrollbar(boolScrollz)
		pnlNewList.Paint = function()
			local tblPaintPanel = jdraw.NewPanel()
			tblPaintPanel:SetDemensions(0, 0, pnlNewList:GetWide(), pnlNewList:GetTall())
			tblPaintPanel:SetStyle(4, clrGray)
			tblPaintPanel:SetBoarder(1, clrDrakGray)
			jdraw.DrawPanel(tblPaintPanel)
		end
		return pnlNewList
	end
	
	function CreateGenericLabel(pnlParent, strFont, strText, clrColor)
		local lblNewLabel = vgui.Create("FMultiLabel", pnlParent)
		lblNewLabel:SetFont(strFont or "Default")
		lblNewLabel:SetText(strText or "Default")
		lblNewLabel:SetColor(clrColor or clrWhite)
		return lblNewLabel
	end
	
	function CreateGenericWeightBar(pnlParent, intWeight, intMaxWeight)
		local fpbWeightBar = vgui.Create("FPercentBar", pnlParent)
		fpbWeightBar:SetMax(intMaxWeight)
		fpbWeightBar:SetValue(intWeight)
		fpbWeightBar:SetText("Weight " .. intWeight .. "/" ..  intMaxWeight)
		fpbWeightBar.Update = function(pnlSelf, intNewValue)
			fpbWeightBar:SetValue(tonumber(intNewValue))
			fpbWeightBar:SetText("Weight " .. tostring(intNewValue) .. "/" ..  intMaxWeight)
		end
		return fpbWeightBar
	end
	
	function CreateGenericTabPanel(pnlParent)
		local tbsNewTabSheet = vgui.Create("DPropertySheet", pnlParent)
		tbsNewTabSheet.Paint = function()
			jdraw.QuickDrawPanel(clrTan, 0, 20, tbsNewTabSheet:GetWide(), tbsNewTabSheet:GetTall() - 20)
		end
		function tbsNewTabSheet:NewTab(strName, strPanelObject, strIcon, strDesc)
			local pnlNewPanel = vgui.Create(strPanelObject)
			tbsNewTabSheet:AddSheet(strName, pnlNewPanel, strIcon, false, false, strDesc)
			tbsNewTabSheet.TabPanels = tbsNewTabSheet.TabPanels or {}
			table.insert(tbsNewTabSheet.TabPanels, pnlNewPanel)
			for _, pnlSheet in pairs(tbsNewTabSheet.Items) do
				pnlSheet.Tab.Paint = function(tbsNewTabSheet)
					local clrBackColor = clrGray
					if tbsNewTabSheet:GetPropertySheet():GetActiveTab() == tbsNewTabSheet then clrBackColor = clrTan end
					jdraw.QuickDrawPanel(clrBackColor, 0, 0, pnlSheet.Tab:GetWide(), pnlSheet.Tab:GetTall() - 1)
					if tbsNewTabSheet:GetPropertySheet():GetActiveTab() == tbsNewTabSheet then
						draw.RoundedBox(0, 1, pnlSheet.Tab:GetTall() - 4, pnlSheet.Tab:GetWide() - 2, 5, clrBackColor)
					else
						draw.RoundedBox(0, 1, pnlSheet.Tab:GetTall() - 4, pnlSheet.Tab:GetWide() - 2, 2, clrBackColor)
					end
				end
			end
			return pnlNewPanel
		end
		return tbsNewTabSheet
	end
	
	function CreateGenericListItem(intHeaderSize, strNameText, strDesc, strIcon, clrColor, boolExpandable, boolExpanded)
		local lstNewListItem = vgui.Create("FListItem")
		lstNewListItem:SetHeaderSize(intHeaderSize)
		lstNewListItem:SetNameText(strNameText)
		lstNewListItem:SetDescText(strDesc)
		lstNewListItem:SetIcon(strIcon)
		lstNewListItem:SetColor(clrColor)
		lstNewListItem:SetExpandable(boolExpandable)
		lstNewListItem:SetExpanded(boolExpanded)
		return lstNewListItem
	end
	
	function CreateGenericSlider(pnlParent, strText, intMin, intMax, intDecimals, strConVar)
		local nmsNewNumSlider = vgui.Create("DNumSlider", pnlParent)
		nmsNewNumSlider:SetText(strText)
		nmsNewNumSlider:SetMin(intMin)
		nmsNewNumSlider:SetMax(intMax or intMin)
		nmsNewNumSlider:SetDecimals(intDecimals or 0)
		nmsNewNumSlider:SetConVar(strConVar)
		return nmsNewNumSlider
	end
	
	function CreateGenericCheckBox(pnlParent, strText, strConVar)
		local ckbNewCheckBox = vgui.Create( "DCheckBoxLabel", pnlParent)
		ckbNewCheckBox:SetText(strText)
		ckbNewCheckBox:SetConVar(strConVar)
		ckbNewCheckBox:SizeToContents()
		return ckbNewCheckBox
	end
	
	function CreateGenericImageButton(pnlParent, strImage, strToolTip, fncFunction)
		local btnNewButton = vgui.Create("DImageButton", pnlParent)
		btnNewButton:SetMaterial(strImage)
		btnNewButton:SetToolTip(strToolTip)
		btnNewButton:SizeToContents()
		btnNewButton.DoClick = fncFunction
		return btnNewButton
	end
	
	function CreateGenericButton(pnlParent, strText)
		local btnNewButton = vgui.Create("DButton", pnlParent)
		btnNewButton:SetText(strText)
		btnNewButton.Paint = function(btnNewButton)
			local clrDrawColor = ColorCopy(clrGray)
			local intGradDir = 1
			if btnNewButton:GetDisabled() then
				clrDrawColor = ColorCopy(clrGray, 100)
			elseif btnNewButton.Depressed || btnNewButton:GetSelected() then
				intGradDir = -1
			elseif btnNewButton.Hovered then
			end
			jdraw.QuickDrawPanel(clrDrawColor, 0, 0, btnNewButton:GetWide(), btnNewButton:GetTall())
			jdraw.QuickDrawGrad(Color(0, 0, 0, 100), 0, 0, btnNewButton:GetWide(), btnNewButton:GetTall(), intGradDir)
		end
		return btnNewButton
	end
	
	function CreateGenericPanel(pnlParent, intX, intY, intWidth, intHieght)
		local pnlNewPanel = vgui.Create("DPanel", pnlParent)
		pnlNewPanel:SetPos(intX, intY)
		pnlNewPanel:SetSize(intWidth, intHieght)
		pnlNewPanel.Paint = function()
			jdraw.QuickDrawPanel(clrGray, 0, 0, pnlNewPanel:GetWide(), pnlNewPanel:GetTall())
		end
		return pnlNewPanel
	end
	
	function CreateGenericMultiChoice(pnlParent, strText, boolEditable)
		local mlcNewMultiChoice = vgui.Create("DMultiChoice", pnlParent)
		mlcNewMultiChoice:SetText(strText or "")
		mlcNewMultiChoice:SetEditable(boolEditable or false)
		return mlcNewMultiChoice
	end
end