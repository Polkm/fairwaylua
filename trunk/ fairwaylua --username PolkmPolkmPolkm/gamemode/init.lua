AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_shop.lua")
AddCSLuaFile("GUIObjects/FMultiLineLabel.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("sh_weapons.lua")
include("shared.lua")
include("ex_player.lua")
include("commands.lua")
include("resoucre.lua")
GM.PlayerSpawnTime = {}

function GM:Initialize()
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

function GM:ShowHelp(ply)
	ply:ConCommand("hlmo_shop")
end

function GM:ScaleNPCDamage(npc, hitgroup, dmginfo)
	local Attacker = dmginfo:GetAttacker()
	if Attacker:IsPlayer() then
		local PlayerLevel = GetLevelValue(Attacker:GetNWInt("exp"))
		local NpcDataTable = NPCData[npc:GetClass()]
		local NPClevel = NpcDataTable.level or NPCData["default"].level
		local NPCArmor = NpcDataTable.Armor or NPCData["default"].Armor
		local WeaponDataTable = WeaponData[Attacker:GetActiveWeapon():GetClass()]
		--Set Damage
		--print((WeaponDataTable.BaseDamage * ((PlayerLevel / 10) + 1)) / NPCArmor)
		dmginfo:SetDamage((WeaponDataTable.BaseDamage * ((PlayerLevel / 10) + 1)) / NPCArmor)
		--Give Exp
		local newEXP = Attacker:GetNWInt("exp")
		local baseEXP = NpcDataTable.BaseExp or NPCData["default"].BaseExp
		local addedEXP = ((NPClevel / PlayerLevel) * (baseEXP * math.Clamp(dmginfo:GetDamage(), 0, npc:GetMaxHealth())))
		newEXP = newEXP + addedEXP
		--print(addedEXP)
		Attacker:SetNWInt("exp", newEXP)
		Attacker:Save()
	end
end

function GM:OnNPCKilled(victim, killer, weapon)
	if killer:IsPlayer() then
		local NpcDataTable = NPCData[victim:GetClass()]
		local drops = {}
		--Ammo
		local AmmoDrop = NPCData["default"].AmmoDrop
		if type(NpcDataTable.AmmoDrop) == "boolean" then AmmoDrop = NpcDataTable.AmmoDrop end
		local RandomAmount = AmmoSizes[math.random(1, 15)]
		if AmmoDrop && type(RandomAmount) == "string" then
			table.insert(drops, {type = "ammo", amount = RandomAmount})
		end
		--Health
		local HealthDrop = NPCData["default"].HealthDrop
		if type(NpcDataTable.HealthDrop) == "boolean" then HealthDrop = NpcDataTable.HealthDrop end
		local RandomAmount = HealthSizes[math.random(1, 25)]
		if HealthDrop && type(RandomAmount) == "string"then
			table.insert(drops, {type = "health", amount = RandomAmount})
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
	timer.Simple(5, function() SpawnARandomNPC() end)
end
