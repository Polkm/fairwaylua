if (CLIENT) then
	SWEP.PrintName			= "Leone 12 Gauge Super"
	SWEP.Slot				= 4
	SWEP.SlotPos			= 0
	SWEP.DrawAmmo 			= true
	SWEP.DrawCrosshair 		= false
	SWEP.IconLetter			= "B"
 	killicon.AddFont( "weapon_pumpshotgun", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
end
if (SERVER) then
	AddCSLuaFile("shared.lua")
SWEP.HoldType 			= "shotgun"
end

SWEP.Base				= "weapon_basegun_tx"

SWEP.ViewModelFOV		= 62
SWEP.ViewModelFlip		= true
SWEP.ViewModel 			= "models/weapons/v_shot_mossberg5.mdl"
SWEP.WorldModel 		= "models/weapons/w_shot_mossberg5.mdl"


SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("weapons/mossberg590/m3-01.wav")
SWEP.Primary.Recoil			= 5
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 8
SWEP.Primary.Cone			= 0.2
SWEP.Primary.ClipSize		= 6
SWEP.Primary.DefaultClip	= 6
SWEP.Primary.Delay			= 1.3
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "buckshot"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.ReloadSpeed = 1

function SWEP:Reload() 
	if self.Weapon:GetNetworkedBool("reloading") then return end 
	if self.Weapon:Clip1() < self.Primary.ClipSize && self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then 
		self.Weapon:SetNetworkedBool("reloading",true) 
		self.Weapon:SetVar("reloadtimer",CurTime() + 0.3) 
		self.Weapon:SendWeaponAnim(ACT_VM_RELOAD) 
	end 
	
	self:SetIronsights(false);
end 

function SWEP:Think() 
	if self.Weapon:GetNetworkedBool("reloading") then 
		if self.Weapon:GetVar("reloadtimer",0) < CurTime() then 
			if self.Weapon:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then 
				self.Weapon:SetNetworkedBool("reloading",false) 
				return 
			end 
			self.Weapon:SetVar("reloadtimer",CurTime() + 0.3) 
			self.Weapon:SendWeaponAnim(ACT_VM_RELOAD) 
			self.Owner:RemoveAmmo(1, self.Primary.Ammo,false) 
			self.Weapon:SetClip1(self.Weapon:Clip1() + 1) 
			if self.Weapon:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 && self.Weapon:GetVar("reloadtimer",0) < CurTime() then 
				self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH) 
				self.Weapon:SetVar("reloadtimer",CurTime() + 0.2) 
				self:EmitSound('weapons/m3/Shotgun_pump.wav');
			else
				self:EmitSound('weapons/m3/Shotgun_insertshell.wav');
			end
		end
	end
end

function SWEP:CanPrimaryAttack()
	if self.Weapon:GetNetworkedBool("reloading") then return end 
	if self.Weapon:Clip1() <= 0 then
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextPrimaryFire(CurTime() + 0.2)
		self:Reload()
		return false
	end
	
	timer.Simple(.5, self.EmitSound, self, 'weapons/m3/Shotgun_pump.wav');
	return true
end

SWEP.IronSightsPos = Vector (5.7287, -0.733, 3.3187)
SWEP.IronSightsAng = Vector (0, 0, 0)
