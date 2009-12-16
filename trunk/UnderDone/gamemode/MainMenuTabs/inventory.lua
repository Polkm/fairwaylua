PANEL = {}
PANEL.inventorylist = nil
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
		draw.RoundedBox(4, 0, 0, self.inventorylist:GetWide(), self.inventorylist:GetTall(), Color(50, 50, 50, 255))
	end
	self.inventorylist.catagories = {}
	self:LoadInventory()
end

function PANEL:PerformLayout()
	self.inventorylist:SetPos(0, 0)
	self.inventorylist:SetSize(((self.ItemIconSize + self.ItemIconPadding) * self.ItemRow) + self.ItemIconPadding, self:GetTall())
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
	self:PerformLayout()
end

function PANEL:AddItem(item, amount)
	local lstAddList = self.inventorylist
	local tblItemTable = GAMEMODE.DataBase.Items[item]
	local intListItems = 1
	if !tblItemTable.Stackable then intListItems = amount or 1 end
	for i = 1, intListItems do
		local icnItem = vgui.Create("FIconItem")
		icnItem:SetSize(self.ItemIconSize, self.ItemIconSize)
		icnItem:SetItem(tblItemTable, amount)
		lstAddList:AddItem(icnItem)
	end
end

vgui.Register("inventorytab", PANEL, "Panel")