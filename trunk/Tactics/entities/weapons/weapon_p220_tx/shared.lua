if (CLIENT) then
	SWEP.PrintName			= "Sauer P228"
	SWEP.Slot				= 1
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "y"
	SWEP.DrawAmmo 			= true
	SWEP.DrawCrosshair 		= false	
	SWEP.CSMuzzleFlashes 	= true
	SWEP.SwayScale			= 1.0
	SWEP.BobScale			= 1.0
	killicon.AddFont("weapon_p228","CSKillIcons",SWEP.IconLetter,Color(255,80,0,255))
end
if (SERVER) then
	AddCSLuaFile("shared.lua")
end

SWEP.Base				= "weapon_basegun_tx"

SWEP.ViewModelFOV		= 62
SWEP.ViewModelFlip		= true
SWEP.ViewModel = 		"models/weapons/v_pist_p220.mdl"
SWEP.WorldModel = 		"models/weapons/w_pist_p228.mdl"
SWEP.HoldType 			= "pistol"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("weapons/p228/p228-1.wav")
SWEP.Primary.Recoil			= 0.6
SWEP.Primary.Damage			= 10
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.ClipSize		= 13
SWEP.Primary.Delay			= 0.08
SWEP.Primary.DefaultClip	= 13 //Always set this 1 higher than what you want.
SWEP.Primary.Automatic		= false 
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
