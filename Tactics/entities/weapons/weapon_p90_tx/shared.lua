if (CLIENT) then
	SWEP.PrintName			= "Fabrique Nationale P90"
	SWEP.Slot				= 5
	SWEP.SlotPos			= 0
	SWEP.IconLetter			= "m"
	SWEP.DrawAmmo 			= true
	SWEP.DrawCrosshair 		= false
	SWEP.CSMuzzleFlashes 	= true
	SWEP.SwayScale			= 1.0
	SWEP.BobScale			= 1.0
	killicon.AddFont("weapon_p90","CSKillIcons",SWEP.IconLetter,Color(255,80,0,255))
end
if (SERVER) then
AddCSLuaFile("shared.lua")
SWEP.HoldType 			= "smg"
end

SWEP.Base				= "weapon_basegun_tx"

SWEP.ViewModelFOV		= 62
SWEP.ViewModelFlip		= true
SWEP.ViewModel			= "models/weapons/v_smg_pre.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_p90.mdl"


SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("weapons/Pre/p90-01.wav")
SWEP.Primary.Recoil			= 0.4
SWEP.Primary.Delay			= 0.04
SWEP.Primary.Damage			= 12
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.1
SWEP.Primary.ClipSize		= 50
SWEP.Primary.DefaultClip	= 50
SWEP.Primary.Automatic		= true 
SWEP.Primary.Ammo			= "smg1"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Item = "item_p90"

