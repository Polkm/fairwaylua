local function AddModel(tblAddTable, strModel, vecPostion, angAngle, clrColor, strMaterial)
	tblAddTable.Model = tblAddTable.Model or {}
	if type(tblAddTable.Model) != "table" then tblAddTable.Model = {} end
	table.insert(tblAddTable.Model, {Model = strModel, Position = vecPostion, Angle = angAngle, Color = clrColor, Material = strMaterial})
	return tblAddTable
end
local function AddStats(tblAddTable, intPower, intFireRate)
	tblAddTable.Power = intPower
	tblAddTable.FireRate = intFireRate
	tblAddTable.HoldType = "melee"
	return tblAddTable
end
local function AddBuff(tblAddTable, strBuff, intAmount)
	tblAddTable.Buffs[strBuff] = intAmount
	return tblAddTable
end
local function AddSound(tblAddTable, strShootSound)
	tblAddTable.Sound = strShootSound
	return tblAddTable
end

local Item = QuickCreateItemTable(BaseWeapon, "weapon_melee_axe", "Axe", "Feels new but old", "icons/weapon_axe")
Item = AddModel(Item, "models/props/CS_militia/axe.mdl", Vector(-0.3, -5.2, -1), Angle(-0.7, 78.3, -82.3))
Item = AddStats(Item, 8, 1.5)
Item = AddSound(Item, "weapons/iceaxe/iceaxe_swing1.wav")
Item.Weight = 1
Item.CanCutWood = true
Register.Item(Item)

local Item = QuickCreateItemTable(BaseWeapon, "weapon_melee_axe_enchanted", "Axe(Enchanted)", "Enchanted version of the axe, now it is 10 fold better", "icons/weapon_axe")
Item = AddModel(Item, "models/props/CS_militia/axe.mdl", Vector(-0.3, -5.2, -1), Angle(-0.7, 78.3, -82.3), Color(191, 75, 37, 255))
Item = AddStats(Item, 50, 3)
Item = AddSound(Item, "weapons/iceaxe/iceaxe_swing1.wav")
Item.Weight = 1
Item.CanCutWood = true
Register.Item(Item)

local Item = QuickCreateItemTable(BaseWeapon, "weapon_melee_cleaver", "Cleaver", "For chopping meat", "icons/weapon_cleaver")
Item = AddModel(Item, "models/props_lab/Cleaver.mdl", Vector(-1.3, 0.7, 0.2), Angle(98.5, 0, 98.5))
Item = AddStats(Item, 15, 1.3)
Item = AddSound(Item, "weapons/iceaxe/iceaxe_swing1.wav")
Item.Weight = 1
Item.Level = 3
Item.SellPrice = 75
Item.CanCutWood = true
Register.Item(Item)

local Item = QuickCreateItemTable(BaseWeapon, "weapon_melee_leadpipe", "Lead Pipe", "And now you even get lead poisoning!", "icons/weapon_pipe")
Item = AddModel(Item, "models/props_canal/mattpipe.mdl", Vector(-0.6, 0.8, -5.9), Angle(4.7, 56.9, -176))
Item = AddStats(Item, 10, 2.5)
Item = AddSound(Item, "weapons/iceaxe/iceaxe_swing1.wav")
Item.Weight = 1
Item.Level = 5
Item.SellPrice = 250
Item.CanCutWood = true
Register.Item(Item)

local Item = QuickCreateItemTable(BaseWeapon, "weapon_melee_fryingpan", "Frying Pan", "Its was for cooking ... not any more", "icons/junk_pan2")
Item = AddModel(Item, "models/props_interiors/pot02a.mdl", Vector(0.8, 8, -0.5), Angle(0, 0, 90))
Item = AddStats(Item, 10, 3)
Item = AddSound(Item, "weapons/iceaxe/iceaxe_swing1.wav")
Item.Weight = 1
Item.Level = 7
Item.SellPrice = 420
Item.CanCutWood = true
Register.Item(Item)

local Item = QuickCreateItemTable(BaseWeapon, "weapon_melee_emptool", "Emp Tool", "Alyx Must've dropped this back in black mesa.", "icons/weapon_axe")
Item = AddModel(Item, "models/alyx_EmpTool_prop.mdl", Vector(-1.9, -1, 0.3), Angle(86.3, -99.7, -134.5))
Item = AddStats(Item, 7.5, 4.0)
Item = AddSound(Item, "weapons/stunstick/stunstick_swing1.wav")
Item.Level = 7
Item.Weight = 1
Item.CanCutWood = false
Register.Item(Item)

