local NPC = {}
NPC.Name = "zombie"
NPC.PrintName = "Zombie"
NPC.SpawnName = "npc_zombie"
NPC.HealthPerLevel = 14
NPC.Damage = 100
NPC.Race = "zombie"
NPC.Drops = {}
NPC.Drops["money"] = {Chance = 15, Min = 5, Max = 10}
NPC.Drops["can"] = {Chance = 10, Min = 1}
Register.NPC(NPC)

local NPC = {}
NPC.Name = "antlion"
NPC.PrintName = "Antlion"
NPC.SpawnName = "npc_antlion"
NPC.HealthPerLevel = 12
NPC.Race = "antlion"
Register.NPC(NPC)

local NPC = {}
NPC.Name = "antlionguard"
NPC.PrintName = "Antlion Boss"
NPC.SpawnName = "npc_antlionguard"
NPC.HealthPerLevel = 25
NPC.Race = "antlion"
Register.NPC(NPC)

local NPC = {}
NPC.Name = "combine"
NPC.PrintName = "Combine Guard"
NPC.SpawnName = "npc_combine_s"
NPC.HealthPerLevel = 20
NPC.Race = "combine"
Register.NPC(NPC)

local NPC = {}
NPC.Name = "shop_general"
NPC.PrintName = "Jay"
NPC.SpawnName = "npc_eli"
NPC.HealthPerLevel = 10
NPC.Invincible = true
NPC.Idle = true
NPC.Race = "human"
Register.NPC(NPC)

if SERVER then
	function GM:PlayerDeath(victim, weapon, killer)
		if killer:IsNPC() && victim:IsPlayer() then
			if killer.Race == victim.Race then
				killer:AddEntityRelationship(victim, GAMEMODE.RelationLike, 99)
			end
		end
	end
		
	function GM:OnNPCKilled(npc, killer, weapon)
		if npc:GetNWInt("level") > 0 && killer:IsPlayer() then
			local tblNPCTable = NPCTable(npc:GetNWString("npc"))
			local intPlayerLevel = killer:GetLevel()
			local intNPCLevel = npc:GetNWInt("level")
			local intExptoGive = math.Round((npc:GetMaxHealth() * (intNPCLevel / intPlayerLevel)) / 7)
			killer:CreateIndacator("+_" .. intExptoGive .. "_Exp", killer:GetPos() + Vector(0, 0, 70), "green")
			killer:GiveExp(intExptoGive)
			for item, args in pairs(tblNPCTable.Drops or {}) do
				if math.random(1, 100 / args.Chance) == 1 then
					local tblItemTable = ItemTable(item)
					local intAmount = math.random(args.Min or 1, args.Max or args.Min or 1)
					killer:AddItem(item, intAmount)
					killer:CreateNotification("Looted " .. intAmount .. " " .. tblItemTable.PrintName)
				end
			end
		end
	end

	function GM:ScaleNPCDamage(npc, hitgroup, dmginfo)
		local tblNPCTable = NPCTable(npc:GetNWString("npc"))
		local plyAttacker = dmginfo:GetAttacker()
		local boolInvincible = tblNPCTable && (tblNPCTable.Invincible or plyAttacker.Race == tblNPCTable.Race)
		if plyAttacker:IsPlayer() && (!tblNPCTable or !boolInvincible) then
			local clrDisplayColor = "white"
			local intNPCLevel = npc:GetNWInt("level")
			dmginfo:SetDamage(math.Round(dmginfo:GetDamage() * (1 / intNPCLevel)))
			if npc:GetClass() == "npc_headcrab" then dmginfo:SetDamage(999) end --I fuckin hate headcrabs	
			if math.random(1, 20) == 1 then
				dmginfo:SetDamage(math.Round(dmginfo:GetDamage() * 2))
				plyAttacker:CreateIndacator("Crit!", dmginfo:GetDamagePosition(), "blue")
				clrDisplayColor = "blue"
			end
			for name, stat in pairs(GAMEMODE.DataBase.Stats) do
				if plyAttacker:GetStat(name) && stat.DamageMod then
					dmginfo:SetDamage(stat:DamageMod(plyAttacker, plyAttacker:GetStat(name), dmginfo:GetDamage()))
				end
			end
			dmginfo:SetDamage(math.Round(dmginfo:GetDamage() + math.random(-1, 1)))
			if dmginfo:GetDamage() > 0 && dmginfo:GetDamage() < 9990 then
				plyAttacker:CreateIndacator(dmginfo:GetDamage(), dmginfo:GetDamagePosition(), clrDisplayColor)
			elseif dmginfo:GetDamage() <= 0 then
				plyAttacker:CreateIndacator("Miss!", dmginfo:GetDamagePosition(), "orange")
			end
		end
		if tblNPCTable && boolInvincible then dmginfo:SetDamage(0) end
		dmginfo:SetDamage(math.Clamp(math.Round(dmginfo:GetDamage()), 0, 9999))
		npc:AddEntityRelationship(plyAttacker, GAMEMODE.RelationHate, 99)
		npc:SetHealth(npc:Health() - dmginfo:GetDamage())
		npc:SetNWInt("Health", npc:Health())
		dmginfo:SetDamage(0)
	end
	
	function GM:ScalePlayerDamage(ply, hitgroup, dmginfo)
		local npcAttacker = dmginfo:GetAttacker()
		local clrDisplayColor = "red"
		local intplyLevel = LocalPlayer():GetLevel()
		local tblNPCTable = NPCTable(npcAttacker:GetNWString("npc"))
		local boolInvincible = tblNPCTable && (tblNPCTable.Invincible)
		if npcAttacker:IsNPC() && (!tblNPCTable or !boolInvincible) then
		dmginfo:SetDamage(math.Round(dmginfo:GetDamage() * (1 / intplyLevel)))
			if math.random(1, 20) == 1 then
				dmginfo:SetDamage(math.Round(dmginfo:GetDamage() * 2))
				ply:CreateIndacator("Crit!", dmginfo:GetDamagePosition(), "blue")
				clrDisplayColor = "blue"
			end
			if npcAttacker.Damage then
				dmginfo:SetDamage(dmginfo:GetDamage() + npcAttacker.Damage)
			end
			dmginfo:SetDamage(math.Round(dmginfo:GetDamage() + math.random(-1, 1)))
			if dmginfo:GetDamage() > 0 && dmginfo:GetDamage() < 9990 then
				ply:CreateIndacator(dmginfo:GetDamage(), dmginfo:GetDamagePosition(), clrDisplayColor)
			elseif dmginfo:GetDamage() <= 0 then
				ply:CreateIndacator("Miss!", dmginfo:GetDamagePosition(), "orange")
			end
		end
		if tblNPCTable && boolInvincible then dmginfo:SetDamage(0) end
		dmginfo:SetDamage(math.Clamp(math.Round(dmginfo:GetDamage()), 0, 9999))
		ply:SetHealth(ply:Health() - dmginfo:GetDamage())
		dmginfo:SetDamage(0)
	end
end