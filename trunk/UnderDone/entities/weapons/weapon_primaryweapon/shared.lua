SWEP.WorldModel	= "models/weapons/w_pistol.mdl"
SWEP.Primary.Automatic = true

function SWEP:Initialize()
	if CLIENT then
		self.entWoldModel = ents.Create("prop_physics")
		self.entWoldModel:SetModel(self.WorldModel)
		self.entWoldModel:Spawn()
		self.entWoldModel:SetPos(self:GetPos())
		self.entWoldModel:SetAngles(self:GetAngles())
		self.entWoldModel:SetParent(self)
		self.entWoldModel:SetCollisionGroup(GROUP_NONE)
	end
end

function SWEP:SetWeapon(tblWeapon)
	if tblWeapon then
		self.WeaponTable = tblWeapon
		self:SetNWString("worldmodel", self.WeaponTable.Model)
		self:SetWeaponHoldType("pistol")
		return true
	end
	return false
end

function SWEP:PrimaryAttack()
	self:FireBullet()
end
function SWEP:SecondaryAttack()
end

function SWEP:FireBullet()
	--[[if !self.WeaponTable or self.WeaponTable.Key != self:GetNWString("key") then
		self.WeaponTable = GAMEMODE.WeaponsDataBase[self:GetNWString("key")]
	end
	if self.WeaponTable then
		local tblBullet = {}
		tblBullet.Src 		= self.Owner:GetShootPos()
		tblBullet.Dir 		= self.Owner:GetAimVector()
		tblBullet.Force		= self.WeaponTable.Pwr / 2
		local intRealAcuracy = (1 / (self.WeaponTable.Accrcy / 3))
		tblBullet.Spread 	= Vector(intRealAcuracy, intRealAcuracy, 0)
		tblBullet.Num 		= self.WeaponTable.Bllts
		tblBullet.Damage	= self.WeaponTable.Pwr
		tblBullet.Tracer	= 2
		tblBullet.AmmoType	= "Pistol"
		self.Owner:FireBullets(tblBullet)
		
		self.Owner:MuzzleFlash()
		if SERVER then GAMEMODE:SetPlayerAnimation(self.Owner, PLAYER_ATTACK1) end
		self:EmitSound(self.WeaponTable.Snd)
		
		self:SetNextPrimaryFire(CurTime() + (1 / self.WeaponTable.FrRt))
	end]]
end
