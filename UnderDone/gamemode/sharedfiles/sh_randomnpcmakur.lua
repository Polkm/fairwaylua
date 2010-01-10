local Spawn ={}

Spawn[1] = {}
Spawn[1].Entity = "npc_zombie"
Spawn[1].SpawnPoint = Vector(819, 61, 141)
Spawn[1].Level = 5
Spawn[1].Health = 50
Spawn[1].MaxHealth = 50
Spawn[1].SpawnTime = 10

if SERVER then
	numerozombies = 0
	numeroboss = 0
	function GM:Initialize()
		timer.Simple(10, function() GAMEMODE:GenerateBoss() end)
	end

	function GenerateMonster()
		for k,v in pairs(Spawn) do
			if (!Spawn[k].NextSpawn) then Spawn[k].NextSpawn = CurTime() end
			if (CurTime() > Spawn[k].NextSpawn) then
				local MonsterNPC = ents.Create(Spawn[k].Entity)
				MonsterNPC:SetPos(Spawn[k].SpawnPoint)
				MonsterNPC:Spawn()
				MonsterNPC:SetNWInt("level", Spawn[k].Level)
				MonsterNPC:SetMaxHealth(Spawn[k].MaxHealth)
				MonsterNPC:SetHealth(Spawn[k].Health)
				MonsterNPC:SetNWInt("Health", Spawn[k].Health)
				MonsterNPC.SpawnTime = Spawn[k].SpawnTime
				Spawn[k].NextSpawn = CurTime() + Spawn[k].SpawnTime
			end
		end
	end
	hook.Add("Tick", "GenerateMonster", GenerateMonster)

	function GM:GenerateBoss()
		if numeroboss > 0 then timer.Simple(10, function() GAMEMODE:GenerateBoss() end) return end
		local npcantlionguard = ents.Create("npc_antlionguard")
		npcantlionguard:SetPos(Vector(math.random(-6000, 6000), math.random(-6000, 6000), 40))
		npcantlionguard:Spawn()
		npcantlionguard:SetNWInt("level", math.random(5, 10))
		npcantlionguard:SetMaxHealth(npcantlionguard:GetNWInt("level") * 13 + math.random(-2, 2))
		npcantlionguard:SetHealth(npcantlionguard:GetNWInt("level") * 13 + math.random(-2, 2))
		npcantlionguard:SetNWInt("Health", npcantlionguard:Health())
		
		timer.Simple(10, function() GAMEMODE:GenerateBoss() end)
		numeroboss = numeroboss + 1
	end

	function GM:OnNPCKilled(npc, killer, weapon)
		if npc:GetNWInt("level") > 0 && killer:IsPlayer() then
			local intPlayerLevel = toLevel(killer:GetNWInt("exp"))
			local intNPCLevel = npc:GetNWInt("level")
			local intExptoGive =  math.Round((npc:GetMaxHealth() * (intNPCLevel / intPlayerLevel)) / 5)
			killer:CreateIndacator("+_" .. intExptoGive .. "_Exp", killer:GetPos() + Vector(0, 0, 70), "green")
			killer:GiveExp(intExptoGive)
		end
		if npc:GetClass() == "npc_zombie" then
			numerozombies = numerozombies - 1
		end
		if npc:GetClass() == "npc_antlionguard" then
			numeroboss = numeroboss - 1
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
				plyAttacker:CreateIndacator(dmginfo:GetDamage(), dmginfo:GetDamagePosition(), clrDisplayColor)
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