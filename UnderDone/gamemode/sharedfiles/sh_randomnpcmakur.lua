if SERVER then
	numerozombies = 0
	numeroboss = 0
	function GM:Initialize()
		timer.Simple(5, function() GAMEMODE:GenerateMonster() end)
		timer.Simple(10, function() GAMEMODE:GenerateBoss() end)
	end

	function GM:GenerateMonster()
		if numerozombies > 5 then timer.Simple(5, function() GAMEMODE:GenerateMonster() end) return end
		local intaverageLevel = 1
		for _, ply in pairs(player.GetAll()) do
			intaverageLevel = intaverageLevel + ply:GetLevel()
		end
		intaverageLevel = intaverageLevel / #player.GetAll()
		
		local npcZombie = ents.Create("npc_zombie")
		npcZombie:SetPos(Vector(math.random(-2000, 2000), math.random(-2000, 2000), 40))
		npcZombie:Spawn()
		npcZombie:SetNWInt("level", math.random(math.Clamp(intaverageLevel - 5, 1), intaverageLevel + 2))
		npcZombie:SetMaxHealth(npcZombie:GetNWInt("level") * 10)
		npcZombie:SetHealth(npcZombie:GetNWInt("level") * 10)
		npcZombie:SetNWInt("Health", npcZombie:Health())
		
		timer.Simple(5, function() GAMEMODE:GenerateMonster() end)
		numerozombies = numerozombies + 1
	end
	
	function GM:GenerateBoss()
		if numeroboss > 0 then timer.Simple(10, function() GAMEMODE:GenerateBoss() end) return end
		local npcantlionguard = ents.Create("npc_antlionguard")
		npcantlionguard:SetPos(Vector(math.random(-6000, 6000), math.random(-6000, 6000), 40))
		npcantlionguard:Spawn()
		npcantlionguard:SetNWInt("level", math.random(5, 10))
		npcantlionguard:SetMaxHealth(npcantlionguard:GetNWInt("level") * 10)
		npcantlionguard:SetHealth(npcantlionguard:GetNWInt("level") * 10)
		npcantlionguard:SetNWInt("Health", npcantlionguard:Health())
		
		timer.Simple(10, function() GAMEMODE:GenerateBoss() end)
		numeroboss = numeroboss + 1
	end

	function GM:OnNPCKilled(npc, killer, weapon)
		if npc:GetNWInt("level") > 0 && killer:IsPlayer() then
			local intPlayerLevel = toLevel(killer:GetNWInt("exp"))
			local intNPCLevel = npc:GetNWInt("level")
			local intExptoGive =  math.Round((npc:GetMaxHealth() * (intNPCLevel / intPlayerLevel)) / 2)
			killer:CreateIndacator("+_" .. intExptoGive .. "_Exp", killer:GetPos(), "green")
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
			dmginfo:ScaleDamage(1)
			dmginfo:SetDamage(math.Round(dmginfo:GetDamage() + math.random(-1, 1)))
			local intPlayerLevel = plyAttacker:GetLevel()
			local intNPCLevel = npc:GetNWInt("level")
			dmginfo:SetDamage(math.Round(dmginfo:GetDamage() * (intPlayerLevel / intNPCLevel)))
			if dmginfo:GetDamage() > 0 then
				npc:SetNWInt("Health",npc:Health() - dmginfo:GetDamage() )
				plyAttacker:CreateIndacator(dmginfo:GetDamage(), dmginfo:GetDamagePosition())
			elseif dmginfo:GetDamage() <= 0 then
				plyAttacker:CreateIndacator("Miss!", dmginfo:GetDamagePosition(), "orange")
			end
			if npc:GetClass() == "npc_headcrab" then
				dmginfo:SetDamage(999)
			end
		end
	end
end