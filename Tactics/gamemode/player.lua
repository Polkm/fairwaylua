function GM:PlayerInitialSpawn(ply)
	ply:Load()
	ply:SetNWInt("MaxHp", 100)
	ply:SetNWBool("LockerZone", false)
	ply:SetNWBool("PvpFlag", false)
	ply.CanUse = true
	ply.FirstSpawn = true
end
function GM:PlayerSpawn(ply)
	local entViewEntity = ents.Create("prop_dynamic")
	entViewEntity:SetModel("models/error.mdl")
	entViewEntity:Spawn()
	entViewEntity:SetAngles(ply:GetAngles())
	entViewEntity:SetMoveType(MOVETYPE_NONE)
	entViewEntity:SetParent(ply)
	entViewEntity:SetPos(ply:GetPos())
	entViewEntity:SetRenderMode(RENDERMODE_NONE)
	entViewEntity:SetSolid(SOLID_NONE)
	entViewEntity:SetNoDraw(true)
	ply:SetViewEntity(entViewEntity)
	hook.Call("PlayerSetModel", GAMEMODE, ply)
	if ply.FirstSpawn then return end
	hook.Call("PlayerLoadout", GAMEMODE, ply)
end
function GM:PlayerDisconnected(ply)
	ply:Save()
end

function GM:PlayerLoadout(ply)
	GAMEMODE:SetPlayerSpeed(ply, 200, 230)
	for strPerkID, boolActive in pairs(ply.Perks) do
		if boolActive then
			PlayerPerk[strPerkID].Function(ply) 
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
	SendDataToAClient(ply)
	ply.FirstSpawn = false
end

function GM:PlayerShouldTakeDamage(plyVictim, objAttacker)
	if plyVictim == objAttacker then return true end
	if objAttacker:IsPlayer() && plyVictim:IsPlayer() then
		if plyVictim:GetNWBool("PvpFlag") != true || objAttacker:GetNWBool("PvpFlag") != true then return false end
	end
	return true
end

function GM:EntityTakeDamage(entVictim, objInflictor, objAttacker, intAmount, dmginfo)
	if objAttacker:IsPlayer() && objAttacker.Perks["perk_leech"] then
 		dmginfo:ScaleDamage(1.0) 
		objAttacker:GiveHealth(dmginfo:GetDamage() / 20)
	end
	if entVictim:IsPlayer() && entVictim.Perks["perk_leech"] then
 		dmginfo:ScaleDamage(1.3)
	end
end
