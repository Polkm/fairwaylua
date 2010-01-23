local function AddModel(tblAddTable, strModel, vecPostion, angAngle)
	tblAddTable.Model = tblAddTable.Model or {}
	if type(tblAddTable.Model) != "table" then tblAddTable.Model = {} end
	table.insert(tblAddTable.Model, {Model = strModel, Position = vecPostion, Angle = angAngle})
	return tblAddTable
end
local function AddStats(tblAddTable, intPower, intAccuracy, intFireRate, intClipSize, intNumOfBullets)
	tblAddTable.Power = intPower
	tblAddTable.Accuracy = intAccuracy
	tblAddTable.FireRate = intFireRate
	tblAddTable.ClipSize = intClipSize
	tblAddTable.NumOfBullets = intNumOfBullets or 1
	return tblAddTable
end
local function AddSound(tblAddTable, strShootSound, strReloadSound)
	tblAddTable.Sound = strShootSound
	tblAddTable.ReloadSound = strReloadSound
	return tblAddTable
end

local Item = QuickCreateItemTable(BaseWeapon, "weapon_ranged_junkpistol", "Junky Pistol", "Looks like its all rusted.", "icons/weapon_pistol")
Item = AddModel(Item, "models/Weapons/W_pistol.mdl", Vector(-3, 0, 3.5), Angle(0, 180, 0))
Item = AddModel(Item, "models/props_junk/garbage_metalcan001a.mdl", Vector(0, 0, -7.2), Angle(90, 0, 0))
Item = AddStats(Item, 5, 0.01, 1.5, 9)
Item = AddSound(Item, "weapons/pistol/pistol_fire2.wav", "weapons/pistol/pistol_reload1.wav")
Item.Weight = 1
Item.SellPrice = 25
Item.HoldType = "pistol"
Item.AmmoType = "smg1"
Register.Item(Item)

local Item = QuickCreateItemTable(BaseWeapon, "weapon_ranged_heavymacgun", "Heavy Mac Gun", "Someone order a heeping pile of bullets?", "icons/weapon_heavymacgun")
Item = AddModel(Item, "models/Airboatgun.mdl", Vector(4.3, 0.6, 4.3), Angle(-2, -2, 0))
Item = AddStats(Item, 5, 0.06, 8, 50)
Item = AddSound(Item, "weapons/ar2/fire1.wav", "weapons/ar2/npc_ar2_reload.wav")
Item.Weight = 3
Item.SellPrice = 350
Item.HoldType = "shotgun"
Item.AmmoType = "smg1"
Register.Item(Item)

local Item = QuickCreateItemTable(BaseWeapon, "weapon_ranged_junksmg", "Junky SMG", "Made from old parts and crap like that.", "icons/weapon_pistol")
Item = AddModel(Item, "models/Weapons/w_smg1.mdl", Vector(7.5, -1.7, 3.2), Angle(-12.7, -0.7, -0.7))
Item = AddModel(Item, "models/props_junk/garbage_plasticbottle002a.mdl", Vector(1.2, 0.3, 0.3), Angle(0.7, 91.7, -87.7))
Item = AddModel(Item, "models/props_junk/garbage_metalcan001a.mdl", Vector(1.4, -1, -7), Angle(180, -90.3, 90.3))
Item = AddStats(Item, 4, 0.04, 7, 35)
Item = AddSound(Item, "weapons/smg1/smg1_fire1.wav", "weapons/smg1/smg1_reload.wav")
Item.Weight = 3
Item.SellPrice = 100
Item.HoldType = "smg"
Item.AmmoType = "smg1"
Register.Item(Item)