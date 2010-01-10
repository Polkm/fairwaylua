local Player = FindMetaTable("Player")

function Player:GiveExp(intAmount)
	local intCurrentExp = self:GetNWInt("exp")
	local intPreExpLevel = self:GetLevel()
	if intCurrentExp + intAmount >= 0 then
		self:SetNWInt("exp", intCurrentExp + intAmount)
		local intPostExpLevel = self:GetLevel()
		if intPreExpLevel < intPostExpLevel then
			self:CreateIndacator("Holy_Shit_Your_Cool!", self:GetPos() + Vector(0, 0, 70), "purple")
			self:CreateIndacator("Nice_Man!", self:GetPos() + Vector(0, 0, 70), "blue")
			self:CreateIndacator("You_Are_Epic!", self:GetPos() + Vector(0, 0, 70), "orange")
			self:CreateIndacator("I_Wish_I_Was_As_Cool_As_You!", self:GetPos() + Vector(0, 0, 70), "purple")
			self:CreateIndacator("I_Jizzed!", self:GetPos() + Vector(0, 0, 70), "blue")
			self:CreateIndacator("Gratz!", self:GetPos() + Vector(0, 0, 70), "orange")
			self:CreateIndacator("Call_Me!", self:GetPos() + Vector(0, 0, 70), "purple")
			self:CreateIndacator("You_Should_Model!", self:GetPos() + Vector(0, 0, 70), "orange")
		end
	end
end

function Player:CreateIndacator(strMessage, vecPosition, strColor)
	local strSendColor = strColor or "white"
	local tblVector = {}
	tblVector[1] = math.Round(vecPosition.x)
	tblVector[2] = math.Round(vecPosition.y)
	tblVector[3] = math.Round(vecPosition.z)
	self:ConCommand("UD_AddDamageIndacator " .. strMessage .. " " .. table.concat(tblVector, "!") .. " " .. strSendColor)
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