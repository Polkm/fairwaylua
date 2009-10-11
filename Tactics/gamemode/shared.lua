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
	CanSilence = false,
	ChangableFireRate = false,
	CanGrenade = false,
	UpGrades = {
		Power = {{Price = 600, Level = 17},
				{Price = 1500, Level = 20},
				{Price = 2500, Level = 23},
				{Price = 4000, Level = 25}},
		Accuracy = {{Price = 600, Level = 0.08},
				{Price = 1500, Level = 0.07},
				{Price = 3000, Level = 0.06},
				{Price = 4000, Level = 0.05},},
		ClipSize = {{Price = 800, Level = 15},
				{Price = 1300, Level = 25},
				{Price = 2000, Level = 35},
				{Price = 2600, Level = 45}},
		FiringSpeed = {{Price = 1000, Level = 0.2},
				{Price = 1400, Level = 0.15},
				{Price = 2200, Level = 0.1},
				{Price = 3100, Level = 0.08}},
		ReloadSpeed = {{Price = 400, Level = 1.2}},
	},
	Icon = "y",	

}
Weapons["weapon_mp5_tx"] = {
	Weapon = "weapon_mp5_tx",
	CanSilence = false,
	ChangableFireRate = false,
	CanGrenade = false,
	UpGrades = {
		Power = {{Price = 600, Level = 22},
				{Price = 1500, Level = 25},
				{Price = 2500, Level = 26},
				{Price = 4000, Level = 27}},
		Accuracy = {{Price = 600, Level = 0.1},
				{Price = 1500, Level = 0.09},
				{Price = 3000, Level = 0.08},
				{Price = 4000, Level = 0.07},},
		ClipSize = {{Price = 800, Level = 30},
				{Price = 1300, Level = 35},
				{Price = 2000, Level = 45},
				{Price = 2600, Level = 60}},
		FiringSpeed = {{Price = 1000, Level = 0.1},
				{Price = 1400, Level = 0.08},
				{Price = 2200, Level = 0.06},
				{Price = 3100, Level = 0.04}},
		ReloadSpeed = {{Price = 400, Level = 1.2}},
	},
	Icon = "x",
}

HealthSizes = {"half", "full"}
AmmoSizes = {"small", "medium", "large"}
--------
AmmoTypes = {}
--AR2
AmmoTypes[1] = {}
AmmoTypes[1]["full"] = 50
AmmoTypes[1]["large"] = 30
AmmoTypes[1]["medium"] = 25
AmmoTypes[1]["small"] = 20
--Pistol
AmmoTypes[3] = {}
AmmoTypes[3]["full"] = 100
AmmoTypes[3]["large"] = 70
AmmoTypes[3]["medium"] = 50
AmmoTypes[3]["small"] = 20
--SMG
AmmoTypes[4] = {}
AmmoTypes[4]["full"] = 200
AmmoTypes[4]["large"] = 50
AmmoTypes[4]["medium"] = 45
AmmoTypes[4]["small"] = 30

NPCData = {}
NPCData["default"] = {AmmoDrop = true, HealthDrop = true, CashDrop = true, CashToDrop = 5}
NPCData["npc_headcrab"] = {AmmoDrop = false}
NPCData["npc_headcrab_black"] = {AmmoDrop = false}
NPCData["npc_headcrab_fast"] = {AmmoDrop = false}
NPCData["npc_manhack"] = {}
NPCData["npc_poisonzombie"] = {}
NPCData["npc_zombie"] = {CashToDrop = 10}
NPCData["npc_zombie_torso"] = {}
NPCData["npc_fastzombie"] = {}
NPCData["npc_metropolice"] = {}
NPCData["npc_combine_s"] = {}