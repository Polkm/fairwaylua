PANEL = {}
PANEL.inventorylist = nil

function PANEL:Init()
	self.inventorylist = vgui.Create("DPanelList", self)
	self.inventorylist:SetSpacing(1)
	self.inventorylist:SetPadding(1)
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
	self.inventorylist:SetSize(self:GetWide(), self:GetTall())
end

function PANEL:LoadInventory(boolTemp)
	local TempInv = boolTemp or false
	local WorkInv = Inventory
	if TempInv then WorkInv = Inventory_Temp end
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
	local addlist = self.inventorylist
	local tblItemTable = GAMEMODE.DataBase.Items[item]
	--[[if tblItemTable && tblItemTable.Catagory then
		if !self.inventorylist.catagories[tblItemTable.Catagory] then
			local tblCatagory = GAMEMODE.ItemCatagories[tblItemTable.Catagory]
			local catagory = vgui.Create("FListItem")
			catagory:SetNameText(tblCatagory.PrintName)
			catagory:SetExpandable(true)
			catagory:SetExpanded(true)
			addlist:AddItem(catagory)
			self.inventorylist.catagories[tblItemTable.Catagory] = catagory
			addlist = catagory
		else
			addlist = self.inventorylist.catagories[tblItemTable.Catagory]
		end
	end]]
	local ListItems = 1
	if !tblItemTable.Stackable then ListItems = amount end
	for i = 1, ListItems do
		-------------------------
		local IconItem = vgui.Create("FIconItem")
		IconItem:SetSize(39, 39)
		if tblItemTable.Icon then IconItem:SetIcon(tblItemTable.Icon) end
		if tblItemTable.Stackable && amount > 1 then IconItem:SetAmount(amount) end
		---------ToolTip---------
		local Tooltip = Format("%s", tblItemTable.PrintName)
		if tblItemTable.Desc then Tooltip = Format("%s\n%s", Tooltip, tblItemTable.Desc) end
		if tblItemTable.Weight && tblItemTable.Weight > 0 then Tooltip = Format("%s\n%s Kgs", Tooltip, tblItemTable.Weight) end
		IconItem:SetTooltip(Tooltip)
		------Common Button------
		if tblItemTable.Use then
			local useFunc = function()
				RunConsoleCommand("UD_UseItem",item)
			end
			--IconItem:SetCommonButton("gui/cup_go", useFunc, "Use")
		end
		----Secondary Buttons----
		local menuFunc = function()
			local ActionsMenu = DermaMenu()
			if tblItemTable.Use then ActionsMenu:AddOption("Use", function() RunConsoleCommand("UD_UseItem", item) end) end
			if tblItemTable.Dropable then ActionsMenu:AddOption("Drop", function()
			if tblItemTable.Stackable and amount >= 5 then DisplayPromt("number", "How many to drop", function(itemamount) RunConsoleCommand("UD_DropItem", item, itemamount) end, item)
			else RunConsoleCommand("UD_DropItem", item, 1) end end) end
			if tblItemTable.Giveable then
				local GiveSubMenu = ActionsMenu:AddSubMenu("Give ...")
				for _, player in pairs(player.GetAll()) do
					if player:GetPos():Distance(LocalPlayer():GetPos()) < 250 && player != LocalPlayer() then
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
			ActionsMenu:Open()
		end
		IconItem:SetRightClick(menuFunc)
		-------------------------
		if addlist == self.inventorylist then addlist:AddItem(IconItem)
		else addlist:AddContent(IconItem) end
	end
end

vgui.Register("inventorytab", PANEL, "Panel")