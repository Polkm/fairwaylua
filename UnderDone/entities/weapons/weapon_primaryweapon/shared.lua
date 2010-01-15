SWEP.WorldModel	= "models/weapons/w_pistol.mdl"
SWEP.Primary.Automatic = true

function SWEP:Initialize()
end

function SWEP:OnRemove()
	if SERVER then
		if self.WeaponTable && self.WeaponTable.AmmoType != "none" then
			self.Owner:GiveAmmo(self:Clip1(), self.WeaponTable.AmmoType)
		end
	end
end

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
		self.WeaponTable = GAMEMODE.DataBase.Items[self.Item] or {}
		if self.WeaponTable.AmmoType && self.WeaponTable.AmmoType != "none" then
			self:SetClip1(0)
			self:Reload()
		end
	end
end

function SWEP:Reload()
	if self:GetNWBool("reloading") == true then return false end
	local strAmmoType = self.WeaponTable.AmmoType
	local intClipSize = self.WeaponTable.ClipSize
	local intCurrentAmmo = self.Owner:GetAmmoCount(strAmmoType)
	if strAmmoType != "none" && self:Clip1() < self.WeaponTable.ClipSize && intCurrentAmmo > 0 then
		self:SetNWBool("reloading", true)
		self:SetNextPrimaryFire(CurTime() + 1.5)
		if SERVER then GAMEMODE:SetPlayerAnimation(self.Owner, PLAYER_RELOAD) end
		timer.Simple(1.5, function()
			if !self or !self.Owner or !self.Owner:Alive() then return end
			self.Owner:RemoveAmmo(self.WeaponTable.ClipSize - self:Clip1(), self.WeaponTable.AmmoType)
			self:SetClip1(math.Clamp(self.WeaponTable.ClipSize, 0, intCurrentAmmo))
			self:SetNWBool("reloading", false)
		end)
	end
end

function SWEP:PrimaryAttack()
	if self:Clip1() != 0 then
		self:WeaponAttack()
	else
		self:Reload()
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:WeaponAttack()
	if SERVER then 
		self.Owner:RestartGesture(self.Owner:Weapon_TranslateActivity(ACT_HL2MP_GESTURE_RANGE_ATTACK))
	end
	if self.WeaponTable then
		local isMelee = self.WeaponTable.HoldType == "melee"
		local isWoodCutting = self.WeaponTable.CanCutWood 
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
		tblBullet.AmmoType	= self.WeaponTable.AmmoType
		if isMelee then tblBullet.AmmoType = "pistol" end
		if !isMelee then
			self.Owner:FireBullets(tblBullet)
		else
			if intRange <= 70 then
				if isWoodCutting then
					if self.Owner:GetEyeTrace().Entity.CutAble then
						if math.random(1,10) > 7 then
							self.Owner:AddItem("wood", 1)
							self.Owner:CreateNotification("Gained 1 Wood")
						end
					end
				end
				self.Owner:FireBullets(tblBullet)
			end
		end
		if SERVER && !isMelee then
			self:SetClip1(self:Clip1() - 1)
		end
		if CLIENT && !isMelee then
			self.Owner:MuzzleFlash()
			local strEffect = "ShellEject"
			if self.WeaponTable.HoldType == "shotgun" then strEffect = "ShotgunShellEject" end
			local effectdata = EffectData()
			effectdata:SetOrigin(self.Owner.PapperDollEnts["slot_primaryweapon"]:GetPos())
			effectdata:SetAngle(self.Owner.PapperDollEnts["slot_primaryweapon"]:GetAngles():Right())
			effectdata:SetEntity(self)
			effectdata:SetMagnitude( 1 )
			effectdata:SetScale( 1 )
			util.Effect(strEffect, effectdata)
		end
		self:EmitSound(self.WeaponTable.Sound)
		self:SetNextPrimaryFire(CurTime() + (1 / self.WeaponTable.FireRate))
	end
end
