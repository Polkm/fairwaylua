local tblNewUnit = {}
tblNewUnit.Name = "melontrooper"
tblNewUnit.PrintName = "Melon Trooper"
tblNewUnit.Model = "models/props_junk/watermelon01.mdl"
tblNewUnit.SquadLimit = 4
tblNewUnit.MoveSpeed = 100
tblNewUnit.CircleSize = 35
RegisterUnit(tblNewUnit)

local tblNewGun = {}
tblNewGun.Name = "smg"
tblNewGun.PrintName = "SMG"
tblNewGun.Model = "models/weapons/w_smg1.mdl"
function tblNewGun:Equipt(sqdSquad)
	for _, Unit in pairs(sqdSquad.Units) do
		Unit:SetWeapon("smg")
	end
end
RegisterEquiptment(tblNewGun)