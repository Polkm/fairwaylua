local Player = FindMetaTable("Player")

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