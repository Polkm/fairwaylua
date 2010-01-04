PANEL = {}
PANEL.inventorylist = nil
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
		if !GAMEMODE.Paperdoll or !GAMEMODE.DraggingPanel or !GAMEMODE.DraggingPanel.IsPapperDollSlot then return end
		if GAMEMODE.DraggingPanel.Item && GAMEMODE.DraggingPanel.Slot then
			if GAMEMODE.Paperdoll[GAMEMODE.DraggingPanel.Slot] == GAMEMODE.DraggingPanel.Item then
				GAMEMODE.DraggingPanel.DoDoubleClick()
			end
		end
	end
	GAMEMODE:AddHoverObject(self.inventorylist)
	GAMEMODE:AddHoverObject(self.inventorylist.pnlCanvas, self.inventorylist)
	
	self.inventorylist.catagories = {}
	
	self.Paperdoll = vgui.Create("FPaperDoll", self)
	self.Paperdoll.Paint = function()
		local tblPaintPanle = jdraw.NewPanel()
		tblPaintPanle:SetDemensions(0, 0, self.Paperdoll:GetWide(), self.Paperdoll:GetTall())
		tblPaintPanle:SetStyle(4, clrGray)
		tblPaintPanle:SetBoarder(1, clrDrakGray)
		jdraw.DrawPanel(tblPaintPanle)
	end
	
	self.WeightBar = vgui.Create("FPercentBar", self)
	self.WeightBar:SetMax(MaxWeight)
	self.WeightBar:SetValue(GAMEMODE.TotalWeight)
	self.WeightBar:SetText("Weight " .. GAMEMODE.TotalWeight .. "/" ..  MaxWeight)
	
	self:LoadInventory()
end

function PANEL:PerformLayout()
	self.inventorylist:SetPos(0, 20)
	self.inventorylist:SetSize(((self.ItemIconSize + self.ItemIconPadding) * self.ItemRow) + self.ItemIconPadding, self:GetTall() - 20)
	
	self.Paperdoll:SetPos(self.inventorylist:GetWide() + 5, 0)
	self.Paperdoll:SetSize(self:GetWide() - (self.inventorylist:GetWide() + 5), self:GetTall())
	
	self.WeightBar:SetPos(0, 0)
	self.WeightBar:SetSize(self.inventorylist:GetWide(), 15)
end

function PANEL:LoadInventory(boolTemp)
	local TempInv = boolTemp or false
	local WorkInv = GAMEMODE.Inventory
	if TempInv then WorkInv = GAMEMODE.Inventory_Temp end
	self.inventorylist:Clear()
	self.inventorylist.catagories = {}
	if WorkInv["money"] && WorkInv["money"] > 0 then self:AddItem("money", WorkInv["money"]) end
	for item, amount in pairs(WorkInv) do
		if amount > 0 && item != "money" then
			self:AddItem(item, amount)
		end
	end
	
	for _, slotTable in pairs(GAMEMODE.DataBase.Slots) do
		if self.Paperdoll.Slots[slotTable.Name] then
			if GAMEMODE.Paperdoll[slotTable.Name] then
				self.Paperdoll.Slots[slotTable.Name]:SetItem(GAMEMODE.DataBase.Items[GAMEMODE.Paperdoll[slotTable.Name]])
			else
				self.Paperdoll.Slots[slotTable.Name]:SetSlot(slotTable)
			end
		end
	end
	
	self:PerformLayout()
end

function PANEL:AddItem(item, amount)
	local lstAddList = self.inventorylist
	local tblItemTable = GAMEMODE.DataBase.Items[item]
	local intListItems = 1
	if !tblItemTable.Stackable then intListItems = amount or 1 end
	if table.HasValue(GAMEMODE.Paperdoll, item) then intListItems = intListItems - 1 end
	for i = 1, intListItems do
		local icnItem = vgui.Create("FIconItem")
		icnItem:SetSize(self.ItemIconSize, self.ItemIconSize)
		icnItem:SetItem(tblItemTable, amount)
		lstAddList:AddItem(icnItem)
	end
end

vgui.Register("inventorytab", PANEL, "Panel")