function GM:PlayerInitialSpawn(ply)
	Load(ply)
end


function GM:PlayerLoadout(ply)
	GAMEMODE:SetPlayerSpeed(ply, 200, 230)
	for perk, active in pairs(ply.Perks) do
		if active then
			PlayerPerk[perk].Function(ply) 
		end
	end
	for k, weapon in pairs(ply.Locker) do
		ply:Give(weapon.Weapon)
		ply:GetWeapon(weapon.Weapon):SetNWInt("id", k)
	end
	if ply:GetNWInt("Weapon1") == 0 && ply:GetNWInt("Weapon2") == 0 then
		ply:Give("weapon_crowbar")
		ply:SelectWeapon("weapon_crowbar")
	else
		ply:SelectWeapon(ply.Locker[ply:GetNWInt("ActiveWeapon")].Weapon)
	end
	ply:GiveAmmoAmount("full")
	SendDataToAClient(ply)
	local entity = ents.Create("prop_dynamic")
	entity:SetModel("models/error.mdl")
	entity:Spawn()
	entity:SetAngles(ply:GetAngles())
	entity:SetMoveType(MOVETYPE_NONE)
	entity:SetParent(ply)
	entity:SetPos(ply:GetPos())
	entity:SetRenderMode(RENDERMODE_NONE)
	entity:SetSolid(SOLID_NONE)
	entity:SetNoDraw(true)
	ply:SetViewEntity(entity)
end

function GM:PlayerShouldTakeDamage(victim, attacker)
	if victim == attacker then return true end
	if attacker:IsPlayer() && victim:IsPlayer() then
		if victim:GetNWBool("PvpFlag") != true || attacker:GetNWBool("PvpFlag") != true then return false end
	end
	return true
end

function GM:EntityTakeDamage( ent, inflictor, attacker, amount, dmginfo )
	if attacker:IsPlayer() && attacker.Perks["perk_leech"] then
 		dmginfo:ScaleDamage( 1.0 ) 
		if dmginfo:GetDamage()/20 + attacker:Health() >= attacker:GetNWInt("MaxHp") then
			attacker:SetHealth(attacker:GetNWInt("MaxHp"))
		else
			attacker:SetHealth(math.Round(attacker:Health() + dmginfo:GetDamage()/20))
		end
	end
	if ent:IsPlayer() && ent.Perks["perk_leech"] then
 		dmginfo:ScaleDamage( 1.3 )    		
	end
end
