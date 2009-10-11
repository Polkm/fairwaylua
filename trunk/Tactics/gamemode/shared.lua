GM.Name 		= "Tactics"
GM.Author 		= "Shell Shocked"
GM.Email 		= ""
GM.Website 		= ""
GM.TeamBased 	= false

IdealCammeraDistance = 500
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