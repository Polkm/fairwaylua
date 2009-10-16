GM.Name 		= "Tactics"
GM.Author 		= "Shell Shocked"
GM.Email 		= ""
GM.Website 		= ""
GM.TeamBased 	= false

IdealCammeraDistance = 350
IdealCammeraPosition = Vector(-IdealCammeraDistance / 1.375, -IdealCammeraDistance / 1.375, IdealCammeraDistance)
IdealCammeraAngle = Angle(45, 45, 0)
CammeraSmoothness = 15

local Player = FindMetaTable("Player")
function Player:GetIdealCamPos()
	return self:GetPos() + IdealCammeraPosition + self.AddativeCamPos
end
function Player:GetIdealCamAngle()
	return IdealCammeraAngle + Angle(self.AddativeCamAngle, 0, 0)
end

Weapons = {}
Weapons["weapon_p220_tx"] = {
	Weapon = "weapon_p220_tx",
	Icon = "y",
	UpGrades = {
		Power = {{Price = 600, Level = 5},
				{Price = 1500, Level = 8},
				{Price = 2500, Level = 10},
				{Price = 4000, Level = 12}},
		Accuracy = {{Price = 600, Level = 0.08},
				{Price = 1500, Level = 0.07},
				{Price = 3000, Level = 0.06},
				{Price = 4000, Level = 0.05},},
		ClipSize = {{Price = 800, Level = 13},
				{Price = 1300, Level = 20},
				{Price = 2000, Level = 30},
				{Price = 2600, Level = 45}},
		FiringSpeed = {{Price = 1000, Level = 0.2},
				{Price = 1400, Level = 0.15},
				{Price = 2200, Level = 0.1},
				{Price = 3100, Level = 0.08}},
		ReloadSpeed = {{Price = 400, Level = 0.8}},
	},
}
Weapons["weapon_mp5_tx"] = {
	Weapon = "weapon_mp5_tx",
	Icon = "x",
	UpGrades = {
		Power = {{Price = 600, Level = 3},
				{Price = 1500, Level = 5},
				{Price = 2500, Level = 7},
				{Price = 4000, Level = 10}},
		Accuracy = {{Price = 600, Level = 0.10},
				{Price = 1500, Level = 0.09},
				{Price = 3000, Level = 0.08},
				{Price = 4000, Level = 0.07},},
		ClipSize = {{Price = 800, Level = 30},
				{Price = 1300, Level = 35},
				{Price = 2000, Level = 40},
				{Price = 2600, Level = 50}},
		FiringSpeed = {{Price = 1000, Level = 0.1},
				{Price = 1400, Level = 0.08},
				{Price = 2200, Level = 0.06},
				{Price = 3100, Level = 0.04}},
		ReloadSpeed = {{Price = 400, Level = 1.2}},
	},
}
Weapons["weapon_ump_tx"] = {
	Weapon = "weapon_ump_tx",
	Icon = "q",
	UpGrades = {
		Power = {{Price = 600, Level = 5},
				{Price = 1500, Level = 7},
				{Price = 2500, Level = 9},
				{Price = 4000, Level = 13}},
		Accuracy = {{Price = 600, Level = 0.12},
				{Price = 1500, Level = 0.10},
				{Price = 3000, Level = 0.09},
				{Price = 4000, Level = 0.07},},
		ClipSize = {{Price = 800, Level = 25},
				{Price = 1300, Level = 30},
				{Price = 2000, Level = 40},
				{Price = 2600, Level = 50}},
		FiringSpeed = {{Price = 1000, Level = 0.13},
				{Price = 1400, Level = 0.12},
				{Price = 2200, Level = 0.10},
				{Price = 3100, Level = 0.07}},
		ReloadSpeed = {{Price = 400, Level = 1.5}},
	},
}
Weapons["weapon_aug_tx"] = {
	Weapon = "weapon_aug_tx",
	Icon = "e",
	UpGrades = {
		Power = {{Price = 600, Level = 8},
				{Price = 1500, Level = 10},
				{Price = 2500, Level = 13},
				{Price = 4000, Level = 15}},
		Accuracy = {{Price = 600, Level = 0.13},
				{Price = 1500, Level = 0.09},
				{Price = 3000, Level = 0.08},
				{Price = 4000, Level = 0.07},},
		ClipSize = {{Price = 800, Level = 30},
				{Price = 1300, Level = 35},
				{Price = 2000, Level = 40},
				{Price = 2600, Level = 50}},
		FiringSpeed = {{Price = 1000, Level = 0.1},
				{Price = 1400, Level = 0.08},
				{Price = 2200, Level = 0.06},
				{Price = 3100, Level = 0.04}},
		ReloadSpeed = {{Price = 400, Level = 1.8}},
	},
}
Weapons["weapon_m4_tx"] = {
	Weapon = "weapon_m4_tx",
	Icon = "w",
	UpGrades = {
		Power = {{Price = 600, Level = 7},
				{Price = 1500, Level = 9},
				{Price = 2500, Level = 12},
				{Price = 4000, Level = 14}},
		Accuracy = {{Price = 600, Level = 0.11},
				{Price = 1500, Level = 0.09},
				{Price = 3000, Level = 0.07},
				{Price = 4000, Level = 0.06},},
		ClipSize = {{Price = 800, Level = 30},
				{Price = 1300, Level = 40},
				{Price = 2000, Level = 45},
				{Price = 2600, Level = 50}},
		FiringSpeed = {{Price = 1000, Level = 0.09},
				{Price = 1400, Level = 0.07},
				{Price = 2200, Level = 0.05},
				{Price = 3100, Level = 0.03}},
		ReloadSpeed = {{Price = 400, Level = 1.6}},
	},
}
Weapons["weapon_deagle_tx"] = {
	Weapon = "weapon_deagle_tx",
	Icon = "f",
	UpGrades = {
		Power = {{Price = 600, Level = 12},
				{Price = 1500, Level = 14},
				{Price = 2500, Level = 16},
				{Price = 4000, Level = 18}},
		Accuracy = {{Price = 600, Level = 0.09},
				{Price = 1500, Level = 0.08},
				{Price = 3000, Level = 0.07},
				{Price = 4000, Level = 0.06},},
		ClipSize = {{Price = 800, Level = 7},
				{Price = 1300, Level = 8},
				{Price = 2000, Level = 9},
				{Price = 2600, Level = 10}},
		FiringSpeed = {{Price = 1000, Level = 0.2},
				{Price = 1400, Level = 0.18},
				{Price = 2200, Level = 0.16},
				{Price = 3100, Level = 0.14}},
		ReloadSpeed = {{Price = 400, Level = 1.4}},
	},
}
Weapons["weapon_glock18_tx"] = {
	Weapon = "weapon_glock18_tx",
	Icon = "c",
	UpGrades = {
		Power = {{Price = 600, Level = 4},
				{Price = 1500, Level = 6},
				{Price = 2500, Level = 7},
				{Price = 4000, Level = 8}},
		Accuracy = {{Price = 600, Level = 0.09},
				{Price = 1500, Level = 0.08},
				{Price = 3000, Level = 0.07},
				{Price = 4000, Level = 0.06},},
		ClipSize = {{Price = 800, Level = 15},
				{Price = 1300, Level = 20},
				{Price = 2000, Level = 25},
				{Price = 2600, Level = 30}},
		FiringSpeed = {{Price = 1000, Level = 0.11},
				{Price = 1400, Level = 0.09},
				{Price = 2200, Level = 0.07},
				{Price = 3100, Level = 0.06}},
		ReloadSpeed = {{Price = 400, Level = 0.7}},
	},
}
Weapons["weapon_p90_tx"] = {
	Weapon = "weapon_p90_tx",
	Icon = "m",
	UpGrades = {
		Power = {{Price = 600, Level = 3},
				{Price = 1500, Level = 5},
				{Price = 2500, Level = 7},
				{Price = 4000, Level = 8}},
		Accuracy = {{Price = 600, Level = 0.14},
				{Price = 1500, Level = 0.12},
				{Price = 3000, Level = 0.10},
				{Price = 4000, Level = 0.09},},
		ClipSize = {{Price = 800, Level = 50},
				{Price = 1300, Level = 60},
				{Price = 2000, Level = 70},
				{Price = 2600, Level = 80}},
		FiringSpeed = {{Price = 1000, Level = 0.07},
				{Price = 1400, Level = 0.06},
				{Price = 2200, Level = 0.04},
				{Price = 3100, Level = 0.02}},
		ReloadSpeed = {{Price = 400, Level = 0.9}},
	},
}
Weapons["weapon_ak47_tx"] = {
	Weapon = "weapon_ak47_tx",
	Icon = "b",
	UpGrades = {
		Power = {{Price = 600, Level = 8},
				{Price = 1500, Level = 10},
				{Price = 2500, Level = 13},
				{Price = 4000, Level = 16}},
		Accuracy = {{Price = 600, Level = 0.14},
				{Price = 1500, Level = 0.12},
				{Price = 3000, Level = 0.10},
				{Price = 4000, Level = 0.09},},
		ClipSize = {{Price = 800, Level = 30},
				{Price = 1300, Level = 35},
				{Price = 2000, Level = 45},
				{Price = 2600, Level = 50}},
		FiringSpeed = {{Price = 1000, Level = 0.09},
				{Price = 1400, Level = 0.07},
				{Price = 2200, Level = 0.04},
				{Price = 3100, Level = 0.03}},
		ReloadSpeed = {{Price = 400, Level = 1.5}},
	},
}

