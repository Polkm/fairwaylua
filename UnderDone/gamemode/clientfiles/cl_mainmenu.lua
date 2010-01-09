PANEL = {}
PANEL.Frame = nil
PANEL.TabSheet = nil
PANEL.TabPanels = {}
PANEL.InventoryTab = nil
PANEL.PlayersTab = nil
PANEL.ActiveMenu = nil

PANEL.TargetAlpha = 0
PANEL.CurrentAlpha = 0

function PANEL:Init()
	self:SetSize(500, 300)
	self.Frame = vgui.Create("DFrame")
	self.Frame:SetTitle("")
	self.Frame:SetDraggable(false)
	self.Frame:ShowCloseButton(false)
	self.Frame.Paint = function() end
	self.Frame:SetAlpha(0)
	self.Frame:MakePopup()
		self.TabSheet = vgui.Create("DPropertySheet", self.Frame)
			self.InventoryTab = self:NewTab("Inventory", "inventorytab", "gui/silkicons/user", "Minipulate your Items")
			self.PlayersTab = self:NewTab("Players", "playerstab", "gui/silkicons/group", "List of players")
		for _, sheet in pairs(self.TabSheet.Items) do
			sheet.Tab.Paint = function(panel)
				local clrBackColor = clrGray
				if panel:GetPropertySheet():GetActiveTab() == panel then clrBackColor = clrTan end
				local tblPaintPanle = jdraw.NewPanel()
				tblPaintPanle:SetDemensions(0, 0, sheet.Tab:GetWide(), sheet.Tab:GetTall() - 1)
				tblPaintPanle:SetStyle(4, clrBackColor)
				tblPaintPanle:SetBoarder(1, clrDrakGray)
				jdraw.DrawPanel(tblPaintPanle)
				if panel:GetPropertySheet():GetActiveTab() == panel then
					draw.RoundedBox(0, 1, sheet.Tab:GetTall() - 4, sheet.Tab:GetWide() - 2, 5, clrBackColor)
				else
					draw.RoundedBox(0, 1, sheet.Tab:GetTall() - 4, sheet.Tab:GetWide() - 2, 2, clrBackColor)
				end
			end
		end
		self.TabSheet.Paint = function()
			local tblPaintPanle = jdraw.NewPanel()
			tblPaintPanle:SetDemensions(0, 20, self.TabSheet:GetWide(), self.TabSheet:GetTall() - 20)
			tblPaintPanle:SetStyle(4, clrTan)
			tblPaintPanle:SetBoarder(1, clrDrakGray)
			jdraw.DrawPanel(tblPaintPanle)
		end
		self:PerformLayout()
end

function PANEL:SetTargetAlpha(intTargetAlpha)
	self.TargetAlpha = intTargetAlpha
end

function PANEL:Paint()
	if (self.TargetAlpha - self.CurrentAlpha) == 0 then return end
	local intNewAlpha = self.CurrentAlpha + (((self.TargetAlpha - self.CurrentAlpha) / math.abs(self.TargetAlpha - self.CurrentAlpha)) * 10)
	intNewAlpha = math.Clamp(intNewAlpha, 0, 255)
	self.Frame:SetAlpha(intNewAlpha)
	self.CurrentAlpha = intNewAlpha
	if self.CurrentAlpha <= 0 then
		GAMEMODE.MainMenu.Frame:SetVisible(false)
		if GAMEMODE.MainMenu.ActiveMenu then
			GAMEMODE.MainMenu.ActiveMenu:Remove()
		end
		RememberCursorPosition()
		gui.EnableScreenClicker(false)
	end
end

function PANEL:NewTab(strName, strPanelObject, strIcon, strDesc)
	local newPanel = vgui.Create(strPanelObject)
	self.TabSheet:AddSheet(strName, newPanel, strIcon, false, false, strDesc)
	table.insert(self.TabPanels, newPanel)
	return newPanel
end

function PANEL:PerformLayout()
	self.Frame:SetPos(self:GetPos())
	self.Frame:SetSize(self:GetSize())
		self.TabSheet:SetPos(0,0)
		self.TabSheet:SetSize(self:GetSize())
			if self.TabPanels then
				for _, panel in pairs(self.TabPanels) do
					panel:SetSize(self.TabSheet:GetWide() - 10, self.TabSheet:GetTall() - 30)
					panel:PerformLayout()
				end
			end
end
vgui.Register("mainmenu", PANEL, "Panel")

function DisplayPromt(strType, strTitle, fncOkPressed, strItem)
	local strType = strType or "number"
	local Title = strTitle or "Promt "..strType
	local Func = fncOkPressed or nil
	local Item = strItem or nil
	local frame = vgui.Create("DFrame")
	frame:SetTitle(Title)
	frame:SetSize(250, 95)
	frame:Center()
	frame:SetDraggable(false)
	frame:ShowCloseButton(true)
	frame:MakePopup()
	if strType == "number" then
		PromtVarPicker = vgui.Create("DNumSlider", frame)
		PromtVarPicker:SetPos(5,30)
		PromtVarPicker:SetWide(240)
		PromtVarPicker:SetText("Amount")
		PromtVarPicker:SetValue(1)
		PromtVarPicker:SetMin(1)
		PromtVarPicker:SetMax(LocalPlayer().Data.Inventory[Item])
		PromtVarPicker:SetDecimals(0)
	end
	local okbutton = vgui.Create("DButton", frame)
	okbutton:SetSize(100, 20)
	okbutton:SetPos(75, 70)
	okbutton:SetText("Done")
	okbutton.DoClick = function(okbutton)
		Func(math.Clamp(PromtVarPicker:GetValue(), 1, LocalPlayer().Data.Inventory[Item]))
		frame:Close()
	end
end