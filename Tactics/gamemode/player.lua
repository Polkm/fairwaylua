function GM:PlayerInitialSpawn(ply)
	ply:SetNWBool("PvpFlag", false)
	ply.Locker = {}
	ply.Locker[0] = {
		Weapon = "none",
	}
	ply.Locker[1337] = {
		Weapon = "weapon_crowbar",
	}
	ply:AddWeaponToLocker("weapon_mp5_tx")
	ply:AddWeaponToLocker("weapon_p220_tx")
	ply:SelectWeapon(ply.Locker[1].Weapon)
	ply:SetNWInt("ActiveWeapon", 1)
	ply:SetNWInt("Weapon1", 1)
	ply:SetNWInt("Weapon2", 2)
end

function GM:PlayerLoadout(ply)
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
	ply.CanUse = true
	for k, weapon in pairs(ply.Locker) do
		if k != 0 then
			ply:Give(weapon.Weapon)
		end
	end
	ply:SelectWeapon(ply.Locker[ply:GetNWInt("ActiveWeapon")].Weapon)
	for _, weapon in pairs(ply:GetWeapons()) do
		if tostring(weapon:GetClass()) == "weapon_crowbar" then break end
		ply:GiveAmmo(AmmoTypes[weapon:GetPrimaryAmmoType()]["full"], weapon:GetPrimaryAmmoType())
	end
	PrintTable(ply.Locker)
	SendDataToAClient(ply) 
end

function GM:PlayerShouldTakeDamage(victim, attacker)
	if victim == attacker then return true end
	if attacker:IsPlayer() && victim:IsPlayer() then
		if victim:GetNWBool("PvpFlag") != true || attacker:GetNWBool("PvpFlag") != true then return false end
	end
	return true
end

function GM:PlayerUse(ply, ent)
	if !ply.CanUse then return end
	if ply:GetNWBool("LockerZone") then
		ply:ConCommand("tx_Locker")
	end
	ply.CanUse = false
	timer.Simple(0.3, function() ply.CanUse = true end)
	return true
end
