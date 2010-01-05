local Player = FindMetaTable("Player")

function Player:GetLevel()
	return toLevel(self:GetNWInt("exp"))
end

function Player:AddStat(strStat, intAmount)
	self:SetStat(strStat, self:GetStat(strStat) + intAmount)
end

function Player:SetStat(strStat, intAmount)
	self.Stats = self.Stats or {}
	self.Stats[strStat] = intAmount
	if SERVER then
		local tblStatTable = GAMEMODE.DataBase.Stats[strStat]
		tblStatTable:OnSet(self, intAmount)
		umsg.Start("UD_UpdateStats", self)
		umsg.String(strStat)
		umsg.Long(intAmount)
		umsg.End()
	end
end

function Player:GetStat(strStat)
	return self.Stats[strStat]
end

function toExp(intLevel)
	if intLevel <= 1 then intLevel = 0 end
	intLevel = math.pow(intLevel, 2)
	intLevel = intLevel * 20
	return intLevel
end

function toLevel(intExp)
	intExp = intExp / 20
	intExp = math.Clamp(intExp, 1, intExp)
	intExp = math.sqrt(intExp)
	intExp = math.floor(intExp)
	return intExp
end