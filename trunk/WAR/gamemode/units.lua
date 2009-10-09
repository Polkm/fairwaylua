local TABLE = {}
TABLE.Name = "melontrooper"
TABLE.PrintName = "Melon Trooper"
TABLE.Model = "models/props_junk/watermelon01.mdl"
TABLE.SquadLimit = 4
TABLE.MoveSpeed = 100
TABLE.CircleSize = 35
RegisterUnit(TABLE)

local TABLE = {}
TABLE.Name = "smg"
TABLE.PrintName = "SMG"
TABLE.Model = "models/Weapons/w_smg1.mdl"
function TABLE:Equipt(sqdSquad)
	for k, Unit in pairs(sqdSquad.Units) do
		Unit:SetWeapon("smg")
	end
end
RegisterEquiptment(TABLE)