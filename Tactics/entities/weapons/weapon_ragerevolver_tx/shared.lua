if (CLIENT) then
	SWEP.PrintName			= "Raging Bull Revolver"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 3
	SWEP.IconLetter			= "f"
	SWEP.DrawAmmo 			= true
	SWEP.DrawCrosshair 		= false	
	SWEP.CSMuzzleFlashes 	= true
	SWEP.SwayScale			= 1.0
	SWEP.BobScale			= 1.0
	killicon.AddFont("weapon_deagle","CSKillIcons",SWEP.IconLetter,Color(255,80,0,255))
end
if (SERVER) then
	AddCSLuaFile("shared.lua")
end

SWEP.Base				= "weapon_basegun_tx"

SWEP.ViewModelFOV		= 70
SWEP.ViewModelFlip		= true
SWEP.ViewModel = "models/weapons/v_revl_raging.mdl"
SWEP.WorldModel = "models/weapons/w_revl_raging.mdl"
SWEP.HoldType 			= "pistol"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("weapons/ragingbull/revolver.wav")
SWEP.Primary.Recoil			= 5
SWEP.Primary.Damage			= 30
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.ClipSize		= 6
SWEP.Primary.Delay			= 0.5
SWEP.Primary.DefaultClip	= 6 //Always set this 1 higher than what you want.
SWEP.Primary.Automatic		= false 
SWEP.Primary.Ammo			= "357"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.ReloadSpeed = 1

function SWEP:Reloadhook()
	if self.Weapon:Clip1() >= self.Primary.ClipSize then return end
		if self:GetOwner():GetAmmoCount(self.Primary.Ammo) >= 1 then
			self:EmitSound("weapons/ragingbull/bullreload.wav")
		end
end
hook.Add("Reload","Play Rage Sound",SWEP:Reloadhook())
