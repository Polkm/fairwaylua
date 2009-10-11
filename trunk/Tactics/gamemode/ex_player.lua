local Player = FindMetaTable("Player")

function GM:PlayerInitialSpawn(ply)
	ply:SetNWBool("PvpFlag", false)
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
	ply.Locker = {}
	ply:AddWeaponToLocker("weapon_pistol")
	ply:AddWeaponToLocker("weapon_smg1")
	ply:SelectWeapon("weapon_pistol")
	ply:SetNWInt("ActiveWeapon", 1)
	ply:SetNWInt("Weapon1", 1)
	ply:SetNWInt("Weapon2", 2)
	PrintTable(ply.Locker)
	SendDataToAClient(ply) 
end

function Player:GiveCash(intAmount)
	if self:GetNWInt("cash") + intAmount >= 0 then 
		self:SetNWInt("cash", self:GetNWInt("cash") + intAmount)
		return true
	else
		return false
	end
end

function Player:AddWeaponToLocker(weapon)
	self:Give(weapon)
	local addtable = {
	Weapon = tostring(weapon),
	pwrlvl = 1,
	acclvl = 1,
	clplvl = 1, 
	spdlvl = 1,
	reslvl = 1,
	CanSilence = false, 
	ChangableFireRate = false, 
	CanGrenade = false, 
	Maxpoints = 15, 
	}
	table.insert(self.Locker, addtable )
end

function SwitchWeapon(plyTarget, strWeapon)
	if plyTarget:GetNWInt("ActiveWeapon") == plyTarget:GetNWInt("Weapon1") then
		plyTarget:SetNWInt("ActiveWeapon",plyTarget:GetNWInt("Weapon2"))
	elseif plyTarget:GetNWInt("ActiveWeapon") == plyTarget:GetNWInt("Weapon2") then
		plyTarget:SetNWInt("ActiveWeapon",plyTarget:GetNWInt("Weapon1"))
	end
	plyTarget:SelectWeapon(plyTarget.Locker[plyTarget:GetNWInt("ActiveWeapon")].Weapon)
end
concommand.Add("FS_SwitchWep", function(ply, command, args) SwitchWeapon(ply, tostring(args[1])) end)

 
function GM:PlayerShouldTakeDamage( victim, attacker )
	if victim == attacker then return true end
	if attacker:IsPlayer() && victim:IsPlayer() then
		if victim:GetNWBool("PvpFlag") != true || attacker:GetNWBool("PvpFlag") != true then return false end
	end
	return true
end


