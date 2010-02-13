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
tblEquipmentSet.Items[3] = "armor_shield_antlionshell"
tblEquipmentSet.Items[4] = "armor_shoulder_antlion"
tblEquipmentSet.Items[5] = "armor_belt_antlion"
AddBuff(tblEquipmentSet, "stat_maxhealth", 15)
Register.EquipmentSet(tblEquipmentSet)