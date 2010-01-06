local Player = FindMetaTable("Player")

function Player:GetLevel()
	return toLevel(self:GetNWInt("exp"))
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