SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_pistol.mdl"
SWEP.WorldModel		= "models/weapons/w_357.mdl"
SWEP.AnimPrefix		= "python"

SWEP.HoldType 		= "pistol"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.ReloadSpeed 			= 1

SWEP.Primary.Recoil			= 0.8
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.07
SWEP.Primary.ClipSize		= 30
SWEP.Primary.Delay			= 0.1 
SWEP.Primary.DefaultClip	= 60
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Sound			= Sound("Weapon_MP5Navy.Single")

SWEP.Primary.ClipSize		= 8					// Size of a clip
SWEP.Primary.DefaultClip	= 32				// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "Pistol"

SWEP.Secondary.ClipSize		= 8					// Size of a clip
SWEP.Secondary.DefaultClip	= 32				// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo			= "Pistol"

SWEP.NextSecondaryAttack = 0

ReloadTable = {}
ReloadTable["pistol"] = "reloadpistol"
ReloadTable["ar2"] = "reload_ar2"
ReloadTable["shotgun"] = "reload_shotgun"
ReloadTable["smg1"] = "reload_smg1"

function SWEP:Initialize()
    if SERVER then
		self:SetWeaponHoldType(self.HoldType)
	end
end

function SWEP:Precache() end

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack() then return end
	self.Weapon:EmitSound(self.Primary.Sound, 100, 100)
	self:TacticsShootBullet(self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone)
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:TakePrimaryAmmo(1)
 	if (SinglePlayer() && SERVER) || CLIENT then 
 		self.Weapon:SetNetworkedFloat("LastShootTime",CurTime()) 
 	end 
end

function SWEP:SecondaryAttack()
	if !self:CanSecondaryAttack() then return end
	if self.NextSecondaryAttack > CurTime() then return end
	self.NextSecondaryAttack = CurTime() + 4
	--[[
	self:GetOwner():RestartGesture(ACT_ITEM_DROP)
	local vecNadePos = self.Owner:EyePos() + (self.Owner:GetAimVector() * 14)
	local intNadeDur = 3
	local entNade = ents.Create("npc_grenade_frag")
	timer.Simple(1, function()
		entNade:SetOwner(self.Owner)
		entNade:Fire("SetTimer", intNadeDur)
		entNade:SetPos(vecNadePos)
		entNade:SetAngles(self.Owner:EyeAngles())
		entNade:Spawn()
		local phys = entNade:GetPhysicsObject()
		phys:ApplyForceCenter(self.Owner:GetAimVector():GetNormalized() * 450)
	end)]]
end

function SWEP:Think()

end

function SWEP:OnRestore()
	self.NextSecondaryAttack = 0
end

function SWEP:CheckReload() end

function SWEP:Reload()
	if self:GetNWBool("reloading") then return end
	if self.Weapon:Clip1() >= self.Primary.ClipSize then return end
	if self.Weapon:Clip1() < self.Primary.ClipSize && self:GetOwner():GetAmmoCount(self.Primary.Ammo) > 0  then
		self:SetNWBool("reloading", true)
		self:DefaultReload(ACT_VM_RELOAD) 
		self:GetOwner():RestartGesture(self:GetOwner():Weapon_TranslateActivity(ACT_HL2MP_GESTURE_RELOAD))
	end
	print(self.ReloadSpeed)
	timer.Simple(self.ReloadSpeed, function() 
		if (self:GetOwner():GetAmmoCount(self.Primary.Ammo) + self.Weapon:Clip1()) >= self.Primary.ClipSize then
			if (SERVER) then
				self:GetOwner():RemoveAmmo(self.Primary.ClipSize - self.Weapon:Clip1()  ,self.Primary.Ammo )
				self.Weapon:SetClip1(self.Primary.ClipSize)
			end
		else
			if (SERVER) then
				self.Weapon:SetClip1(self:GetOwner():GetAmmoCount(self.Primary.Ammo) + self.Weapon:Clip1())
				self:GetOwner():RemoveAmmo(self:GetOwner():GetAmmoCount(self.Primary.Ammo),self.Primary.Ammo)
			end
		end
		self:SetNWBool("reloading",false)
	end)
end

function SWEP:Holster(wep)
	return true
end

