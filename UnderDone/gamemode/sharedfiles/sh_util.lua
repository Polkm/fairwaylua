local Entity = FindMetaTable("Entity")

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

function Entity:CreateGrip()
	local entGrip = ents.Create("prop_physics")
	entGrip:SetModel("models/props_junk/cardboard_box004a.mdl")
	entGrip:SetPos(self:GetPos())
	entGrip:SetAngles(self:GetAngles())
	entGrip:SetCollisionGroup(COLLISION_GROUP_WORLD)
	entGrip:SetColor(0, 0, 0, 0)
	entGrip:Spawn()
	self:SetParent(entGrip)
end

if SERVER then
	function SendUsrMsg(strName, plyTarget, tblArgs)
		umsg.Start(strName, plyTarget)
		for _, value in pairs(tblArgs or {}) do
			if type(value) == "string" then umsg.String(value)
			elseif type(value) == "number" then umsg.Long(value)
			elseif type(value) == "boolean" then umsg.Bool(value)
			elseif type(value) == "entity" or type(value) == "Player" then umsg.Entity(value)
			elseif type(value) == "Vector" then umsg.Vector(value)
			elseif type(value) == "Angle" then umsg.Angle(value) end
		end
		umsg.End()
	end
end

if CLIENT then
	function SendCompactCommand(strCommand, tblArgs)
		
		
	end
end