HealthSizes = {"half", "full",}
AmmoSizes = {"small", "medium", "large", "full"}
--------
AmmoTypes = {}
--AR2
AmmoTypes[1] = {}
AmmoTypes[1]["full"] = 50
AmmoTypes[1]["large"] = 25
AmmoTypes[1]["medium"] = 20
AmmoTypes[1]["small"] = 10
--Pistol
AmmoTypes[3] = {}
AmmoTypes[3]["full"] = 70
AmmoTypes[3]["large"] = 35
AmmoTypes[3]["medium"] = 20
AmmoTypes[3]["small"] = 10
--SMG
AmmoTypes[4] = {}
AmmoTypes[4]["full"] = 100
AmmoTypes[4]["large"] = 50
AmmoTypes[4]["medium"] = 30
AmmoTypes[4]["small"] = 15

NPCData = {}
NPCData["default"] = {AmmoDrop = true, HealthDrop = true, CashDrop = true, CashToDrop = 3}
NPCData["npc_headcrab"] = {AmmoDrop = false}
NPCData["npc_headcrab_black"] = {AmmoDrop = false}
NPCData["npc_headcrab_fast"] = {AmmoDrop = false}
NPCData["npc_manhack"] = {}
NPCData["npc_poisonzombie"] = {}
NPCData["npc_zombie"] = {CashToDrop = 5}
NPCData["npc_zombie_torso"] = {}
NPCData["npc_fastzombie"] = {}
NPCData["npc_metropolice"] = {}
NPCData["npc_combine_s"] = {CashToDrop = 15}

