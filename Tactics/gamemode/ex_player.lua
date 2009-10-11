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
	
	ply:Give("weapon_pistol")
	ply:Give("weapon_smg1")
end

function Player:GiveCash(intAmount)
	if self:GetNWInt("cash") + intAmount >= 0 then 
		self:SetNWInt("cash", self:GetNWInt("cash") + intAmount)
		return true
	else
		return false
	end
end

function SwitchWeapon(plyTarget, strWeapon)
	plyTarget:SelectWeapon(strWeapon)
end
concommand.Add("FS_SwitchWep", function(ply, command, args) SwitchWeapon(ply, tostring(args[1])) end)

 
function GM:PlayerShouldTakeDamage( victim, attacker )
	if victim == attacker then return true end
	if attacker:IsPlayer() && victim:IsPlayer() then
		if victim:GetNWBool("PvpFlag") != true || attacker:GetNWBool("PvpFlag") != true then return false end
	end
	return true
end
