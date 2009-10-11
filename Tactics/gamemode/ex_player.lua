local Player = FindMetaTable("Player")

function Player:GiveCash(intAmount)
	if self:GetNWInt("cash") + intAmount >= 0 then 
		self:SetNWInt("cash", self:GetNWInt("cash") + intAmount)
		return true
	else
		return false
	end
end