PlayerPerk = {}
PlayerPerk["perk_ammoup"] = {
	Name = "Lead Currency",
	Desc = "Increases the amount of ammo you recieve, but cuts the amount of money recieved in half",
	Function = function(ply)  end,
	Active = false,
}
PlayerPerk["perk_leech"] = {
	Name = "Leech",
	Desc = "You are awarded health for hitting enemies, but take %30 more damage",
	Function = function(ply)  end,
	Active = false,
}
PlayerPerk["perk_tank"] = {
	Name = "Tank",
	Desc = "You're max health increases by %50, but your movement speed is decreased",
	Function = function(ply) ply:SetNWInt("MaxHp", ply:GetNWInt("MaxHp") + 50)	GAMEMODE:SetPlayerSpeed(ply,160,200) end,
	Active = false,
}
PlayerPerk["perk_gamble"] = {
	Name = "Gambling Addiction",
	Desc = "When picking up money, you may either gain 2x more money, or lose the money you should've picked up",
	Function = function(ply)  end,
	Active = false,
}
PlayerPerk["perk_bonk"] = {
	Name = "Bonk!",
	Desc = "You have a %25 speed increase, at the cost of health",
	Function = function(ply) ply:SetNWInt("MaxHp", ply:GetNWInt("MaxHp") - 25)	GAMEMODE:SetPlayerSpeed(ply,225,255)  end,
	Active = false,
}
