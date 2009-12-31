SWEP.WorldModel	= "models/weapons/w_pistol.mdl"
SWEP.Primary.Automatic = true

function SWEP:SetWeapon(tblWeapon)
	if tblWeapon then
		self.WeaponTable = tblWeapon
		self:SetNWString("item", self.WeaponTable.Name)
		self:SetWeaponHoldType(self.WeaponTable.HoldType)
		return true
	end
	return false
end

function SWEP:Think()
	if self.Item != self:GetNWString("item") then
		self.Item = self:GetNWString("item")
		self.WeaponTable = GAMEMODE.DataBase.Items[self.Item]
	end
end

function SWEP:PrimaryAttack()
	self:WeaponAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:OnRemove()
end

function SWEP:WeaponAttack()
	if SERVER then 
		self.Owner:RestartGesture(self.Owner:Weapon_TranslateActivity(ACT_HL2MP_GESTURE_RANGE_ATTACK))
	end
	if self.WeaponTable then
		local isMelee = self.WeaponTable.HoldType == "melee"
		local intRange = self.Owner:GetEyeTrace().HitPos:Distance(self.Owner:GetEyeTrace().StartPos)
		local tblBullet = {}
		tblBullet.Src 		= self.Owner:GetShootPos()
		tblBullet.Dir 		= self.Owner:GetAimVector()
		tblBullet.Force		= self.WeaponTable.Power / 2
		tblBullet.Spread 	= Vector(self.WeaponTable.Accuracy, self.WeaponTable.Accuracy, 0)
		tblBullet.Num 		= self.WeaponTable.NumOfBullets
		tblBullet.Damage	= self.WeaponTable.Power
		tblBullet.Tracer	= 2
		if isMelee then tblBullet.Tracer = 0 end
		tblBullet.AmmoType	= "Pistol"
		if !isMelee then
			self.Owner:FireBullets(tblBullet)
		else
			if intRange <= 50 then
				self.Owner:FireBullets(tblBullet)
			end
		end
		if !isMelee then
			self.Owner:MuzzleFlash()
		end
		self:EmitSound(self.WeaponTable.Sound)
		self:SetNextPrimaryFire(CurTime() + (1 / self.WeaponTable.FireRate))
	end
end