function SWEP:Update()
	if ( SERVER ) then
		local pwr = self:GetOwner().Locker[tonumber(self:GetOwner():GetNWInt("ActiveWeapon"))].pwrlvl
		local acc = self:GetOwner().Locker[tonumber(self:GetOwner():GetNWInt("ActiveWeapon"))].acclvl
		local clip = self:GetOwner().Locker[tonumber(self:GetOwner():GetNWInt("ActiveWeapon"))].clplvl
		local speed = self:GetOwner().Locker[tonumber(self:GetOwner():GetNWInt("ActiveWeapon"))].spdlvl
		local res = self:GetOwner().Locker[tonumber(self:GetOwner():GetNWInt("ActiveWeapon"))].reslvl
		self.Primary.Damage = Weapons[self:GetClass()].UpGrades.Power[pwr].Level
		self.Primary.Cone	= Weapons[self:GetClass()].UpGrades.Accuracy[acc].Level
		self.Primary.ClipSize = Weapons[self:GetClass()].UpGrades.ClipSize[clip].Level
		self.Primary.Delay = Weapons[self:GetClass()].UpGrades.FiringSpeed[speed].Level
		self.ReloadSpeed = Weapons[self:GetClass()].UpGrades.ReloadSpeed[res].Level
	end
	if ( CLIENT ) then
		local pwr = Locker[tonumber(self:GetOwner():GetNWInt("ActiveWeapon"))].pwrlvl
		local acc = Locker[tonumber(self:GetOwner():GetNWInt("ActiveWeapon"))].acclvl
		local clip = Locker[tonumber(self:GetOwner():GetNWInt("ActiveWeapon"))].clplvl
		local speed = Locker[tonumber(self:GetOwner():GetNWInt("ActiveWeapon"))].spdlvl
		local res = Locker[tonumber(self:GetOwner():GetNWInt("ActiveWeapon"))].reslvl
		self.Primary.Damage = Weapons[self:GetClass()].UpGrades.Power[pwr].Level
		self.Primary.Cone	= Weapons[self:GetClass()].UpGrades.Accuracy[acc].Level
		self.Primary.ClipSize = Weapons[self:GetClass()].UpGrades.ClipSize[clip].Level
		self.Primary.Delay = Weapons[self:GetClass()].UpGrades.FiringSpeed[speed].Level
		self.ReloadSpeed =  Weapons[self:GetClass()].UpGrades.ReloadSpeed[res].Level
	end
	return true
end

function SWEP:Deploy()
	local intActiveWeaponNumber = tonumber(self:GetOwner():GetNWInt("ActiveWeapon"))
	if intActiveWeaponNumber != 1337 && intActiveWeaponNumber!= 0 then
		if SERVER then
			local pwr = self:GetOwner().Locker[intActiveWeaponNumber].pwrlvl
			local acc = self:GetOwner().Locker[intActiveWeaponNumber].acclvl
			local clip = self:GetOwner().Locker[intActiveWeaponNumber].clplvl
			local speed = self:GetOwner().Locker[intActiveWeaponNumber].spdlvl
			local res = self:GetOwner().Locker[intActiveWeaponNumber].reslvl
			self.Primary.Damage = Weapons[self:GetClass()].UpGrades.Power[pwr].Level
			self.Primary.Cone = Weapons[self:GetClass()].UpGrades.Accuracy[acc].Level
			self.Primary.ClipSize = Weapons[self:GetClass()].UpGrades.ClipSize[clip].Level
			self.Primary.Delay = Weapons[self:GetClass()].UpGrades.FiringSpeed[speed].Level
			self.ReloadSpeed = Weapons[self:GetClass()].UpGrades.ReloadSpeed[res].Level
		end
		if CLIENT then
			local pwr = Locker[intActiveWeaponNumber].pwrlvl
			local acc = Locker[intActiveWeaponNumber].acclvl
			local clip = Locker[intActiveWeaponNumber].clplvl
			local speed = Locker[intActiveWeaponNumber].spdlvl
			local res = Locker[intActiveWeaponNumber].reslvl
			self.Primary.Damage = Weapons[self:GetClass()].UpGrades.Power[pwr].Level
			self.Primary.Cone	= Weapons[self:GetClass()].UpGrades.Accuracy[acc].Level
			self.Primary.ClipSize = Weapons[self:GetClass()].UpGrades.ClipSize[clip].Level
			self.Primary.Delay = Weapons[self:GetClass()].UpGrades.FiringSpeed[speed].Level
			self.ReloadSpeed =  Weapons[self:GetClass()].UpGrades.ReloadSpeed[res].Level
		end
	end
	return true
end

function SWEP:TacticsShootBullet(dmg, numbul, cone)
	if self.Owner:Crouching() then cone = cone * .6 end
	numbul = numbul or 1
	cone = cone or 0.01
	local bullet = {} 
	bullet.Num 		= numbul 
	bullet.Src 		= self.Owner:GetShootPos()
	bullet.Dir 		= self.Owner:GetAimVector()
	bullet.Spread 	= Vector(cone,cone,0)
	bullet.Tracer	= 10
	bullet.Force	= dmg
	bullet.Damage	= dmg
	self.Owner:FireBullets(bullet)
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:GetOwner():RestartGesture(self:GetOwner():Weapon_TranslateActivity(ACT_HL2MP_GESTURE_RANGE_ATTACK))
	self.Owner:MuzzleFlash()
end

function SWEP:TakePrimaryAmmo(num)
	if self.Weapon:Clip1() <= 0 then 
		if self:Ammo1() <= 0 then return end
		self.Owner:RemoveAmmo(num,self.Weapon:GetPrimaryAmmoType())
		return
	end
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
	if self:GetNWBool("reloading") then return false end
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