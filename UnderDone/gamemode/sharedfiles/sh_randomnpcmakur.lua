local tblSpawnPoints = {}
tblSpawnPoints[1] = {}
tblSpawnPoints[1].NPC = "zombie"
tblSpawnPoints[1].SpawnPoint = Vector(819, 61, 141)
tblSpawnPoints[1].Level = 5
tblSpawnPoints[1].SpawnTime = 10

tblSpawnPoints[2].NPC = "npc_antlionguard"
tblSpawnPoints[2].Boss = true
tblSpawnPoints[2].SpawnPoint = Vector(1374, 3917, 110)
tblSpawnPoints[2].Level = 5
tblSpawnPoints[2].SpawnTime = 10

if SERVER then
	numerozombies = 0
	numeroboss = 0
	function GM:Initialize()
		timer.Simple(10, function() GAMEMODE:GenerateBoss() end)
	end

	function GenerateMonster()
		for _, Spawn in pairs(tblSpawnPoints) do
			if !Spawn.Monster or !Spawn.Monster:IsValid() then
				if !Spawn.NextSpawn then Spawn.NextSpawn = CurTime() + Spawn.SpawnTime end
				if CurTime() >= Spawn.NextSpawn then
					local tblNPCTable = GAMEMODE.DataBase.NPCs[Spawn.NPC]
					local entNewMonster = ents.Create(tblNPCTable.SpawnName)
					entNewMonster:SetPos(Spawn.SpawnPoint)
					entNewMonster:Spawn()
					entNewMonster:SetNWInt("level", Spawn.Level)
					local intHealth = Spawn.Level * tblNPCTable.HealthPerLevel
					entNewMonster:SetMaxHealth(intHealth)
					entNewMonster:SetHealth(intHealth)
					entNewMonster:SetNWInt("Health", intHealth)
					entNewMonster:SetNWInt("MaxHealth", intHealth)
					entNewMonster.SpawnTime = Spawn.SpawnTime
					Spawn.Monster = entNewMonster
					Spawn.NextSpawn = nil
				end
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