PANEL = {}
PANEL.inventorylist = nil
PANEL.WeightBar = nil
PANEL.Paperdoll = nil
PANEL.ItemIconPadding = 1
PANEL.ItemIconSize = 39
PANEL.ItemRow = 7

function PANEL:Init()
	self.inventorylist = vgui.Create("DPanelList", self)
	self.inventorylist:SetSpacing(self.ItemIconPadding)
	self.inventorylist:SetPadding(self.ItemIconPadding)
	self.inventorylist:EnableHorizontal(true)
	self.inventorylist:EnableVerticalScrollbar(true)
	self.inventorylist.Paint = function()
		local tblPaintPanle = jdraw.NewPanel()
		tblPaintPanle:SetDemensions(0, 0, self.inventorylist:GetWide(), self.inventorylist:GetTall())
		tblPaintPanle:SetStyle(4, clrGray)
		tblPaintPanle:SetBoarder(1, clrDrakGray)
		jdraw.DrawPanel(tblPaintPanle)
	end
	self.inventorylist.DoDropedOn = function()
		if !LocalPlayer().Data.Paperdoll or !GAMEMODE.DraggingPanel or !GAMEMODE.DraggingPanel.IsPapperDollSlot then return end
		if GAMEMODE.DraggingPanel.Item && GAMEMODE.DraggingPanel.Slot then
			if LocalPlayer().Data.Paperdoll[GAMEMODE.DraggingPanel.Slot] == GAMEMODE.DraggingPanel.Item then
				GAMEMODE.DraggingPanel.DoDoubleClick()
			end
		end
	end
	GAMEMODE:AddHoverObject(self.inventorylist)
	GAMEMODE:AddHoverObject(self.inventorylist.pnlCanvas, self.inventorylist)
	self.inventorylist.catagories = {}
	
	self.WeightBar = vgui.Create("FPercentBar", self)
	self.WeightBar:SetMax(GAMEMODE.MaxWeight)
	self.WeightBar:SetValue(LocalPlayer().Weight)
	self.WeightBar:SetText("Weight " .. LocalPlayer().Weight .. "/" ..  GAMEMODE.MaxWeight)
	
	self.Paperdoll = vgui.Create("FPaperDoll", self)
	self.Paperdoll.Paint = function()
		local tblPaintPanle = jdraw.NewPanel()
		tblPaintPanle:SetDemensions(0, 0, self.Paperdoll:GetWide(), self.Paperdoll:GetTall())
		tblPaintPanle:SetStyle(4, clrGray)
		tblPaintPanle:SetBoarder(1, clrDrakGray)
		jdraw.DrawPanel(tblPaintPanle)
	end

	self.StatsDisplay = vgui.Create("DPanelList", self)
	self.StatsDisplay:SetSpacing(0)
	self.StatsDisplay:SetPadding(3)
	self.StatsDisplay:EnableHorizontal(false)
	self.StatsDisplay:EnableVerticalScrollbar(false)
	self.StatsDisplay.Paint = function()
		local tblPaintPanle = jdraw.NewPanel()
		tblPaintPanle:SetDemensions(0, 0, self.StatsDisplay:GetWide(), self.StatsDisplay:GetTall())
		tblPaintPanle:SetStyle(4, clrGray)
		tblPaintPanle:SetBoarder(1, clrDrakGray)
		jdraw.DrawPanel(tblPaintPanle)
	end
	
	self:LoadInventory()
end

function PANEL:PerformLayout()
	self.inventorylist:SetPos(0, 20)
	self.inventorylist:SetSize(((self.ItemIconSize + self.ItemIconPadding) * self.ItemRow) + self.ItemIconPadding, self:GetTall() - 20)
	
	self.WeightBar:SetPos(0, 0)
	self.WeightBar:SetSize(self.inventorylist:GetWide(), 15)
	self.WeightBar:SetValue(LocalPlayer().Weight)
	self.WeightBar:SetText("Weight " .. LocalPlayer().Weight .. "/" ..  GAMEMODE.MaxWeight)
	
	self.Paperdoll:SetPos(self.inventorylist:GetWide() + 5, 0)
	self.Paperdoll:SetSize(self:GetWide() - (self.inventorylist:GetWide() + 5), self:GetTall() - 85)
	
	self.StatsDisplay:SetPos(self.inventorylist:GetWide() + 5, self.Paperdoll:GetTall() + 5)
	self.StatsDisplay:SetSize(self.Paperdoll:GetWide(), self:GetTall() - self.Paperdoll:GetTall() - 5)
end

function PANEL:LoadInventory(boolTemp)
	local TempInv = boolTemp or false
	local WorkInv = LocalPlayer().Data.Inventory or {}
	self.inventorylist:Clear()
	self.inventorylist.catagories = {}
	if WorkInv["money"] && WorkInv["money"] > 0 then self:AddItem("money", WorkInv["money"]) end
	for item, amount in pairs(WorkInv) do
		if amount > 0 && item != "money" then
			self:AddItem(item, amount)
		end
	end
	
	for name, slotTable in pairs(GAMEMODE.DataBase.Slots) do
		if self.Paperdoll.Slots[slotTable.Name] then
			if LocalPlayer().Data.Paperdoll[slotTable.Name] then
				self.Paperdoll.Slots[slotTable.Name]:SetItem(GAMEMODE.DataBase.Items[LocalPlayer().Data.Paperdoll[slotTable.Name]])
			else
				self.Paperdoll.Slots[slotTable.Name]:SetSlot(slotTable)
			end
		end
	end
	
	self.StatsDisplay:Clear()
	local tblAddTable = table.Copy(GAMEMODE.DataBase.Stats)
	tblAddTable = table.ClearKeys(tblAddTable)
	table.sort(tblAddTable, function(statA, statB) return statA.Index < statB.Index end)
	for key, stat in pairs(tblAddTable) do
		if LocalPlayer().Stats then
			local lblNewStat = vgui.Create("DLabel")
			lblNewStat:SetFont("UiBold")
			lblNewStat:SetColor(clrDrakGray)
			lblNewStat:SetText(stat.PrintName .. " " .. LocalPlayer().Stats[stat.Name])
			lblNewStat:SizeToContents()
			self.StatsDisplay:AddItem(lblNewStat)
		end
	end
	
	self:PerformLayout()
end

function PANEL:AddItem(item, amount)
	local lstAddList = self.inventorylist
	local tblItemTable = GAMEMODE.DataBase.Items[item]
	local intListItems = 1
	if !tblItemTable.Stackable then intListItems = amount or 1 end
	if table.HasValue(LocalPlayer().Data.Paperdoll or {}, item) then intListItems = intListItems - 1 end
	for i = 1, intListItems do
		local icnItem = vgui.Create("FIconItem")
		icnItem:SetSize(self.ItemIconSize, self.ItemIconSize)
		icnItem:SetItem(tblItemTable, amount)
		lstAddList:AddItem(icnItem)
	end
end

vgui.Register("inventorytab", PANEL, "Panel")