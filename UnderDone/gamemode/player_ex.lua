local Player = FindMetaTable("Player")

function Player:EquiptItem(tblItemTable)
	if !tblItemTable then return end
	if !self.Data.Paperdoll then self.Data.Paperdoll = {} end
	self:StripWeapons()
	self.Loadout = {}
	local strCurrentItem = self.Data.Paperdoll[tblItemTable.Slot]
	if !strCurrentItem or (strCurrentItem && strCurrentItem != tblItemTable.Name) then
		self:Give(tblItemTable.Weapon)
		self.Loadout[tblItemTable.Weapon] = true
		self.Data.Paperdoll[tblItemTable.Slot] = tblItemTable.Name
	else
		self.Data.Paperdoll[tblItemTable.Slot] = nil
	end
	umsg.Start("UD_UpdatePapperDoll", objTarget)
	umsg.String(tblItemTable.Slot)
	if self.Data.Paperdoll[tblItemTable.Slot] then
		umsg.String(tblItemTable.Name)
	end
	umsg.End()
end

--[[function Player:GetENTInv(entTarget)
	local DataTable = {}
	if entTarget:GetClass() == "player" then
		if !entTarget.Data.Inventory then return false end
		DataTable = entTarget.Data
	else
		if !entTarget.Inventory then return false end
		DataTable = entTarget
	end
	self:ClearTempInv()
	for k,v in pairs(DataTable.Inventory) do
		umsg.Start("AddItem", self)
		umsg.String(k)
		umsg.Long(v)
		umsg.String("temp")
		umsg.End()
		return true
	end
end

function Player:ClearTempInv()
	umsg.Start("RemoveItem", self)
	umsg.String("all")
	umsg.Long(0)
	umsg.String("temp")
	umsg.End()
end]]