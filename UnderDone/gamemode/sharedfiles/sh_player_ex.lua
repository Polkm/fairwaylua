local Player = FindMetaTable("Player")

function Player:IsMelee()
	if ItemTable(self:GetSlot("slot_primaryweapon")) && ItemTable(self:GetSlot("slot_primaryweapon")).HoldType then
		return ItemTable(self:GetSlot("slot_primaryweapon")).HoldType == "melee"
	end
	return
end

function Player:GetSlot(strSlot)
	if self.Data && self.Data.Paperdoll && self.Data.Paperdoll[strSlot] then
		return self.Data.Paperdoll[strSlot]
	end
	return
end

function Player:GetLevel()
	return toLevel(self:GetNWInt("exp"))
end