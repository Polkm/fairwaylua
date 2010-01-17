local Entity = FindMetaTable("Entity")

function Entity:AddItem(strItem, intAmount)
	if !self or !self:IsValid() then return false end
	local tblItemTable = GAMEMODE.DataBase.Items[strItem]
	if !tblItemTable then return false end
	intAmount = tonumber(intAmount) or 1
	self.Data = self.Data or {}
	self.Data.Inventory = self.Data.Inventory or {}
	self.Data.Inventory[strItem] = self.Data.Inventory[strItem] or 0
	self.Weight = self.Weight or 0
	local intMaxItems = math.Clamp(math.floor((GAMEMODE.MaxWeight - self.Weight) / tblItemTable.Weight), 0, intAmount)
	intAmount = math.Clamp(intAmount, -self.Data.Inventory[strItem], intMaxItems)
	if intAmount == 0 then return false end
	if SERVER then
		if self.Data.Paperdoll then
			if self.Data.Inventory[strItem] == 1 && self.Data.Paperdoll[tblItemTable.Slot] == strItem then
				self:UseItem(strItem)
			end
		end
	end
	self.Data.Inventory[strItem] = self.Data.Inventory[strItem] + intAmount
	self.Weight = self.Weight + (tblItemTable.Weight * intAmount)
	if SERVER && self:GetClass() == "player" then
		SendUsrMsg("UD_UpdateItem", self, {strItem, intAmount})
	end
	if CLIENT then
		if GAMEMODE.MainMenu then GAMEMODE.MainMenu.InventoryTab:LoadInventory() end
		if GAMEMODE.ShopMenu then GAMEMODE.ShopMenu:LoadPlayer() end
	end
	return true
end

function Entity:RemoveItem(strItem, intAmount)
	return self:AddItem(strItem, -intAmount)
end

function Entity:TransferItem(objTarget, strItem1, intAmount1, strItem2, intAmount2)
	intAmount1 = tonumber(intAmount1) or 1
	intAmount2 = tonumber(intAmount2) or 0
	if strItem1 then if !objTarget:HasItem(strItem1, intAmount1) then return false end end
	if strItem2 then if !self:HasItem(strItem2, intAmount2) then return false end end
	if strItem1 then if self:AddItem(strItem1, intAmount1) then objTarget:AddItem(strItem1, -intAmount1) end end
	if strItem2 then if objTarget:AddItem(strItem2, intAmount2) then self:AddItem(strItem2, -intAmount2) end end
end

function Entity:HasItem(strItem, intAmount)
	if !self.Data.Inventory then return false end
	intAmount = tonumber(intAmount) or 1
	return self.Data.Inventory[strItem] - intAmount >= 0
end

if CLIENT then
	usermessage.Hook("UD_UpdateItem", function(usrMsg)
		LocalPlayer():AddItem(usrMsg:ReadString(), usrMsg:ReadLong())
	end)
end