AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
include("resoucre.lua")
include("ex_player.lua")
GM.PlayerSpawnTime = {}
WeaponsManifest = {}
NodesManifest = {}

function GM:Initialize()
	----------------
	WeaponsManifest = weapons.GetList()
	for k, Weapon in pairs(WeaponsManifest) do
		if string.find(Weapon.ClassName, "base") then
			table.remove(WeaponsManifest, k)
		elseif Weapon.Spawnable && Weapon.Spawnable == false then
			table.remove(WeaponsManifest, k)
		elseif !Weapon.Spawnable then
			Weapon.Spawnable = true
		end
	end
	----------------
	EntsManifest = {}
	for k, Ent in pairs(scripted_ents.GetList()) do
		if Ent.t.Spawnable && Ent.t.Spawnable == true then
			table.insert(EntsManifest, Ent)
		end
	end
	----------------
	timer.Simple(1, function() AfterLoad() end)
	timer.Simple(5, function() SpawnARandomNPC() end)
end

function AfterLoad()
	NodesManifest = {}
	table.Add(NodesManifest, ents.FindByClass("path_corner"))
	table.Add(NodesManifest, ents.FindByClass("ai_hint"))
	--table.Add(NodesManifest, ents.FindByClass("info_node"))
end

function SwitchWeapon(plyTarget, strWeapon)
	plyTarget:SelectWeapon(strWeapon)
end
concommand.Add("FS_SwitchWep", function(ply, command, args) SwitchWeapon(ply, tostring(args[1])) end)

function GM:PlayerLoadout(ply)
	local entity = ents.Create("prop_dynamic")
	entity:SetModel("models/error.mdl")
	entity:Spawn()
	entity:SetAngles(ply:GetAngles())
	entity:SetMoveType(MOVETYPE_NONE)
	entity:SetParent(ply)
	entity:SetPos(ply:GetPos())
	entity:SetRenderMode(RENDERMODE_NONE)
	entity:SetSolid(SOLID_NONE)
	ply:SetViewEntity(entity)
	
	ply:Give("weapon_pistol")
	ply:Give("weapon_smg1")
end

function GM:OnNPCKilled(victim, killer, weapon)
	if killer:IsPlayer() then
		local NpcDataTable = NPCData[victim:GetClass()]
		local drops = {}
		--Ammo
		local AmmoDrop = NPCData["default"].AmmoDrop
		if type(NpcDataTable.AmmoDrop) == "boolean" then AmmoDrop = NpcDataTable.AmmoDrop end
		local RandomAmount = AmmoSizes[math.random(1, 10)]
		if AmmoDrop && type(RandomAmount) == "string" then
			table.insert(drops, {type = "ammo", amount = RandomAmount})
		end
		--Health
		local HealthDrop = NPCData["default"].HealthDrop
		if type(NpcDataTable.HealthDrop) == "boolean" then HealthDrop = NpcDataTable.HealthDrop end
		local RandomAmount = HealthSizes[math.random(1, 30)]
		if HealthDrop && type(RandomAmount) == "string"then
			table.insert(drops, {type = "health", amount = RandomAmount})
		end
		--Cash
		local CashDrop = NPCData["default"].CashDrop
		if type(NpcDataTable.CashDrop) == "boolean" then CashDrop = NpcDataTable.CashDrop end
		local CashToDrop = NpcDataTable.CashToDrop or NPCData["default"].CashToDrop
		local RandomAmount = math.random(CashToDrop - 5, CashToDrop + 5)
		local IsGoingToDrop = math.random(0, 5)
		if CashToDrop && RandomAmount > 0 && IsGoingToDrop == 1 then
			table.insert(drops, {type = "cash", amount = RandomAmount})
		end
		--Makin the reward
		if #drops > 0 then
			for _, drop in pairs(drops) do
				local reward = ents.Create("ent_reward")
				reward:SetPos(victim:GetPos() + Vector(0, 0, 20))
				reward:SetType(drop.type)
				reward:SetAmount(drop.amount)
				reward:SetNWEntity("PropProtector", killer)
				reward:Spawn()
				timer.Simple(10, function() if reward:IsValid() then reward:SetNWEntity("PropProtector", nil) end end)
				timer.Simple(40, function() if reward:IsValid() then reward:Remove() end end)
			end
		end
	end
end

function SpawnARandomNPC()
	local randomNode = NodesManifest[math.random(1, #NodesManifest)]
	local zombie = ents.Create("npc_zombie")
	zombie:SetPos(randomNode:GetPos())
	zombie:SetKeyValue("spawnflags",tostring(512))
	zombie:Spawn()
	timer.Simple(3, function() SpawnARandomNPC() end)
end
