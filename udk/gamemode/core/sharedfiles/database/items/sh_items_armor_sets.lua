local function AddBuff(tblAddTable, strBuff, intAmount)
	tblAddTable.Buffs = tblAddTable.Buffs or {}
	tblAddTable.Buffs[strBuff] = intAmount
	return tblAddTable
end

local tblEquipmentSet = {}
tblEquipmentSet.Name = "armor_antlion"
tblEquipmentSet.PrintName = "Antlion Armor"
tblEquipmentSet.Items = {}
tblEquipmentSet.Items[1] = "armor_chest_antlion"
tblEquipmentSet.Items[2] = "armor_helm_antlionhelm"
tblEquipmentSet.Items[3] = "armor_shield_antlionshell2"
tblEquipmentSet.Items[4] = "armor_shoulder_antlion"
tblEquipmentSet.Items[5] = "armor_belt_antlion"
AddBuff(tblEquipmentSet, "stat_maxhealth", 35)
Register.EquipmentSet(tblEquipmentSet)

local tblEquipmentSet = {}
tblEquipmentSet.Name = "twisted_souls"
tblEquipmentSet.PrintName = "Twisted Souls"
tblEquipmentSet.Items = {}
tblEquipmentSet.Items[1] = "armor_shield_skele"
tblEquipmentSet.Items[2] = "weapon_melee_skele"
AddBuff(tblEquipmentSet, "stat_strength", 10)
Register.EquipmentSet(tblEquipmentSet)

local tblEquipmentSet = {}
tblEquipmentSet.Name = "wraith"
tblEquipmentSet.PrintName = "The Wraith"
tblEquipmentSet.Items = {}
tblEquipmentSet.Items[1] = "armor_chest_skele"
tblEquipmentSet.Items[2] = "armor_helm_skele"
tblEquipmentSet.Items[3] = "armor_shoulder_skele"
tblEquipmentSet.Items[4] = "armor_belt_skele"
AddBuff(tblEquipmentSet, "stat_strength", 20)
Register.EquipmentSet(tblEquipmentSet)


local tblEquipmentSet = {}
tblEquipmentSet.Name = "ofdefence"
tblEquipmentSet.PrintName = "The Clash"
tblEquipmentSet.Items = {}
tblEquipmentSet.Items[1] = "armor_shield_tyrant"
tblEquipmentSet.Items[2] = "weapon_melee_tyrant"
AddBuff(tblEquipmentSet, "stat_maxhealth", 25)
Register.EquipmentSet(tblEquipmentSet)


--local tblEquipmentSet = {}
--tblEquipmentSet.Name = "armor_tyrant"
--tblEquipmentSet.PrintName = "The Tyrant"
--tblEquipmentSet.Items = {}
--tblEquipmentSet.Items[1] = "armor_chest_tyrant"
--tblEquipmentSet.Items[2] = "armor_helm_tyrant"
--tblEquipmentSet.Items[3] = "armor_shoulder_tyrant"
--tblEquipmentSet.Items[4] = "armor_belt_tyrant"
--AddBuff(tblEquipmentSet, "stat_maxhealth", 150)
--Register.EquipmentSet(tblEquipmentSet)


--local tblEquipmentSet = {}
--tblEquipmentSet.Name = "overseer"
--tblEquipmentSet.PrintName = "The Overseer"
--tblEquipmentSet.Items[1] = "armor_chest_bio"
--tblEquipmentSet.Items[2] = "armor_helm_bio"
--tblEquipmentSet.Items[3] = "armor_shoulder_bio"
--tblEquipmentSet.Items[4] = "armor_belt_bio"
--AddBuff(tblEquipmentSet, "stat_dexterity", 20)
--Register.EquipmentSet(tblEquipmentSet)