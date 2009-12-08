if (CLIENT) then
	SWEP.PrintName			= "Five-Seven"
	SWEP.Slot				= 1
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "c"
	SWEP.DrawAmmo 			= true
	SWEP.DrawCrosshair 		= false	
	SWEP.CSMuzzleFlashes 	= true
	SWEP.SwayScale			= 1.0
	SWEP.BobScale			= 1.0
	killicon.AddFont("weapon_fiveseven_ct","CSKillIcons",SWEP.IconLetter,Color(255,80,0,255))
end
if (SERVER) then
	AddCSLuaFile("shared.lua")
end

SWEP.Base				= "weapon_basegun_ct"

SWEP.ViewModelFOV		= 62
SWEP.ViewModelFlip		= true
SWEP.ViewModel			= "models/weapons/v_pist_fiveseven.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_fiveseven.mdl"
SWEP.HoldType 			= "pistol"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.ThreatLevel = 1

SWEP.Primary.Sound			= Sound("weapons/glockre/glock18-1.wav")
SWEP.Primary.Recoil			= .5
SWEP.Primary.Damage			= 17
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.01
SWEP.Primary.ClipSize		= 20
SWEP.Primary.Delay			= 0.15
SWEP.Primary.DefaultClip	= 20 
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Changing = false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Delay = 0.25
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"


function SWEP:CanPrimaryAttack()
if self.Changing != false then return false end
	if self.Weapon:Clip1() <= 0 then
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextPrimaryFire(CurTime() + 0.2)
		self:Reload()
		return false
	end
	return true
end

