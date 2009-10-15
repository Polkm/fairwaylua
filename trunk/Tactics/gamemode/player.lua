function GM:PlayerInitialSpawn(ply)
	ply:SetNWBool("PvpFlag", false)
	ply.Locker = {}
	ply:AddWeaponToLocker("weapon_mp5_tx")
	ply:AddWeaponToLocker("weapon_p220_tx")
	ply:SetNWInt("ActiveWeapon", 1)
	ply:SetNWInt("Weapon1", 1)
	ply:SetNWInt("Weapon2", 2)
	ply.Perks = {}
	ply.Perks["perk_ammoup"] = false
end

function GM:PlayerLoadout(ply)
	ply:SetNWInt("MaxHp", 100)
	GAMEMODE:SetPlayerSpeed(ply,200,230)
	for perk, active in pairs(ply.Perks) do
		if active then PlayerPerk[perk].Function(ply) end
	end
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
	for k, weapon in pairs(ply.Locker) do
		ply:Give(weapon.Weapon)
	end
	if ply:GetNWInt("Weapon1") == 0 && ply:GetNWInt("Weapon2") == 0 then
		ply:Give("weapon_crowbar")
		ply:SelectWeapon("weapon_crowbar")
	else
		ply:SelectWeapon(ply.Locker[ply:GetNWInt("ActiveWeapon")].Weapon)
	end
	ply:GiveAmmoAmount("full")
	PrintTable(ply.Locker)
	PrintTable(ply.Perks)
	SendDataToAClient(ply)
end

function GM:PlayerShouldTakeDamage(victim, attacker)
	if victim == attacker then return true end
	if attacker:IsPlayer() && victim:IsPlayer() then
		if victim:GetNWBool("PvpFlag") != true || attacker:GetNWBool("PvpFlag") != true then return false end
	end
	return true
end

