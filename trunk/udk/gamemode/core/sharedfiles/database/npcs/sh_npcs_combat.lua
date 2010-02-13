local function QuickNPC(strName, strPrintName, strSpawnName, strRace, intDistance, strModel)
	local NPC = {}
	NPC.Name = strName
	NPC.PrintName = strPrintName
	NPC.SpawnName = strSpawnName
	NPC.Race = strRace
	NPC.DistanceRetreat = intDistance
	NPC.Model = strModel
	return NPC
end
local function AddBool(Table, strFrozen, strInvincible, strIdle)
		Table.Frozen = strFrozen
		Table.Invincible = strInvincible
		Table.Idle = strIdle
	return Table
end
local function AddMultiplier(Table, strHealth, strDamage)
	Table.HealthPerLevel = strHealth
	Table.DamagePerLevel = strDamage
	return Table
end
local function AddDrop(Table, strName, intChance, intMin, intMax, intMinLevel)
	Table.Drops = Table.Drops or {}
	Table.Drops[strName] = {Chance = intChance, Min = intMin, Max = intMax, MinLevel = intMinLevel}
	return Table
end

local NPC = QuickNPC("zombie", "Zombie", "npc_zombie", "zombie", 1000)
AddDrop(NPC, "money", 50, 15, 18)
AddDrop(NPC, "item_bananna", 15)
AddDrop(NPC, "item_canspoilingmeat", 17)
AddDrop(NPC, "item_smallammo_small", 17)
AddDrop(NPC, "item_rifleammo_small", 17)
AddDrop(NPC, "item_buckshotammo_small", 15)
AddDrop(NPC, "armor_helm_headcrab", 0.05, nil, nil, 5)
AddDrop(NPC, "quest_zombieblood", 75)
AddMultiplier(NPC, 11, 3)
NPC.DeathDistance = 14
Register.NPC(NPC)

local NPC = QuickNPC("zombietorso", "Zombie Torso", "npc_zombie_torso", "zombie", 1000)
AddDrop(NPC, "money", 50, 15, 18)
AddDrop(NPC, "item_bananna", 8)
AddDrop(NPC, "item_canspoilingmeat", 8)
AddDrop(NPC, "item_smallammo_small", 8)
AddDrop(NPC, "item_rifleammo_small", 8)
AddDrop(NPC, "item_buckshotammo_small", 7)
AddDrop(NPC,"quest_zombieblood", 50)
AddMultiplier(NPC, 8, 4)
NPC.DeathDistance = 14
Register.NPC(NPC)

local NPC = QuickNPC("fastzombie", "Fast Zombie", "npc_fastzombie", "zombie", 1000)
AddDrop(NPC, "money", 50, 20, 25)
AddDrop(NPC, "item_bananna", 5)
AddDrop(NPC, "item_canspoilingmeat", 10)
AddDrop(NPC, "item_smallammo_small", 17)
AddDrop(NPC, "item_rifleammo_small", 17)
AddDrop(NPC, "item_buckshotammo_small", 15)
AddDrop(NPC, "armor_helm_bones", 2, nil, nil, 5)
AddDrop(NPC, "quest_zombieblood", 75)
AddMultiplier(NPC, 8, 3.5)
NPC.DeathDistance = 14
Register.NPC(NPC)

local NPC = QuickNPC("fastzombietorso", "Fast Zombie Torso", "npc_fastzombie_torso", "zombie", 1000)
AddDrop(NPC, "money", 50, 20, 25)
AddDrop(NPC, "item_bananna", 3)
AddDrop(NPC, "item_canspoilingmeat", 6)
AddDrop(NPC, "item_smallammo_small", 7)
AddDrop(NPC, "item_rifleammo_small", 6)
AddDrop(NPC, "item_buckshotammo_small", 6)
AddDrop(NPC, "armor_helm_bones", 2, nil, nil, 5)
AddDrop(NPC, "quest_zombieblood", 75)
AddMultiplier(NPC, 8, 4)
NPC.DeathDistance = 14
Register.NPC(NPC)

