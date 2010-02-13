local function AddModel(tblAddTable, strModel, vecPostion, angAngle, clrColor, strMaterial)
	tblAddTable.Model = tblAddTable.Model or {}
	if type(tblAddTable.Model) != "table" then tblAddTable.Model = {} end
	table.insert(tblAddTable.Model, {Model = strModel, Position = vecPostion, Angle = angAngle, Color = clrColor, Material = strMaterial})
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
Item = AddStats(Item, 5, 0.01, 1.5, 9) --(7.5)
Item = AddSound(Item, "weapons/pistol/pistol_fire2.wav", "weapons/pistol/pistol_reload1.wav")
Item.Weight = 1
Item.SellPrice = 15
Item.HoldType = "pistol"
Item.AmmoType = "smg1"
Register.Item(Item)

local Item = QuickCreateItemTable(BaseWeapon, "weapon_ranged_junksmg", "Junky SMG", "Made from old parts and crap like that.", "icons/weapon_pistol")
Item = AddModel(Item, "models/Weapons/w_smg1.mdl", Vector(7.5, -1.7, 3.2), Angle(-12.7, -0.7, -0.7))
Item = AddModel(Item, "models/props_junk/garbage_plasticbottle002a.mdl", Vector(1.2, 0.3, 0.3), Angle(0.7, 91.7, -87.7), nil, "Models/props_c17/FurnitureMetal002a.vtf")
Item = AddModel(Item, "models/props_junk/garbage_metalcan001a.mdl", Vector(1.4, -1, -7), Angle(180, -90.3, 90.3))
Item = AddModel(Item, "models/props_junk/GlassBottle01a.mdl", Vector(1, 2.1, -4.1), Angle(180, -90.3, -90.3))
Item = AddStats(Item, 3.7, 0.04, 7, 35) --(25.9)
Item = AddSound(Item, "weapons/smg1/smg1_fire1.wav", "weapons/smg1/smg1_reload.wav")
Item.Weight = 3
Item.Level = 4
Item.SellPrice = 80
Item.HoldType = "smg"
Item.AmmoType = "smg1"
Register.Item(Item)

local Item = QuickCreateItemTable(BaseWeapon, "weapon_ranged_junkrifle", "Junky Rifle", "Crafted with the junkiest materials around.", "icons/weapon_sniper1")
Item = AddModel(Item, "models/Weapons/w_annabelle.mdl", Vector(-12.4, 1.9, 1.4), Angle(10, -176, -7.4))
Item = AddModel(Item, "models/healthvial.mdl", Vector(-1.4, 1, -7.9), Angle(83.6, -2, 180))
Item = AddModel(Item, "models/Items/battery.mdl", Vector(-0.1, -0.8, -2.8), Angle(95.7, 178.7, -178.7))
Item = AddModel(Item, "models/props_c17/utilityconnecter006.mdl", Vector(1.2, -11.3, 1), Angle(-0.7, -93, 6))
Item = AddStats(Item, 17.5, 0.02, 2, 25) --(35)
Item = AddSound(Item, "weapons/ar1/ar1_dist2.wav", "weapons/crossbow/reload1.wav")
Item.Weight = 3
Item.Level = 8
Item.SellPrice = 350
Item.HoldType = "smg"
Item.AmmoType = "ar2"
Register.Item(Item)

local Item = QuickCreateItemTable(BaseWeapon, "weapon_ranged_heavymacgun", "Heavy Mac Gun", "Someone order a heeping pile of bullet?", "icons/weapon_heavymacgun")
Item = AddModel(Item, "models/Airboatgun.mdl", Vector(4.3, 0.6, 4.3), Angle(-2, -2, 0))
Item = AddStats(Item, 5.3, 0.06, 8, 50) --(42.4)
Item = AddSound(Item, "weapons/ar2/fire1.wav", "weapons/ar2/npc_ar2_reload.wav")
Item.Weight = 3
Item.Level = 10
Item.SellPrice = 480
Item.HoldType = "shotgun"
Item.AmmoType = "smg1"
Register.Item(Item)

local Item = QuickCreateItemTable(BaseWeapon, "weapon_ranged_drumshotgun", "Junky Shoty", "Has a drumclip for extra ammo.", "icons/weapon_shotgun")
Item = AddModel(Item, "models/Weapons/w_shotgun.mdl", Vector(-14.6, 1.4, -0.6), Angle(15.4, -174.6, -6))
Item = AddModel(Item, "models/props_lab/jar01a.mdl", Vector(-1.4, -0.3, -0.1), Angle(-97, -11.4, 10), nil, "Models/props_c17/FurnitureMetal002a.vtf")
Item = AddModel(Item, "models/props_junk/garbage_metalcan002a.mdl", Vector(-0.6, -0.1, -7.5), Angle(0.7, 87.7, 86.3), nil, "Models/props_c17/FurnitureMetal002a.vtf")
Item = AddStats(Item, 4.6, 0.1, 1.5, 12, 8) --(55.2)
Item = AddSound(Item, "weapons/shotgun/shotgun_fire7.wav", "weapons/shotgun/shotgun_cock.wav")
Item.QuestNeeded = "quest_arsenalupgrade"
Item.Weight = 3
Item.Level = 13
Item.SellPrice = 560
Item.HoldType = "shotgun"
Item.AmmoType = "buckshot"
Register.Item(Item)