local Item = QuickCreateItemTable(BaseWeapon, "weapon_melee_knife", "Knife", "Cutting knifeS", "icons/weapon_cleaver")
Item = AddModel(Item, "models/weapons/w_knife_ct.mdl", Vector(-3.7, -0.3, 1.7), Angle(-8.7, 75.6, 31.4))
Item = AddStats(Item, 23, 2.5)
Item = AddSound(Item, "weapons/iceaxe/iceaxe_swing1.wav")
Item.Weight = 1
Item.Level = 10
Item.SellPrice = 545
Item.CanCutWood = true
Register.Item(Item)

local Item = QuickCreateItemTable(BaseWeapon, "weapon_melee_meathook", "Meathook", "It's covered in zombie blood", "icons/weapon_axe")
Item = AddModel(Item, "models/props_junk/meathook001a.mdl", Vector(0.6, -2.6, -8.1), Angle(4.7, -19.4, 180))
Item = AddStats(Item, 21.25, 2)
Item = AddSound(Item, "weapons/iceaxe/iceaxe_swing1.wav")
Item.Weight = 1
Item.SellPrice = 524
Item.Dropable = false
Item.Giveable = false
Item.CanCutWood = false
Register.Item(Item)

local Item = QuickCreateItemTable(BaseWeapon, "weapon_melee_harpoon", "Harpoon", "Whats that? Ew.. theres bits from its last use on it...", "icons/weapon_axe")
Item = AddModel(Item, "models/props_junk/harpoon002a.mdl", Vector(9, -1, 0.3), Angle(15.4, 75.6, -75.6))
Item = AddStats(Item, 15, 1.6)
Item = AddSound(Item, "weapons/iceaxe/iceaxe_swing1.wav")
Item.Level = 12
Item.Weight = 3
Item.SellPrice = 675
Item.CanCutWood = false
Register.Item(Item)

local Item = QuickCreateItemTable(BaseWeapon, "weapon_melee_circularsaw", "Circular Saw", "Zing Zing Ziiiingg!", "icons/junk_saw")
Item = AddModel(Item, "models/props_forest/circularsaw01.mdl", Vector(3.2, -7.7, -8.1), Angle(27.4, 123.8, -11.4))
Item = AddStats(Item, 41, 1.8)
Item = AddSound(Item, "weapons/iceaxe/iceaxe_swing1.wav")
Item.Weight = 1
Item.Level = 13
Item.SellPrice = 815
Item.CanCutWood = true
Register.Item(Item)

local Item = QuickCreateItemTable(BaseWeapon, "weapon_melee_anttalon", "Antlion Talon", "Stolen from an Antlion!", "icons/weapon_axe")
Item = AddModel(Item, "models/Gibs/Antlion_gib_medium_3a.mdl", Vector(-0.8, -9.9, -5.7), Angle(162.6, 134.5, 59.6))
Item = AddModel(Item, "models/Gibs/Antlion_gib_small_1.mdl", Vector(3.5, -0.8, 11.3), Angle(-138.5, 7.4, 63.6))
Item = AddModel(Item, "models/Gibs/Antlion_gib_small_1.mdl", Vector(4.8, -1.4, 4.1), Angle(-146.5, 7.4, 63.6))
Item = AddStats(Item, 52, 1.5)
Item = AddSound(Item, "weapons/iceaxe/iceaxe_swing1.wav")
Item.Level = 14
Item.Weight = 2
Item.SellPrice = 1240
Item.CanCutWood = false
Register.Item(Item)

local Item = QuickCreateItemTable(BaseWeapon, "weapon_melee_claw", "Claw", "Slightly Rusty, even better!", "icons/weapon_axe")
Item = AddModel(Item, "models/Gibs/manhack_gib05.mdl", Vector(5.9, -2.8, -0.3), Angle(8.7, 23.4, 14.1))
Item = AddModel(Item, "models/Gibs/manhack_gib05.mdl", Vector(0.3, 0.3, 0.6), Angle(180, -178.7, 180))
Item = AddModel(Item, "models/Gibs/manhack_gib05.mdl", Vector(0.3, -0.6, 1.4), Angle(180, -178.7, 180))
Item = AddStats(Item, 27, 3)
Item = AddSound(Item, "weapons/iceaxe/iceaxe_swing1.wav")
Item.Level = 14
Item.Weight = 1
Item.CanCutWood = false
Register.Item(Item)

local Item = QuickCreateItemTable(BaseWeapon, "weapon_melee_dualaxe", "War Axe", "Abit heavy... bit it sure can chop off heads!", "icons/weapon_axe")
Item = AddModel(Item, "models/props/CS_militia/axe.mdl", Vector(-0.3, -5.2, -1), Angle(-0.7, 78.3, -82.3))
Item = AddModel(Item, "models/props/CS_militia/axe.mdl", Vector(1.2, 0, 0), Angle(180, 0.2, 0))
Item = AddStats(Item, 85, 1)
Item = AddSound(Item, "weapons/iceaxe/iceaxe_swing1.wav")
Item.Level = 17
Item.Weight = 5
Item.SellPrice = 1859
Item.CanCutWood = true
Register.Item(Item)

