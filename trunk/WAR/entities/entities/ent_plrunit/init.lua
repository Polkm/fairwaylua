AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	------------------------------
	self.WeaponTable = {}
	------------------------------
	self.ShouldMoveToTargetPostion = false
	self.ShouldTurnToTarget = false
	self.ShouldContinueAttack = true
	self.TargetAngles = Angle(0, 0, 90)
	self.TargetSquad = 0
	------------------------------
	
	self:DrawShadow(false)
	self:PhysicsInit(SOLID_BBOX)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:GetPhysicsObject():EnableGravity(false)
	self:GetPhysicsObject():SetMass(0.1)
	self:GetPhysicsObject():Wake()
	self:StartMotionController()
end

function ENT:OnRemove()
	for key, Unit in pairs(self.SquadTable.Units) do
		if Unit == self then
			table.remove(self.SquadTable.Units, key)
			break
		end
	end
end

function ENT:OnTakeDamage(dmginfo)
	local intHealth = self:GetNWInt("health")
	if intHealth && dmginfo:GetDamage() && !self:IsSameSquad(dmginfo:GetAttacker()) then
		self:SetNWInt("health", math.Clamp(intHealth - dmginfo:GetDamage(), 0, intHealth))
		if self:GetNWInt("health") <= 0 then
			self:Remove()
		end
	end
end

function ENT:SetClass(strClassName)
	if GAMEMODE.Data.Classes[strClassName] then
		self:SetNWString("class", strClassName)
		self:SetNWInt("health", GAMEMODE.Data.Classes[strClassName].Health)
		self:SetModel(GAMEMODE.Data.Classes[strClassName].Model)
	end
end

function ENT:SetWeapon(strWeaponName)
	if GAMEMODE.Data.Equiptment[strWeaponName] then
		self:SetNWString("weapon", strWeaponName)
		self.WeaponTable = GAMEMODE.Data.Equiptment[strWeaponName]
	end
end

function ENT:Sellect()
	if !self:GetOwner().SellectedSquads then self:GetOwner().SellectedSquads = {} end
	if table.HasValue(self:GetOwner().SellectedSquads, self.SquadTable) then return end
	for k, Unit in pairs(self.SquadTable.Units) do Unit:SetNWBool("sellected", true) end
	table.insert(self:GetOwner().SellectedSquads, self.SquadTable)
end

function ENT:MoveTo(vecPosition)
	self.ShouldMoveToTargetPostion = true
	self.TargetPostion = vecPosition
end

function ENT:TurnTo(vecPosition, fncCallBack)
	self.ShouldTurnToTarget = true
	self.TargetAngles = Angle(math.NormalizeAngle((vecPosition - self:GetPos()):Angle().p), math.NormalizeAngle((vecPosition - self:GetPos()):Angle().y), math.NormalizeAngle((vecPosition - self:GetPos()):Angle().r) + 90)
	if fncCallBack then
		self.TurnCallBack = fncCallBack
	end
end

function ENT:Scramble()
	local intTotalUnits = GAMEMODE.Data.Classes[self.SquadTable.Class].SquadLimit
	local SurfaceNeeded = math.sqrt(intTotalUnits * (1000 / ((intTotalUnits / 200) + 1)))
	local vecTargetPosition = self.SquadTable.HomePos + Vector(math.random(-SurfaceNeeded, SurfaceNeeded), math.random(-SurfaceNeeded, SurfaceNeeded), 15)
	self:MoveTo(vecTargetPosition)
	self:TurnTo(vecTargetPosition)
end

function ENT:Attack(entTarget)
	if !ValidEntity(entTarget) or !entTarget:GetClass() == "ent_plrunit" then return end
	if entTarget == self or self:IsSameSquad(entTarget) then return end
	local tblWeaponTable = GAMEMODE.Data.Equiptment[self:GetNWString("weapon")]
	if !tblWeaponTable then return false end
	self.TargetSquad = entTarget.SquadTable
	if self.ShouldContinueAttack == false then
		self.ShouldContinueAttack = true
		self:TurnTo(entTarget:GetPos(), function(self)
			self:FireGun(entTarget)
		end)
	end
end

function ENT:SeaseFire()
	self.ShouldContinueAttack = false
	self:SetNWString("anim", "idle")
end

function ENT:FireGun(entTarget)
	local tblWeaponTable = GAMEMODE.Data.Equiptment[self:GetNWString("weapon")]
	if !tblWeaponTable then return false end
	local tblUnitTable = GAMEMODE.Data.Classes[self.SquadTable.Class]
	local tblBullet = {}
	tblBullet.Num = tblWeaponTable.NumShots or 1
	tblBullet.Src = self:GetPos() + (self:GetForward() * 10)
	tblBullet.Dir = self:GetAngles():Forward()
	tblBullet.Spread = Vector(tblWeaponTable.Spread or 0.01, tblWeaponTable.Spread or 0.01, 0)
	tblBullet.Force = tblWeaponTable.Damage / 2
	tblBullet.Damage = tblWeaponTable.Damage
	tblBullet.Tracer = 2
	tblBullet.TracerName = "Tracer"
	tblBullet.Callback = function(Attacker, BulletPath, DamageInfo)
		if Attacker:IsSameSquad(BulletPath.Entity) then
			self:Scramble()
			return false, false
		end
	end
	self:FireBullets(tblBullet)
	self:EmitSound(tblWeaponTable.Sound)
	timer.Simple(tblWeaponTable.FireSpeed + math.random(-tblWeaponTable.FireSpeed / 10, tblWeaponTable.FireSpeed / 10), function()
		if ValidEntity(self) && ValidEntity(entTarget) then
			self:ShouldFireAgain(entTarget)
		end
	end)
end

function ENT:ShouldFireAgain(entTarget)
	if self.ShouldContinueAttack then
		if ValidEntity(entTarget) then
			self:TurnTo(entTarget:GetPos(), function(self)
				self:FireGun(entTarget)
			end)
		else
			if self.TargetSquad.Units and #self.TargetSquad.Units > 0 then
				self:Attack(self:FindIdealTarget(self.TargetSquad.Units))
			end
		end
	end
end

function ENT:IsSameSquad(entTarget)
	if !entTarget.SquadTable then return false end
	if self.SquadTable.SquadID == entTarget.SquadTable.SquadID then
		return true
	end
	return false
end

function ENT:FindIdealTarget(tblSquad)
	return table.Random(tblSquad)
end

function ENT:PhysicsSimulate(phys, deltatime)
	phys:Wake()
	local ShadowParams = {}
	ShadowParams.secondstoarrive = 1
	ShadowParams.pos = self.TargetPostion
	
	local intMoveSpeed = GAMEMODE.Data.Classes[self.SquadTable.Class].MoveSpeed
	if self:GetPos():Distance(self.TargetPostion) > intMoveSpeed / 2 then
		ShadowParams.maxspeed = intMoveSpeed
	else
		ShadowParams.maxspeed = self:GetPos():Distance(self.TargetPostion) / 50
	end
	ShadowParams.angle = self.TargetAngles
	ShadowParams.maxangular = 100
	ShadowParams.teleportdistance = 0
	ShadowParams.dampfactor = 10000000
	ShadowParams.deltatime = deltatime
	phys:ComputeShadowControl(ShadowParams)
	
	if math.abs(self.TargetAngles.y - self:GetAngles().y) < 2 then
		self.ShouldTurnToTarget = false
		if self.TurnCallBack then
			self.TurnCallBack(self)
			self.TurnCallBack = nil
		end
	end
end