if SERVER then
	numerozombies = 0
	function GM:Initialize()
		timer.Simple(5, function() GAMEMODE:GenerateMonster() end)
	end

	function GM:GenerateMonster()
		if numerozombies > 5 then timer.Simple(5, function() GAMEMODE:GenerateMonster() end) return end
		local intaverageLevel = 3
		
		local npcZombie = ents.Create("npc_zombie")
		npcZombie:SetPos(Vector(math.random(-2000, 2000), math.random(-2000, 2000), 40))
		npcZombie:Spawn()
		npcZombie:SetNWInt("level", math.random(1, intaverageLevel + 1))
		npcZombie:SetMaxHealth(npcZombie:GetNWInt("level") * 10)
		npcZombie:SetHealth(npcZombie:GetNWInt("level") * 10)
		--npcZombie:SetModel("models/Zombie/Fast.mdl")
		
		timer.Simple(5, function() GAMEMODE:GenerateMonster() end)
		numerozombies = numerozombies + 1
	end

	function GM:OnNPCKilled(npc, killer, weapon)
		if npc:GetNWInt("level") > 0 && killer:IsPlayer() then
			local intPlayerLevel = toLevel(killer:GetNWInt("exp"))
			local intNPCLevel = npc:GetNWInt("level")
			local intExptoGive = math.Round(10 * (intNPCLevel / intPlayerLevel))
			killer:CreateIndacator("+_" .. intExptoGive .. "_Exp", killer:GetPos(), "green")
			killer:GiveExp(intExptoGive)
		end
		if npc:GetClass() == "npc_zombie" then
			numerozombies = numerozombies - 1
		end
	end

	function GM:ScaleNPCDamage(npc, hitgroup, dmginfo)
		local plyAttacker = dmginfo:GetAttacker()
		if plyAttacker:IsPlayer() then
			dmginfo:ScaleDamage(1)
			dmginfo:SetDamage(math.Round(dmginfo:GetDamage() + math.random(-1, 1)))
			local intPlayerLevel = toLevel(plyAttacker:GetNWInt("exp"))
			local intNPCLevel = npc:GetNWInt("level")
			dmginfo:SetDamage(math.Round(dmginfo:GetDamage() * (intPlayerLevel / intNPCLevel)))
			if dmginfo:GetDamage() > 0 then
				plyAttacker:CreateIndacator(dmginfo:GetDamage(), dmginfo:GetDamagePosition())
			end
			if npc:GetClass() == "npc_headcrab" then
				dmginfo:SetDamage(9999)
			end
		end
	end
end