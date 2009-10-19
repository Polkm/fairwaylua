require("datastream")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_menus.lua")
AddCSLuaFile("cl_shopmenu.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_scoreboard.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
include("player.lua")
include("ex_player.lua")
include("commands.lua")
include("resoucre.lua")
include("savingloading.lua")
GM.PlayerSpawnTime = {}
NodesManifest = {}

function SendDataToAClient(ply) 
	datastream.StreamToClients(ply, "LockerTransfer", {LockerTable = ply.Locker, PerkPerkPerk = ply.Perks}) 
	if ply.Locker[ply:GetNWInt("Weapon1")] then
		ply:GetWeapon(ply.Locker[ply:GetNWInt("Weapon1")].Weapon):Update()
	end
	if ply.Locker[ply:GetNWInt("Weapon2")] then
		ply:GetWeapon(ply.Locker[ply:GetNWInt("Weapon2")].Weapon):Update()
	end
end
concommand.Add("tx_updatelocker", SendDataToAClient)

function GM:OnNPCKilled(victim, killer, weapon)
	if killer:IsPlayer() then
		local NpcDataTable = NPCData[victim:GetClass()]
		local drops = {}
		--Ammo
		local AmmoDrop = NPCData["default"].AmmoDrop
		if type(NpcDataTable.AmmoDrop) == "boolean" then AmmoDrop = NpcDataTable.AmmoDrop end
		local RandomAmount = AmmoSizes[math.random(1, 8)]
		if AmmoDrop && type(RandomAmount) == "string" && RandomAmount != "full" then
			table.insert(drops, {type = "ammo", amount = RandomAmount})
		end
		--Health
		local HealthDrop = NPCData["default"].HealthDrop
		if type(NpcDataTable.HealthDrop) == "boolean" then HealthDrop = NpcDataTable.HealthDrop end
		local RandomAmount = HealthSizes[math.random(1, 70)]
		if HealthDrop && type(RandomAmount) == "string"then
			table.insert(drops, {type = "health", amount = RandomAmount})
		end
		--Cash
		local CashDrop = NPCData["default"].CashDrop
		if type(NpcDataTable.CashDrop) == "boolean" then CashDrop = NpcDataTable.CashDrop end
		local CashToDrop = NpcDataTable.CashToDrop or NPCData["default"].CashToDrop
		local RandomAmount = math.random(CashToDrop - 5, CashToDrop + 5)
		local IsGoingToDrop = math.random(1, 2)
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
				timer.Simple(10, function() if reward:IsValid() then reward:SetNWEntity("PropProtector", "none") end end)
				timer.Simple(60, function() if reward:IsValid() then reward:Remove() end end)
			end
		end 
	end
end
