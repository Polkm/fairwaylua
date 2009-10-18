SWEP.WorldModel		= "models/weapons/w_357.mdl"
SWEP.AnimPrefix		= "python"
SWEP.HoldType 		= "pistol"

SWEP.RecievedInfo			= false
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

SWEP.Primary.ClipSize		= 8
SWEP.Primary.DefaultClip	= 32
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "Pistol"

SWEP.Secondary.ClipSize		= 8
SWEP.Secondary.DefaultClip	= 32
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "Pistol"

SWEP.NextSecondaryAttack = 0

function SWEP:Initialize()
    if SERVER then
		self:SetWeaponHoldType(self.HoldType)
	end
	timer.Simple(3, function()
		if self:IsValid() then
			self:Update()
		end
	end)
end

function SWEP:Deploy()
	return true
end

function SWEP:Precache() end

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack() then return false end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:TacticsShootBullet(self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone)
 	if (SinglePlayer() && SERVER) || CLIENT then 
 		self:SetNetworkedFloat("LastShootTime",CurTime()) 
 	end 
end

function SWEP:SecondaryAttack()
	if !self:CanSecondaryAttack() then return false end
	self:SetNextSecondaryFire(CurTime() + 4)
	self:GetOwner():RestartGesture(ACT_ITEM_DROP)
	if SERVER then
		self:SetNWBool("reloading", true)
		local entNade = ents.Create("npc_grenade_frag")
		timer.Simple(1, function()
			if self:IsValid() then
				local vecNadePos = self:GetOwner():EyePos() + (self:GetOwner():GetAimVector() * 14)
				local intNadeDur = 3
				entNade:SetOwner(self:GetOwner())
				entNade:Fire("SetTimer", intNadeDur)
				entNade:SetPos(vecNadePos)
				entNade:SetAngles(self:GetOwner():EyeAngles())
				entNade:Spawn()
				--Figur out the distance
				local tblTraceTable = {}
				tblTraceTable.start = self:GetOwner():EyePos()
				tblTraceTable.endpos = tblTraceTable.start + (self:GetOwner():GetCursorAimVector() * 4096 * 4)
				local tblFilterTable = ents.FindByClass("func_brush")
				table.insert(tblFilterTable, self:GetOwner())
				table.insert(tblFilterTable, self:GetOwner():GetActiveWeapon())
				table.insert(tblFilterTable, entNade)
				tblTraceTable.filter = tblFilterTable
				local trcPlayerTrace = util.TraceLine(tblTraceTable)
				local intPower = trcPlayerTrace.HitPos:Distance(self:GetOwner():GetPos())
				local phys = entNade:GetPhysicsObject()
				phys:ApplyForceCenter(self:GetOwner():GetAimVector():GetNormalized() * math.Clamp(intPower * 1.5, 1, 700))
				self:SetNWBool("reloading", false)
			end
		end)
	end
end

function SWEP:Think() end
function SWEP:OnRestore() end
function SWEP:CheckReload() end

function SWEP:Reload()
	if self:GetNWBool("reloading") then return false end
	if self:Clip1() >= self.Primary.ClipSize then return false end
	if self:Clip1() < self.Primary.ClipSize && self:GetOwner():GetAmmoCount(self.Primary.Ammo) > 0  then
		--print(self.ReloadSpeed)
		self:SetNWBool("reloading", true)
		self:GetOwner():RestartGesture(self:GetOwner():Weapon_TranslateActivity(ACT_HL2MP_GESTURE_RELOAD))
		self:SetNextPrimaryFire(CurTime() + self.ReloadSpeed)
		self:SetNextSecondaryFire(CurTime() + self.ReloadSpeed)
		timer.Simple(self.ReloadSpeed, function() 
			if self:IsValid() then
				if (self:GetOwner():GetAmmoCount(self.Primary.Ammo) + self.Weapon:Clip1()) >= self.Primary.ClipSize then
					if SERVER then
						self:GetOwner():RemoveAmmo(self.Primary.ClipSize - self.Weapon:Clip1()  ,self.Primary.Ammo )
						self.Weapon:SetClip1(self.Primary.ClipSize)
					end
				else
					if SERVER then
						self.Weapon:SetClip1(self:GetOwner():GetAmmoCount(self.Primary.Ammo) + self.Weapon:Clip1())
						self:GetOwner():RemoveAmmo(self:GetOwner():GetAmmoCount(self.Primary.Ammo),self.Primary.Ammo)
					end
				end
				self:SetNWBool("reloading", false)
			end
		end)
	end
end

function SWEP:Holster(wep)
	return true
end

function SWEP:Update()
	local intActiveWeaponNumber = self:GetNWInt("id")
	if intActiveWeaponNumber != 0 then
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
			self.RecievedInfo = true
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
			self.RecievedInfo = true
		end
		if (self:GetOwner():GetAmmoCount(self.Primary.Ammo) + self.Weapon:Clip1()) >= self.Primary.ClipSize then
			if SERVER then
				self:GetOwner():RemoveAmmo(self.Primary.ClipSize - self.Weapon:Clip1()  ,self.Primary.Ammo )
				self.Weapon:SetClip1(self.Primary.ClipSize)
			end
		else
			if SERVER then
				self.Weapon:SetClip1(self:GetOwner():GetAmmoCount(self.Primary.Ammo) + self.Weapon:Clip1())
				self:GetOwner():RemoveAmmo(self:GetOwner():GetAmmoCount(self.Primary.Ammo),self.Primary.Ammo)
			end
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
	bullet.Tracer	= 0
	bullet.Force	= dmg
	bullet.Damage	= dmg
	self.Owner:FireBullets(bullet)
	self:EmitSound(self.Primary.Sound, 100, 100)
	self:TakePrimaryAmmo(self.Primary.NumShots)
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
	if !self.RecievedInfo then return false end
	if self:GetNWBool("reloading") then return false end
	if self:Clip1() <= 0 then
		self:Reload()
		return false
	end
	return true
end

function SWEP:CanSecondaryAttack()
	if self:GetNWBool("reloading") then return false end 
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