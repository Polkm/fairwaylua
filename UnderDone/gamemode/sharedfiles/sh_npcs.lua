local NPC = {}
NPC.Name = "zombie"
NPC.PrintName = "Zombie"
NPC.SpawnName = "npc_zombie"
NPC.HealthPerLevel = 10
NPC.Relation = GAMEMODE.RelationLike
NPC.Race = "zombie"
Register.NPC(NPC)

local NPC = {}
NPC.Name = "antlion"
NPC.PrintName = "Antlion"
NPC.SpawnName = "npc_antlion"
NPC.HealthPerLevel = 11
NPC.Relation = GAMEMODE.RelationHate
NPC.Race = "antlion"
Register.NPC(NPC)

local NPC = {}
NPC.Name = "antlionguard"
NPC.PrintName = "Antlion Boss"
NPC.SpawnName = "npc_antlionguard"
NPC.HealthPerLevel = 13
NPC.Relation = GAMEMODE.RelationHate
NPC.Race = "antlion"
Register.NPC(NPC)

local NPC = {}
NPC.Name = "combine"
NPC.PrintName = "Combine Guard"
NPC.SpawnName = "npc_combine_s"
NPC.HealthPerLevel = 1000
NPC.Relation = GAMEMODE.RelationLike
NPC.Race = "combine"
Register.NPC(NPC)

if SERVER then
	function GM:PlayerDeath( victim, weapon, killer )
		if killer:IsNPC( ) && victim:IsPlayer() then
			if killer.Relation == GAMEMODE.RelationLike then
				killer:AddEntityRelationship(victim, GAMEMODE.RelationLike, 99)
				killer:SetNPCState( NPC_STATE_IDLE )
				for _, ent in pairs(ents.GetAll()) do
					if ent && ent:IsNPC() then
						if ent.Relation == killer.Relation then
							ent:SetNPCState( NPC_STATE_IDLE )
							ent:AddEntityRelationship(victim, GAMEMODE.RelationLike, 99)
						end
					end
				end
			end
		end
	end
		
	function GM:OnNPCKilled(npc, killer, weapon)
		if npc:GetNWInt("level") > 0 && killer:IsPlayer() then
			local intPlayerLevel = toLevel(killer:GetNWInt("exp"))
			local intNPCLevel = npc:GetNWInt("level")
			local intExptoGive =  math.Round((npc:GetMaxHealth() * (intNPCLevel / intPlayerLevel)) / 5)
			killer:CreateIndacator("+_" .. intExptoGive .. "_Exp", killer:GetPos() + Vector(0, 0, 70), "green")
			killer:GiveExp(intExptoGive)
		end
	end

	function GM:ScaleNPCDamage(npc, hitgroup, dmginfo)
		local plyAttacker = dmginfo:GetAttacker()
		if plyAttacker:IsPlayer() then
			local clrDisplayColor = "white"
			local intPlayerLevel = plyAttacker:GetLevel()
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
			if dmginfo:GetDamage() > 0 && dmginfo:GetDamage() < 990 then
				for _, ent in pairs(ents.GetAll()) do
					if ent && ent:IsNPC() then
						if ent.Relation == npc.Relation then
							ent:AddEntityRelationship(plyAttacker, GAMEMODE.RelationHate, 99)
						end
					end
				end
				plyAttacker:CreateIndacator(dmginfo:GetDamage(), dmginfo:GetDamagePosition(), clrDisplayColor)
				npc:AddEntityRelationship(plyAttacker, GAMEMODE.RelationHate, 99)
			elseif dmginfo:GetDamage() <= 0 then
				plyAttacker:CreateIndacator("Miss!", dmginfo:GetDamagePosition(), "orange")
			end
		end
		dmginfo:SetDamage(math.Clamp(math.Round(dmginfo:GetDamage()), 0, 999))
		npc:SetHealth(npc:Health() - dmginfo:GetDamage())
		npc:SetNWInt("Health", npc:Health())
		dmginfo:SetDamage(0)
	end
end