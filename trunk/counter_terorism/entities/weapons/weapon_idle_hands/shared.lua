
if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= true
end

if ( CLIENT ) then
	SWEP.ViewModelFOV		= 75
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= false
	SWEP.Slot				= 4
	SWEP.SlotPos			= 4

	SWEP.PrintName			= "Idle"			
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false

end


SWEP.Weight = 5;
SWEP.AutoSwitchTo = true;
SWEP.AutoSwitchFrom = true; 
SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.Primary.Recoil			= 4.6
SWEP.Primary.Damage			= 10
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.Delay			= .7

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.ViewModel = ""
SWEP.WorldModel = "" 

SWEP.Swing = Sound("weapons/knife/knife_slash1.wav")
SWEP.HitSound = Sound("weapons/knife/knife_hitwall1.wav")
SWEP.FleshHit = {"weapons/knife/knife_hit1.wav",
"weapons/knife/knife_hit2.wav",
"weapons/knife/knife_hit3.wav",
"weapons/knife/knife_hit4.wav",
"weapons/knife/knife_stab.wav"}

function SWEP:Initialize()
    if (SERVER) then
		self:SetWeaponHoldType("normal")
	end
	for k,v in pairs(self.FleshHit) do
		util.PrecacheSound(v)
	end
end 

function SWEP:Think()

end

function SWEP:CanPrimaryAttack()
	return true
end


function SWEP:PrimaryAttack()
	
	if not self:CanPrimaryAttack() then return end
	
end
 
function SWEP:SecondaryAttack()

end

