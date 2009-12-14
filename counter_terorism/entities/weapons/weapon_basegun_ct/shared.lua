SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_pistol.mdl"
SWEP.WorldModel		= "models/weapons/w_357.mdl"
SWEP.AnimPrefix		= "python"

SWEP.Threat = 0

SWEP.HoldType 			= "pistol"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Primary.ClipSize		= 8					// Size of a clip
SWEP.Primary.DefaultClip	= 32				// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "Pistol"

SWEP.Secondary.ClipSize		= 8					// Size of a clip
SWEP.Secondary.DefaultClip	= 32				// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo			= "Pistol"

SWEP.LastBeacon = "lol"

function SWEP:Initialize()
    if SERVER then self:SetWeaponHoldType(self.HoldType) end
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
end
function SWEP:Precache()
end
function SWEP:PrimaryAttack()
	if (!self:CanPrimaryAttack()) then return end
	self.Weapon:TossWeaponSound()
	if SERVER then
		if self.LastBeacon == "lol"  then
			local beacon = ents.Create("beacon_small")
			beacon:SetPos(self:GetOwner():GetPos()) 
			beacon:Spawn()
			self.LastBeacon = beacon
			print("maid")
		elseif self.LastBeacon:IsValid() && self.LastBeacon:GetPos():Distance(self:GetOwner():GetPos()) >= 400 then
			local beacon = ents.Create("beacon_small")
			beacon:SetPos(self:GetOwner():GetPos()) 
			beacon:Spawn()
			self.LastBeacon = beacon
			print("maid")
		end
		self:CSShootBullet(self.Primary.Damage,self.Primary.Recoil,self.Primary.NumShots,self.Primary.Cone)
	end
	self.Owner:ViewPunch(Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil,math.Rand(-0.1,0.1) *self.Primary.Recoil,0)) 
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:TakePrimaryAmmo(1)
 	if (SinglePlayer() && SERVER) || CLIENT then 
 		self.Weapon:SetNetworkedFloat("LastShootTime",CurTime()) 
 	end 
end

function SWEP:SetIronsights( b )
	self.Weapon:SetNetworkedBool( "Ironsights", b )
end

SWEP.NextSecondaryAttack = 0

function SWEP:SecondaryAttack()

	if ( !self.IronSightsPos ) then return end
	if ( self.NextSecondaryAttack > CurTime() ) then return end
	
	bIronsights = !self.Weapon:GetNetworkedBool( "Ironsights", false )
	
	self:SetIronsights( bIronsights )
	
	self.NextSecondaryAttack = CurTime() + 0.3
	
end

function SWEP:OnRestore()

	self.NextSecondaryAttack = 0
	self:SetIronsights( false )
	
end

function SWEP:CheckReload()
end

function SWEP:Reload()
	if self.Weapon:Clip1() >= self.Primary.ClipSize  then  return end
		self.Weapon:DefaultReload(ACT_VM_RELOAD)
		
			self:SetIronsights( false )
end
function SWEP:Think()
end
function SWEP:Holster(wep)
	self:SetIronsights( false )
	return true
end

function SWEP:Deploy()
	self:SetIronsights( false )
	self.Weapon:DefaultReload(ACT_VM_DRAW)
	return true
end

function SWEP:CSShootBullet(dmg,recoil,numbul,cone)
	if self.Owner:Crouching() then cone = cone*.6 end
	if !self.Owner:OnGround() then cone = cone*1.3 end
	numbul = numbul or 1 
	cone = cone or 0.01 
	local bullet = {} 
	bullet.Num 		= numbul 
	bullet.Src 		= self.Owner:GetShootPos()
	bullet.Dir 		= self.Owner:GetAimVector()
	bullet.Spread 	= Vector(cone,cone,0)
	bullet.Tracer	= 1
	bullet.Force	= 5
	bullet.Damage	= dmg 
	self.Owner:FireBullets(bullet) 
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:MuzzleFlash()
	if self.Owner:IsNPC() then return end 
	if (SinglePlayer() && SERVER) || (!SinglePlayer() && CLIENT) then 
		local eyeang = self.Owner:EyeAngles() 
		eyeang.pitch = eyeang.pitch - recoil 
		self.Owner:SetEyeAngles(eyeang) 
	end 
end

function SWEP:TakePrimaryAmmo(num)
	if self.Weapon:Clip1() <= 0 then 
		if self:Ammo1() <= 0 then return end
		self.Owner:RemoveAmmo(num,self.Weapon:GetPrimaryAmmoType())
	return end
	self.Weapon:SetClip1(self.Weapon:Clip1() - num)	
end
function SWEP:TakeSecondaryAmmo(num)
	if self.Weapon:Clip2() <= 0 then 
		if self:Ammo2() <= 0 then return end
		self.Owner:RemoveAmmo(num,self.Weapon:GetSecondaryAmmoType())
	return end
	self.Weapon:SetClip2(self.Weapon:Clip2() - num)	
end

function SWEP:CanPrimaryAttack()
	if self.Weapon:Clip1() <= 0 then
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextPrimaryFire(CurTime() + 0.2)
		self:Reload()
		return false
	end
	return true
end

function SWEP:CanSecondaryAttack()
	if self.Weapon:GetNetworkedBool("reloading") then return end 

	return true
end

function SWEP:ContextScreenClick(aimvec,mousecode,pressed,ply)
end
function SWEP:OnRemove()
end
function SWEP:OwnerChanged()
end
function SWEP:Ammo1()
	return self.Owner:GetAmmoCount(self.Weapon:GetPrimaryAmmoType())
end
function SWEP:Ammo2()
	return self.Owner:GetAmmoCount(self.Weapon:GetSecondaryAmmoType())
end
function SWEP:SetDeploySpeed(speed)
	self.m_WeaponDeploySpeed = tonumber(speed)
end