local Item = QuickCreateItemTable(BaseWeapon, "weapon_ranged_revolver", "Junky Revolver", "Teh big pistol!", "icons/weapon_pistol")
Item = AddModel(Item, "models/weapons/W_357.mdl", Vector(-2.3, -0.8, 1.9), Angle(-2, -2, 0))
Item = AddModel(Item, "models/items/grenadeAmmo.mdl", Vector(-0.3, 1.2, -6.4), Angle(0, -90, 90))
Item = AddStats(Item, 80.5, 0.03, 0.7, 6) --(56.35)
Item = AddSound(Item, "weapons/357_fire2.wav", "weapons/357/357_spin1.wav")
Item.Weight = 3
Item.Level = 15
Item.SellPrice = 920
Item.HoldType = "pistol"
Item.AmmoType = "smg1"
Register.Item(Item)

local Item = QuickCreateItemTable(BaseWeapon, "weapon_ranged_wornasr", "Worn Assaultrifle", "This weapon has seen quite a few battles", "icons/weapon_sniper1")
Item = AddModel(Item, "models/props_canal/mattpipe.mdl", Vector(-3, 0.8, 11.9), Angle(72.9, 0, 0.7))
Item = AddModel(Item, "models/props_c17/TrapPropeller_Lever.mdl", Vector(0, -7.5, -2.1), Angle(0, 90, -102.4), nil, "Models/props_c17/FurnitureMetal002a.vtf")
Item = AddModel(Item, "models/Items/combine_rifle_cartridge01.mdl", Vector(8.8, 0.3, 8.6), Angle(27.4, 0, 180), nil, "Models/props_c17/FurnitureMetal002a.vtf")
Item = AddModel(Item, "models/Items/combine_rifle_cartridge01.mdl", Vector(1.7, -0.3, -2.1), Angle(-47.5, 0, 0), nil, "Models/props_c17/FurnitureMetal002a.vtf")
Item = AddStats(Item, 11, 0.05, 7, 35)
Item = AddSound(Item, "weapons/ar1/ar1_dist2.wav", "weapons/crossbow/reload1.wav")
Item.Weight = 4
Item.Level = 15
Item.SellPrice = 1400
Item.HoldType = "ar2"
Item.AmmoType = "ar2"
Register.Item(Item)

local Item = QuickCreateItemTable(BaseWeapon, "weapon_ranged_combine_cannon", "Combine Cannon", "Stolen cannon from the combine with extremely high fire rate.", "icons/weapon_heavymacgun")
Item = AddModel(Item, "models/Combine_turrets/combine_cannon_gun.mdl", Vector(12.2, -0.9, -10.4), Angle(-14.1, -2, 0))
Item = AddStats(Item, 8, 0.06, 12, 50)
Item = AddSound(Item, "weapons/ar2/fire1.wav", "weapons/ar2/npc_ar2_reload.wav")
Item.Weight = 5
Item.Level = 15
Item.SellPrice = 4600
Item.HoldType = "shotgun"
Item.AmmoType = "smg1"
Register.Item(Item)

--[[
local Item = QuickCreateItemTable(BaseWeapon, "weapon_ranged_battlerifle", "Battle Rifle", "Used by the Americans in the 2021 WWIII.", "icons/weapon_sniper1")
--Item = AddModel(Item, "models/Items/HealthKit.mdl", Vector(-9, 1.9, -0.3), Angle(10, -176, -7.4))
Item = AddModel(Item, "models/Weapons/W_crossbow.mdl", Vector(-9, 1.7, -4.3), Angle(8.7, 176, 90.3))
Item = AddModel(Item, "models/Items/battery.mdl", Vector(-0.1, -0.8, -2.8), Angle(95.7, 178.7, -178.7))
Item = AddModel(Item, "models/Items/battery.mdl", Vector(-5.7, -0.3, -15.5), Angle(95.7, 178.7, -178.7))
--Item = AddModel(Item, "models/props_c17/utilityconnecter006.mdl", Vector(0.8, -19.7, 1), Angle(-0.7, -93, 6))
Item = AddStats(Item, 22, 0.032, 40, 3) --(66)
Item = AddSound(Item, "weapons/ar1/ar1_dist2.wav")
Item.Weight = 5
Item.Level = 17
Item.SellPrice = 1530
Item.HoldType = "smg"
Item.AmmoType = "ar2"
Register.Item(Item)]]

local Item = QuickCreateItemTable(BaseWeapon, "weapon_ranged_combinesniper", "Combine Sniper", "Sniper Rifle from the combine.", "icons/weapon_heavymacgun")
Item = AddModel(Item, "models/weapons/w_combine_sniper.mdl", Vector(-17.3, 0.6, 2.6), Angle(-2, 173.3, 2))
Item = AddStats(Item, 150, 0.02, 0.2, 8) --(75)
Item = AddSound(Item, "weapons/ar2/fire1.wav", "weapons/ar2/npc_ar2_reload.wav")
Item.Weight = 3
Item.Level = 20
Item.SellPrice = 4200
Item.HoldType = "crossbow"
Item.AmmoType = "SniperRound"
Register.Item(Item)