local NPC = QuickNPC("headcrab", "HeadCrab", "npc_headcrab", "zombie", 1000)
AddDrop(NPC,"money", 40, 10, 15)
AddDrop(NPC,"item_smallammo_small", 17)
AddDrop(NPC,"quest_zombieblood", 75)
AddMultiplier(NPC, 4, 2)
NPC.DeathDistance = 14
Register.NPC(NPC)

local NPC = QuickNPC("headcrabfast", "Fast HeadCrab", "npc_headcrab_fast", "zombie", 1000)
AddDrop(NPC,"money", 60, 15, 25)
AddDrop(NPC,"item_smallammo_small", 17)
AddDrop(NPC,"quest_zombieblood", 75)
AddMultiplier(NPC, 5, 3)
NPC.DeathDistance = 14
Register.NPC(NPC)

local NPC = QuickNPC("headcrabblack", "Poison HeadCrab", "npc_headcrab_black", "zombie", 1000)
AddDrop(NPC,"money", 90, 20, 30)
AddDrop(NPC,"item_smallammo_small", 17)
AddDrop(NPC,"quest_zombieblood", 75)
AddMultiplier(NPC, 8, 4)
NPC.DeathDistance = 14
Register.NPC(NPC)

local NPC = QuickNPC("zombine", "Zombine", "npc_zombine", "zombie", 1000)
AddDrop(NPC,"money", 50, 40, 50)
AddDrop(NPC,"item_bananna", 5)
AddDrop(NPC,"item_canspoilingmeat", 10)
AddDrop(NPC,"item_smallammo_small", 17)
AddDrop(NPC,"item_rifleammo_small", 17)
AddDrop(NPC,"item_buckshotammo_small", 15)
AddDrop(NPC,"quest_zombieblood", 75)
AddMultiplier(NPC, 40, 4)
NPC.DeathDistance = 14
Register.NPC(NPC)

local NPC = QuickNPC("antlion", "Antlion", "npc_antlion", "antlion", 1500)
NPC = AddDrop(NPC, "money", 50, 10, 20)
NPC = AddDrop(NPC, "item_orange", 10)
NPC = AddDrop(NPC, "weapon_ranged_junksmg", 1)
NPC = AddDrop(NPC, "armor_chest_antlion", 1.5)
NPC = AddDrop(NPC, "armor_shoulder_antlion", 3)
NPC = AddDrop(NPC, "armor_belt_antlion", 3)
NPC = AddDrop(NPC, "armor_helm_antlion", 3)
NPC = AddDrop(NPC, "armor_shield_antlionshell", 1, nil, nil, 7)
NPC = AddMultiplier(NPC, 10, 2)
NPC.DeathDistance = 14
Register.NPC(NPC)

local NPC = QuickNPC("antlionworker", "Antlion Worker", "npc_antlion_worker", "antlion", 1500)
NPC = AddDrop(NPC, "money", 50, 10, 20)
NPC = AddDrop(NPC, "item_orange", 10)
NPC = AddDrop(NPC, "armor_chest_antlion", 3)
NPC = AddDrop(NPC, "armor_shoulder_antlion", 4.5)
NPC = AddDrop(NPC, "armor_belt_antlion", 4.5)
NPC = AddDrop(NPC, "armor_helm_antlion", 4.5)
NPC = AddDrop(NPC, "weapon_ranged_junksmg", 1)
NPC = AddDrop(NPC, "weapon_melee_fryingpan", 1)
NPC = AddDrop(NPC, "armor_shield_antlionshell", 1, nil, nil, 7)
NPC = AddMultiplier(NPC, 9, .4)
NPC.DeathDistance = 14
Register.NPC(NPC)