local Item = QuickCreateItemTable(BaseWeapon, "weapon_melee_hammer", "Bros. Hammer", "STOP, Hammer Time'", "icons/weapon_axe")
Item = AddModel(Item, "models/props/CS_militia/axe.mdl", Vector(0.3, -5, -0.1), Angle(-0.7, 78.3, -82.3))
Item = AddModel(Item, "models/props/CS_militia/axe.mdl", Vector(1.2, 0, 0), Angle(180, 0.2, 0))
--Front
Item = AddModel(Item, "models/props_junk/garbage_metalcan001a.mdl", Vector(0, -16, -6), Angle(90, 0, 0), nil, "Models/props_c17/FurnitureMetal002a.vtf")
Item = AddModel(Item, "models/props_junk/garbage_metalcan001a.mdl", Vector(1.5, -15, -6), Angle(90, 0, 0), nil, "Models/props_c17/FurnitureMetal002a.vtf")
Item = AddModel(Item, "models/props_junk/garbage_metalcan001a.mdl", Vector(-1.5, -15, -6), Angle(90, 0, 0), nil, "Models/props_c17/FurnitureMetal002a.vtf")
Item = AddModel(Item, "models/props_junk/garbage_metalcan001a.mdl", Vector(0, -12, -6), Angle(90, 0, 0), nil, "Models/props_c17/FurnitureMetal002a.vtf")
Item = AddModel(Item, "models/props_junk/garbage_metalcan001a.mdl", Vector(1.5, -13, -6), Angle(90, 0, 0), nil, "Models/props_c17/FurnitureMetal002a.vtf")
Item = AddModel(Item, "models/props_junk/garbage_metalcan001a.mdl", Vector(-1.5, -13, -6), Angle(90, 0, 0), nil, "Models/props_c17/FurnitureMetal002a.vtf")
--back
Item = AddModel(Item, "models/props_junk/garbage_metalcan001a.mdl", Vector(0, -16, -5), Angle(-90, -180, 180), nil, "Models/props_c17/FurnitureMetal002a.vtf")
Item = AddModel(Item, "models/props_junk/garbage_metalcan001a.mdl", Vector(-1.5, -15, -5), Angle(-90, -180, 180), nil, "Models/props_c17/FurnitureMetal002a.vtf")
Item = AddModel(Item, "models/props_junk/garbage_metalcan001a.mdl", Vector(-1.5, 15, -5), Angle(90, 0, 180), nil, "Models/props_c17/FurnitureMetal002a.vtf")
Item = AddModel(Item, "models/props_junk/garbage_metalcan001a.mdl", Vector(-1.5, -13, -5), Angle(-90, -180, 180), nil, "Models/props_c17/FurnitureMetal002a.vtf")
Item = AddModel(Item, "models/props_junk/garbage_metalcan001a.mdl", Vector(1.5, -13, -5), Angle(-90, -180, 180), nil, "Models/props_c17/FurnitureMetal002a.vtf")
Item = AddModel(Item, "models/props_junk/garbage_metalcan001a.mdl", Vector(0, -12, -5), Angle(-90, -180, 180), nil, "Models/props_c17/FurnitureMetal002a.vtf")
--Middle
Item = AddModel(Item, "models/props_junk/garbage_metalcan001a.mdl", Vector(0, -14, -2.6), Angle(90, 0, 0), nil, "Models/props_c17/FurnitureMetal002a.vtf")
Item = AddModel(Item, "models/props_junk/garbage_metalcan001a.mdl", Vector(0, -14, -1.6), Angle(-90, 0, 0), nil, "Models/props_c17/FurnitureMetal002a.vtf")
Item = AddStats(Item, 140, 1.2)
Item = AddSound(Item, "weapons/iceaxe/iceaxe_swing1.wav")
Item.Weight = 9
Item.Level = 36
Item.SellPrice = 15200
Item.CanCutWood = false
Register.Item(Item)

--These here are weaposn made by comuniteh so yea we have to reveiw them and stuff before we add to game.
// Zcom ------------------
--Not sure abotu this one looks too big
local Item = QuickCreateItemTable(BaseWeapon, "weapon_melee_woodboard", "Wooden Board", "2x4 FTW", "icons/junk_saw")
Item = AddModel(Item, "models/props_debris/wood_board02a.mdl", Vector(-0.1, -1.7, 18), Angle(-10, 170.6, -3.3))
Item = AddStats(Item, 8, 2.3)
Item = AddSound(Item, "weapons/iceaxe/iceaxe_swing1.wav")
Item.Weight = 1
Item.SellPrice = 1
Item.CanCutWood = false
Register.Item(Item)

