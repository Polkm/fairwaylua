GM.Name 		= "HalfLife MO"
GM.Author 		= "Shell Shocked"
GM.Email 		= ""
GM.Website 		= ""
GM.TeamBased 	= false
--------------------------
GM.MaximumSlots = 3

WeaponData = {}
WeaponData["default"] = {
	BaseDamage = 2, Letter = "",
	Desc = "Empty Slot.",
	Sellable = false, SellPrice = 10,
	Buyable = false, BuyPrice = 15}
	
WeaponData["weapon_crowbar"] = {
	BaseDamage = 5, Letter = "c",
	Desc = "Bash your enimies with this iconic weapon of psychopaths."}
	
WeaponData["weapon_pistol"] = {
	BaseDamage = 5, Letter = "d",
	Desc = "What it lacks in power, the pistol makes up for in quantity.",
	Sellable = true, SellPrice = 150,
	Buyable = true, BuyPrice = 150}
	
WeaponData["weapon_smg1"] = {
	BaseDamage = 7, Letter = "a",
	Desc = "Turns flesh into hamburger.",
	Sellable = true, SellPrice = 500,
	Buyable = true, BuyPrice = 700}
	

HealthSizes = {"half", "full"}
AmmoSizes = {"small", "medium", "large"}
--------
AmmoTypes = {}
--Pistol
AmmoTypes[3] = {}
AmmoTypes[3]["full"] = 100
AmmoTypes[3]["large"] = 70
AmmoTypes[3]["medium"] = 50
AmmoTypes[3]["small"] = 20
--SMG
AmmoTypes[4] = {}
AmmoTypes[4]["full"] = 200
AmmoTypes[4]["large"] = 150
AmmoTypes[4]["medium"] = 100
AmmoTypes[4]["small"] = 50

NPCData = {}
NPCData["default"] = {BaseExp = 0.05, Armor = 1, level = 5, AmmoDrop = true, HealthDrop = true, CashDrop = true, CashToDrop = 5}
NPCData["npc_headcrab"] = {BaseExp = 0.05, level = 1, AmmoDrop = false}
NPCData["npc_headcrab_black"] = {BaseExp = 0.05, level = 2, AmmoDrop = false}
NPCData["npc_headcrab_fast"] = {BaseExp = 0.05, level = 2, AmmoDrop = false}
NPCData["npc_manhack"] = {BaseExp = 0.05, level = 1}
NPCData["npc_poisonzombie"] = {BaseExp = 0.05}
NPCData["npc_zombie"] = {BaseExp = 0.05, Armor = 1.5, CashToDrop = 10}
NPCData["npc_zombie_torso"] = {BaseExp = 0.05}
NPCData["npc_fastzombie"] = {BaseExp = 0.05}
NPCData["npc_metropolice"] = {BaseExp = 0.05}

EXP_LevelThreshholds = {
	0,
	50,
	100,
	200,
	450, --5
	700,
	1000,
	1400,
	1800,
	2300, --10
	2800,
	3400,
	4000,
	4600,
	5300, --15
	6000,
	7500,
	10000,
	12500,
	15000, --20
	20000,
	25000,
	50000,
	75000,
	100000, --25
}

function GetLevelValue(intExp)
	for k,v in pairs(EXP_LevelThreshholds) do
		if intExp >= v && intExp < EXP_LevelThreshholds[k + 1] then return k end
	end
end
