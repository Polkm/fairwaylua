function GM:PlayerInitialSpawn(ply)
	timer.Simple(0.1, HasSteam, ply)
	timer.Create(ply:Nick() .. "AutoSaver", 60, 0, Save, ply)
	ply.CanUse = true
	ply.FirstSpawn = true
end
function HasSteam(ply)
	print(ply:SteamID())
	if ply:SteamID() != "STEAM_ID_PENDING" then
		Load(ply)
	else
		timer.Simple(0.1, HasSteam, ply)
	end
end
function GM:PlayerDisconnected(ply)
	Save(ply)
end
function GM:PlayerSpawn(ply)
	hook.Call("PlayerSetModel", GAMEMODE, ply)
	if ply.FirstSpawn then return end
	hook.Call("PlayerLoadout", GAMEMODE, ply)
end

function GM:PlayerLoadout(ply)
	GAMEMODE:SetPlayerSpeed(ply, 200, 230)
	ply:SetNWInt("MaxHP", 100)
	for perk, active in pairs(ply.Perks) do
		if active then
			PlayerPerk[perk].Function(ply) 
		end
	end
	if ply.Locker[ply:GetNWInt("Weapon1")] then
		ply:Give(ply.Locker[ply:GetNWInt("Weapon1")].Weapon)
		ply:GetWeapon(ply.Locker[ply:GetNWInt("Weapon1")].Weapon):SetNWInt("id",ply:GetNWInt("Weapon1"))
	end
	if ply.Locker[ply:GetNWInt("Weapon2")] then
		ply:Give(ply.Locker[ply:GetNWInt("Weapon2")].Weapon)
		ply:GetWeapon(ply.Locker[ply:GetNWInt("Weapon2")].Weapon):SetNWInt("id", ply:GetNWInt("Weapon2"))
	end
	if ply:GetNWInt("Weapon1") == 0 && ply:GetNWInt("Weapon2") == 0 then
		ply:Give("weapon_crowbar")
		ply:SelectWeapon("weapon_crowbar")
	else
		ply:SelectWeapon(ply.Locker[ply:GetNWInt("ActiveWeapon")].Weapon)
	end
	ply:GiveAmmoAmount("full")
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
	SendDataToAClient(ply)
	ply.FirstSpawn = false
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
