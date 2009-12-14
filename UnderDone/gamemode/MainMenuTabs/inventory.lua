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
		if tblItemTable.Icon then icnItem:SetIcon(tblItemTable.Icon) end
		if tblItemTable.Stackable && amount > 1 then icnItem:SetAmount(amount) end
		---------ToolTip---------
		local Tooltip = Format("%s", tblItemTable.PrintName)
		if tblItemTable.Desc then Tooltip = Format("%s\n%s", Tooltip, tblItemTable.Desc) end
		if tblItemTable.Weight && tblItemTable.Weight > 0 then Tooltip = Format("%s\n%s Kgs", Tooltip, tblItemTable.Weight) end
		icnItem:SetTooltip(Tooltip)
		------Double Click------
		if tblItemTable.Use then
			local useFunc = function()
				RunConsoleCommand("UD_UseItem",item)
			end
			icnItem:SetDoubleClick(useFunc)
		end
		-------Right Click-------
		local menuFunc = function()
			GAMEMODE.MainMenu.ActiveMenu = DermaMenu()
			if tblItemTable.Use then GAMEMODE.MainMenu.ActiveMenu:AddOption("Use", function() RunConsoleCommand("UD_UseItem", item) end) end
			if tblItemTable.Dropable then
				GAMEMODE.MainMenu.ActiveMenu:AddOption("Drop", function()
					if tblItemTable.Stackable and amount >= 5 then
						DisplayPromt("number", "How many to drop", function(itemamount) RunConsoleCommand("UD_DropItem", item, itemamount) end, item)
					else
						RunConsoleCommand("UD_DropItem", item, 1)
					end
				end)
			end
			if tblItemTable.Giveable then
				for _, player in pairs(player.GetAll()) do
					if player:GetPos():Distance(LocalPlayer():GetPos()) < 250 && player != LocalPlayer() then
						if !GiveSubMenu then
							local GiveSubMenu = GAMEMODE.MainMenu.ActiveMenu:AddSubMenu("Give ...")
						end
						GiveSubMenu:AddOption(player:Nick(), function()
							if tblItemTable.Stackable and amount >= 5 then 
								DisplayPromt("number", "How many to give", function(itemamount) RunConsoleCommand("UD_GiveItem", item, itemamount, player:EntIndex()) end, item)
							else 
								RunConsoleCommand("UD_GiveItem", item, 1, player:EntIndex())
							end
						 end)
					end
				end
			end
			GAMEMODE.MainMenu.ActiveMenu:Open()
		end
		icnItem:SetRightClick(menuFunc)
		-------------------------
		lstAddList:AddItem(icnItem)
	end
end

vgui.Register("inventorytab", PANEL, "Panel")