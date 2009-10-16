AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function SWEP:OnRestore()
end
function SWEP:AcceptInput( name, activator, caller, data )
	return false
end
function SWEP:KeyValue( key, value )
end
function SWEP:OnRemove()
end

function SWEP:Equip( NewOwner )
end
function SWEP:EquipAmmo( NewOwner )
end
function SWEP:OnDrop()
end
function SWEP:ShouldDropOnDie()
	return false
end
function SWEP:GetCapabilities()
	return CAP_WEAPON_RANGE_ATTACK1 | CAP_INNATE_RANGE_ATTACK1
end
function SWEP:NPCShoot_Secondary( ShootPos, ShootDir )
	self:SecondaryAttack()
end
function SWEP:NPCShoot_Primary( ShootPos, ShootDir )
	self:PrimaryAttack()
end

function SWEP:TossWeaponSound()
end

// These tell the NPC how to use the weapon
AccessorFunc( SWEP, "fNPCMinBurst", 		"NPCMinBurst" )
AccessorFunc( SWEP, "fNPCMaxBurst", 		"NPCMaxBurst" )
AccessorFunc( SWEP, "fNPCFireRate", 		"NPCFireRate" )
AccessorFunc( SWEP, "fNPCMinRestTime", 	"NPCMinRest" )
AccessorFunc( SWEP, "fNPCMaxRestTime", 	"NPCMaxRest" )