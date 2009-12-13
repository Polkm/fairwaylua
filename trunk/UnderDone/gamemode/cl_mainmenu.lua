PANEL = {}
PANEL.frame = nil
PANEL.tabsheet = nil
PANEL.InventoryTab = nil
PANEL.PlayersTab = nil

function PANEL:Init()
	self:SetSize(500, 500)
	self.frame = vgui.Create("DFrame")
	self.frame:SetTitle("")
	self.frame:SetDraggable(false)
	self.frame:ShowCloseButton(false)
	self.frame.Paint = function() end
	self.frame:MakePopup()
		self.tabsheet = vgui.Create("DPropertySheet", self.frame)
			self.InventoryTab = vgui.Create("inventorytab")
			self.PlayersTab = vgui.Create("playerstab")
		self.tabsheet:AddSheet("Inventory", self.InventoryTab, "gui/silkicons/user", false, false, "Minipulate your Items")
		self.tabsheet:AddSheet("Players", self.PlayersTab, "gui/silkicons/group", false, false, "List of players")
		self:PerformLayout()
end

function PANEL:PerformLayout()
	self.frame:SetPos(self:GetPos())
	self.frame:SetSize(self:GetSize())
		self.tabsheet:SetPos(0,0)
		self.tabsheet:SetSize(self:GetSize())
			self.InventoryTab:SetSize(self.tabsheet:GetWide() - 10, self.tabsheet:GetTall() - 30)
			self.InventoryTab:PerformLayout()
			self.PlayersTab:SetSize(self.tabsheet:GetWide() - 10, self.tabsheet:GetTall() - 30)
			self.PlayersTab:PerformLayout()
end
vgui.Register("mainmenu", PANEL, "Panel")

function DisplayPromt(strType, strTitle, fncOkPressed, strItem)
	local Type = strType or "number"
	local Title = strTitle or "Promt "..Type
	local Func = fncOkPressed or nil
	local Item = strItem or nil
	local frame = vgui.Create("DFrame")
	frame:SetTitle(Title)
	frame:SetSize(250, 95)
	frame:Center()
	frame:SetDraggable(false)
	frame:ShowCloseButton(true)
	frame:MakePopup()
	if Type == "number" then
		PromtVarPicker = vgui.Create("DNumSlider", frame)
		PromtVarPicker:SetPos(5,30)
		PromtVarPicker:SetWide(240)
		PromtVarPicker:SetText("Amount")
		PromtVarPicker:SetValue(1)
		PromtVarPicker:SetMin(1)
		PromtVarPicker:SetMax(Inventory[Item])
		PromtVarPicker:SetDecimals(0)
	end
	local okbutton = vgui.Create("DButton", frame)
	okbutton:SetSize(100, 20)
	okbutton:SetPos(75, 70)
	okbutton:SetText("Done")
	okbutton.DoClick = function(okbutton)
		Func(math.Clamp(PromtVarPicker:GetValue(), 1, Inventory[Item]))
		frame:Close()
	end
end