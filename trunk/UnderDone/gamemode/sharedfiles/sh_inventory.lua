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
	local intMaxItems = math.Clamp(math.floor((MaxWeight - self.Weight) / tblItemTable.Weight), 0, intAmount)
	intAmount = math.Clamp(intAmount, -self.Data.Inventory[strItem], intMaxItems)
	if SERVER then
		if self.Data.Paperdoll then
			if self.Data.Inventory[strItem] == 1 && self.Data.Paperdoll[tblItemTable.Slot] == strItem then
				self:UseItem(strItem)
			end
		end
	end
	self.Data.Inventory[strItem] = self.Data.Inventory[strItem] + intAmount
	self.Weight = self.Weight + (tblItemTable.Weight * intAmount)
	if SERVER then
		if self:GetClass() == "player" then
			umsg.Start("UD_UpdateItem", self)
			umsg.String(strItem)
			umsg.Long(intAmount)
			umsg.End()
		end
	end
	if CLIENT then
		if GAMEMODE.MainMenu then
			GAMEMODE.MainMenu.InventoryTab:LoadInventory()
		end
	end
	return true
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