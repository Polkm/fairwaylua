local function AddModel(tblAddTable, strModel, vecPostion, angAngle, clrColor, strMaterial)
	tblAddTable.Model = tblAddTable.Model or {}
	if type(tblAddTable.Model) != "table" then tblAddTable.Model = {} end
	table.insert(tblAddTable.Model, {Model = strModel, Position = vecPostion, Angle = angAngle, Color = clrColor, Material = strMaterial})
	return tblAddTable
end
local function AddStats(tblAddTable, strSlot, intArmor)
	tblAddTable.Slot = strSlot
	tblAddTable.Armor = intPower
	return tblAddTable
end
local function AddBuff(tblAddTable, strBuff, intAmount)
	tblAddTable.Buffs[strBuff] = intAmount
	return tblAddTable
end

local Item = QuickCreateItemTable(BaseArmor, "armor_belt_backpack", "Small Backpacks", "It will add inventory space", "icons/item_cash")
Item = AddModel(Item, "models/weapons/w_defuser.mdl", Vector(-3.9, -0.3, -14.2), Angle(-0.7, -6, 2))
Item = AddStats(Item, "slot_waist", 0)
Register.Item(Item)

local Item = QuickCreateItemTable(BaseArmor, "armor_waist_jetpack", "Jetpack", "Just for show!", "icons/hat_cheifshat")
Item = AddModel(Item, "models/props_combine/breenlight.mdl", Vector(7.7, -4.3, -2.1), Angle(-15.4, -177.3, 0.7))
Item = AddModel(Item, "models/props_combine/breenlight.mdl", Vector(-0.3, 7.7, -0.1), Angle(-4.7, -4.7, -0.7))
Item = AddModel(Item, "models/props_combine/combine_emitter01.mdl", Vector(4.3, -4.3, -3.9), Angle(-94.3, 180, -2))
Item = AddStats(Item, "slot_waist", 1)
Item = AddBuff(Item, "stat_strength", 3)
Item = AddBuff(Item, "stat_agility", 5)
Item.Weight = 2
Item.SellPrice = 300
Register.Item(Item)

local Item = QuickCreateItemTable(BaseArmor, "armor_belt_skele", "Bone Gutguard", "Bone Daddy.", "icons/item_cash")
Item = AddModel(Item, "models/Gibs/HGIBS.mdl", Vector(5.5, 0.3, -6.8), Angle(16.7, 3.3, 2))
Item = AddModel(Item, "models/Gibs/HGIBS.mdl", Vector(1.7, -0.3, -5.2), Angle(3.3, -2, 2))
Item = AddModel(Item, "models/Gibs/manhack_gib05.mdl", Vector(1, -3.9, -2.1), Angle(-110.4, 7.4, -14.1))
Item = AddModel(Item, "models/Gibs/manhack_gib05.mdl", Vector(0.6, -3, 1.7), Angle(-74.3, 168, 19.4))
Item = AddStats(Item, "slot_waist", 0)
Item = AddBuff(Item, "stat_strength", 8)
Item.Level = 45
Register.Item(Item)

local Item = QuickCreateItemTable(BaseArmor, "armor_belt_cyborg", "Biomechanical Spine", "Resistance is Futile.", "icons/item_cash")
Item = AddModel(Item, "models/Gibs/manhack_gib02.mdl", Vector(10.6, -5.5, -1.9), Angle(90.3, -54.2, 2))--left
Item = AddStats(Item, "slot_waist", 0)
Item = AddBuff(Item, "stat_dexterity", 3)
Item = AddBuff(Item, "stat_maxhealth", 5)
Register.Item(Item)

local Item = QuickCreateItemTable(BaseArmor, "armor_belt_antlion", "Antlion Shell Codpiece", "I don't want Antlion pieces near there!", "icons/item_cash")
Item = AddModel(Item, "models/Gibs/Antlion_gib_small_2.mdl", Vector(15.5, 0.6, 2.8), Angle(85, 0.7, 2))--left
Item = AddStats(Item, "slot_waist", 10)
Item = AddBuff(Item, "stat_maxhealth", 5)
Register.Item(Item)

local Item = QuickCreateItemTable(BaseArmor, "armor_belt_tyrant", "Gutguard of the Tyrant", "Made from the finest materials, for protection.", "icons/item_cash")
Item = AddModel(Item, "models/props_combine/stalkerpod_lid.mdl", Vector(-15.9, 0.1, 9.3), Angle(-122.5, 180, 2))
Item = AddModel(Item, "models/props_combine/stalkerpod_lid.mdl", Vector(1, 0.1, 0.1), Angle(109.1, -178.7, 0.7))
Item = AddStats(Item, "slot_waist", 20)
Item = AddBuff(Item, "stat_maxhealth", 15)
Item.Level = 50
Register.Item(Item)