if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= true
	SWEP.HoldType			= "melee"
end
if (CLIENT) then
	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= true
	SWEP.ViewModelFOV		= 64
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= false
	SWEP.PrintName			= "Suicide by Explosion"			
	SWEP.Author				= "Noobulator"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 11
end
SWEP.Author			= "Noobulator"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= "Aim away from face"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_c4.mdl"
SWEP.WorldModel			= "models/weapons/w_c4.mdl"

SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= -1
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.Delay			= 1.12

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "bombs"

SWEP.Secondary.Recoil		= 0
SWEP.Secondary.Damage		= -1
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.Delay		= 0.1
SWEP.Secondary.NextFire 	= 0

SWEP.Secondary.ClipSize		= 1
SWEP.Secondary.DefaultClip	= 1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

function SWEP:Initialize()
	if (SERVER) then
		self:SetWeaponHoldType(self.HoldType)
	end
end

function SWEP:Deploy()
end

function SWEP:Reload()
end

function SWEP:Think()
end
	
function SWEP:PrimaryAttack()
	self:TakePrimaryAmmo(1)
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	timer.Simple(self.Primary.Delay,function() self:ExplodeBomb() end)
end

function SWEP:SecondaryAttack()
end

function SWEP:Holster()
	return true
end

function SWEP:OnRemove()
	return true
end

function SWEP:ExplodeBomb()
	local explode = ents.Create("env_explosion")
	explode:SetPos(self:GetOwner():GetPos())
	explode:SetOwner(self.Owner)
	explode:Spawn()
	explode:SetKeyValue("iMagnitude","150")
	explode:Fire("Explode",0,0)
	explode:EmitSound("weapon_AWP.Single",400,400)
end