local NPC = QuickNPC("antlionguard", "Antlion Boss", "npc_antlionguard", "antlion", 700)
NPC = AddDrop(NPC, "money", 400, 50, 100)
NPC = AddDrop(NPC, "weapon_melee_leadpipe", 2)
NPC = AddDrop(NPC, "armor_chest_antlion", 8)
NPC = AddDrop(NPC, "armor_shoulder_antlion", 10)
NPC = AddDrop(NPC, "armor_belt_antlion", 10)
NPC = AddDrop(NPC, "armor_helm_antlion", 10)
NPC = AddDrop(NPC, "armor_shield_metacarbon", 3, nil, nil, 20)
NPC = AddDrop(NPC, "armor_shoulder_antlion", 1, nil, nil, 20)
NPC = AddMultiplier(NPC, 25, 4)
NPC.DeathDistance = 40
Register.NPC(NPC)

local NPC = QuickNPC("combine_smg", "Combine Guard", "npc_combine_s", "combine", 300, "models/Betam01_Soldier.mdl")
NPC = AddDrop(NPC, "money", 50, 30, 43)
NPC = AddDrop(NPC, "item_smallammo_small", 20)
NPC = AddDrop(NPC, "item_rifleammo_small", 10)
NPC = AddDrop(NPC, "item_sniperammo_small", 5)
NPC = AddDrop(NPC, "weapon_ranged_junksmg", 1)
NPC = AddDrop(NPC, "weapon_ranged_junkrifle", 1)
NPC = AddDrop(NPC, "weapon_melee_wrench", 3)
NPC = AddDrop(NPC, "armor_helm_gasmask", 1)
NPC = AddDrop(NPC, "armor_shoulder_combine", 1, nil, nil, 10)
NPC = AddDrop(NPC, "weapon_melee_emptool", 2, nil, nil, 10)
NPC = AddDrop(NPC, "weapon_ranged_combinesniper", 0.2, nil, nil, 10)
NPC = AddMultiplier(NPC, 20, 2)
NPC.Weapon = "weapon_smg1"
NPC.DeathDistance = 14
Register.NPC(NPC)

local NPC = QuickNPC("combine_Elite", "Combine Elite", "npc_combine_s", "combine", 300, "models/combine_super_soldier.mdl")
NPC = AddDrop(NPC, "money", 200, 30, 43)
NPC = AddDrop(NPC, "item_smallammo_small", 30)
NPC = AddDrop(NPC, "item_rifleammo_small", 40)
NPC = AddDrop(NPC, "weapon_ranged_junksmg", 4)
NPC = AddDrop(NPC, "weapon_ranged_junkrifle", 4)
NPC = AddDrop(NPC, "weapon_melee_wrench", 1)
NPC = AddDrop(NPC, "armor_helm_cyborg", 0.3, nil, nil, 10)
NPC = AddDrop(NPC, "armor_chest_cyborg", 0.15, nil, nil, 10)
NPC = AddMultiplier(NPC, 25, 4)
NPC.Weapon = "weapon_ar2"
NPC.DeathDistance = 14
Register.NPC(NPC)

local NPC = QuickNPC("Breen", "Breen", "npc_breen", "combine", 300)
NPC = AddDrop(NPC, "armor_shoulder_cyborg", 0.1, nil, nil, 10)
NPC = AddMultiplier(NPC, 3, 2)
NPC.DeathDistance = 14
Register.NPC(NPC)

local NPC = QuickNPC("combine_turret(f)", "Combine Turret(Floor)", "npc_turret_floor", "combine")
NPC = AddMultiplier(NPC, 20, 3)
NPC = AddBool(NPC, true, false, false)
NPC.DeathDistance = 14
Register.NPC(NPC)

local NPC = QuickNPC("combine_turret(c)", "Combine Turret(Ceiling)", "npc_turret_ceiling", "combine")
NPC = AddMultiplier(NPC, 20, 3)
NPC = AddBool(NPC, true, false, false)
NPC.DeathDistance = 14
Register.NPC(NPC)

local NPC = QuickNPC("combine_manhack", "Combine ManHack", "npc_manhack", "combine", 1000)
NPC = AddMultiplier(NPC, 0.5, 0.5)
NPC.DeathDistance = 5
Register.NPC(NPC)

local NPC = QuickNPC("combine_rollermine", "Combine RollerMine", "npc_rollermine", "combine", 500)
NPC = AddMultiplier(NPC, 1, 3)
NPC.DeathDistance = 10
Register.NPC(NPC)