local Item = QuickCreateItemTable(BaseWeapon, "weapon_melee_pickaxe", "Pickaxe", "Goldrush!", "icons/weapon_axe")
Item = AddModel(Item, "models/props_mining/pickaxe01.mdl", Vector(-0.1, -0.6, -10.6), Angle(4.7, 72.9, 3.3))
Item = AddStats(Item, 14, 2.0)
Item = AddSound(Item, "weapons/iceaxe/iceaxe_swing1.wav")
Item.Weight = 1
Item.CanCutWood = true
Register.Item(Item)

--Not sure abotu this one looks too big
local Item = QuickCreateItemTable(BaseWeapon, "weapon_melee_metalpole", "Metal Pole", "This belongs to some poor streetsign somewhere.", "icons/weapon_axe")
Item = AddModel(Item, "models/props_c17/signpole001.mdl", Vector(-0.6, 0.1, -40), Angle(92.2, 155.9, 19.8))
Item = AddStats(Item, 20, 2.0)
Item = AddSound(Item, "weapons/iceaxe/iceaxe_swing1.wav")
Item.Weight = 1
Item.CanCutWood = false
Register.Item(Item)

//Raught
local Item = QuickCreateItemTable(BaseWeapon, "weapon_melee_reaper", "The Reaper", "Don't fear it.", "icons/weapon_axe")
Item = AddModel(Item, "models/props_c17/GasPipes006a.mdl", Vector(-4.3, 0.3, 1.7), Angle(-163.9, 71.6, 162.6))
Item = AddModel(Item, "models/Gibs/manhack_gib05.mdl", Vector(-4.3, -21.7, -0.6), Angle(15.4, 180, -91.7))
Item = AddModel(Item, "models/Gibs/manhack_gib05.mdl", Vector(-4.1, -20.9, -0.6), Angle(15.4, 180, -91.7))
Item = AddModel(Item, "models/Gibs/manhack_gib05.mdl", Vector(-4.1, -20.4, -0.1), Angle(15.4, 180, -91.7))
Item = AddModel(Item, "models/Gibs/manhack_gib05.mdl", Vector(-4.3, -19.3, -0.6), Angle(15.4, 180, -91.7))
Item = AddModel(Item, "models/Gibs/manhack_gib05.mdl", Vector(-3.2, -18.4, -0.6), Angle(15.4, 180, -91.7))
Item = AddModel(Item, "models/Gibs/manhack_gib05.mdl", Vector(-4.3, -21.7, -0.6), Angle(15.4, 180, -91.7))
Item = AddStats(Item, 55, 1)
Item = AddSound(Item, "weapons/iceaxe/iceaxe_swing1.wav")
Item.Level = 12
Item.Weight = 1
Item.SellPrice = 400
Item.CanCutWood = false
Register.Item(Item)

local Item = QuickCreateItemTable(BaseWeapon, "weapon_melee_skele", "The Soul Devourer", "This doesn't seem sanitary...", "icons/weapon_axe")
Item = AddModel(Item, "models/Gibs/HGIBS.mdl", Vector(-0.8, 0.1, 4.1), Angle(8.7, 6, 90.3))--skull
Item = AddModel(Item, "models/Gibs/HGIBS_spine.mdl", Vector(-0.3, 5, -10.1), Angle(-7.4, -83.6, -123.8))--spine
Item = AddModel(Item, "models/Gibs/manhack_gib05.mdl", Vector(5.7, -14.6, 3.5), Angle(-83.6, -0.7, -72.9))--scorp spike
Item = AddModel(Item, "models/Gibs/manhack_gib05.mdl", Vector(3.9, 0.6, 1.7), Angle(4.7, 2, -90.3))--blade
Item = AddModel(Item, "models/Gibs/manhack_gib05.mdl", Vector(3.9, 0.6, -1.9), Angle(4.7, 2, -90.3))
Item = AddStats(Item, 80, 3)
Item = AddSound(Item, "weapons/iceaxe/iceaxe_swing1.wav")
Item.Level = 45
Item.Weight = 1
Item.SellPrice = 3631
Item.CanCutWood = false
Register.Item(Item)

local Item = QuickCreateItemTable(BaseWeapon, "weapon_melee_tyrant", "Mace of Defence", "Forged by an unstoppable force.", "icons/weapon_axe")
Item = AddModel(Item, "models/weapons/W_stunbaton.mdl", Vector(-7.4, -0.3, 0.3), Angle(103.7, 6, 90.3))
Item = AddModel(Item, "models/Items/combine_rifle_ammo01.mdl", Vector(-0.3, -0.3, 9.2), Angle(98.4, 63.6, -114.4))
Item = AddStats(Item, 25, 3.5)
Item = AddSound(Item, "weapons/iceaxe/iceaxe_swing1.wav")
Item = AddBuff(Item, "stat_maxhealth", 50)
Item.Level = 50
Item.Weight = 1
Item.CanCutWood = false
Register.Item(Item)