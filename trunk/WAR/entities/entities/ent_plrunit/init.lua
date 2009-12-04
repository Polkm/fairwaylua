AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:PhysicsInit(SOLID_BBOX)
	self:GetPhysicsObject():EnableGravity(false)
	------------------------------
	self.WeaponTable = {}
	------------------------------
	self.ShouldMoveToTargetPostion = false
	self.ShouldTurnToTarget = false
	self.ShouldContinueAttack = true
	self.TargetAngles = Angle(0, 0, 90)
	self.TargetSquad = 0
end

function ENT:SetClass(strClassName)
	if GAMEMODE.Data.Units[strClassName] then
		self:SetNWString("class", strClassName)
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
	self.TargetAngles = Angle(0, math.NormalizeAngle((vecPosition - self:GetPos()):Angle().y), 90)
	if fncCallBack then
		self.TurnCallBack = fncCallBack
	end
end

function ENT:Scramble()
	local intTotalUnits = GAMEMODE.Data.Units[self.SquadTable.Class].SquadLimit
	local SurfaceNeeded = math.sqrt(intTotalUnits * (1000 / ((intTotalUnits / 200) + 1)))
	local vecTargetPosition = self.SquadTable.HomePos + Vector(math.random(-SurfaceNeeded, SurfaceNeeded), math.random(-SurfaceNeeded, SurfaceNeeded), 15)
	self:MoveTo(vecTargetPosition)
	self:TurnTo(vecTargetPosition)
end

function ENT:Attack(entTarget)
	if !entTarget or !entTarget:IsValid() then return end
	if !entTarget:GetClass() == "ent_plrunit" then return end
	if entTarget == self or self:IsSameSquad(entTarget) then return end
	self.TargetSquad = entTarget.SquadTable
	self.ShouldContinueAttack = true
	self:TurnTo(entTarget:GetPos(), function(self)
		self:FireGun(entTarget)
	end)
end

function ENT:SeaseFire()
	self.ShouldContinueAttack = false
	self:SetNWString("anim", "idle")
end

function ENT:ShouldFireAgain()
	if entTarget and entTarget:IsValid() then
		self:TurnTo(entTarget:GetPos(), function(self)
			self:FireGun(entTarget)
			timer.Simple(tblWeaponTable.FireSpeed, function()
				self:Attack(entTarget)
			end)
		end)
	else
		if self.TargetSquad.Units and #self.TargetSquad.Units > 0 then
			self:Attack(table.Random(self.TargetSquad.Units))
		end
	end
end

function ENT:FireGun(entTarget)
	local tblWeaponTable = GAMEMODE.Data.Equiptment[self:GetNWString("weapon")]
	local tblUnitTable = GAMEMODE.Data.Units[self.SquadTable.Class]
	local tblBullet = {}
	tblBullet.Num = tblWeaponTable.NumShots or 1
	tblBullet.Src = self:GetPos() + (self:GetForward() * 10)
	tblBullet.Dir = self:GetAngles():Forward()
	tblBullet.Spread = Vector(tblWeaponTable.Spread or 0.01, tblWeaponTable.Spread or 0.01, 0)
	tblBullet.Force = tblWeaponTable.Damage / 2
	tblBullet.Damage = tblWeaponTable.Damage
	tblBullet.Tracer = 1
	tblBullet.TracerName = "Tracer"
	tblBullet.Callback = function(Attacker, BulletPath, DamageInfo)
		if Attacker:IsSameSquad(BulletPath.Entity) then
			self:Scramble()
			return false, false
		end
	end
	self:FireBullets(tblBullet)
	self:SetNWString("anim", "fire")
	timer.Simple(tblWeaponTable.FireSpeed, function()
		self:SetNWString("anim", "idle")
		if self.ShouldContinueAttack then
			if entTarget and entTarget:IsValid() then
				self:TurnTo(entTarget:GetPos(), function(self)
					self:FireGun(entTarget)
				end)
			else
				if self.TargetSquad.Units and #self.TargetSquad.Units > 0 then
					self:Attack(table.Random(self.TargetSquad.Units))
				end
			end
		end
	end)
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

function ENT:OnRemove()
	for key, Unit in pairs(self.SquadTable.Units) do
		if Unit == self then
			table.remove(self.SquadTable.Units, key)
			break
		end
	end
end

function ENT:StepTick()
	if !self.ShouldMoveToTargetPostion then
		if self:GetPos() != self.TargetPostion then
			self:SetPos(self.TargetPostion)
		end
		return
	end
	if self:GetPos():Distance(self.TargetPostion) > 1 then
		local intMoveSpeed = GAMEMODE.Data.Units[self.SquadTable.Class].MoveSpeed
		local vecSlope = (self.TargetPostion - self:GetPos()):GetNormal()
		local Velocity = vecSlope
		if self:GetPos():Distance(self.TargetPostion) > (intMoveSpeed / 100) then
			Velocity = Velocity * intMoveSpeed
		else
			Velocity = Velocity * (intMoveSpeed / 100)
		end
		Velocity.x = math.Round(Velocity.x)
		Velocity.y = math.Round(Velocity.y)
		Velocity.z = math.Round(Velocity.z)
		if self:GetPhysicsObject():GetVelocity() != Velocity then
			self:GetPhysicsObject():SetVelocity(Velocity)
		end
	else
		self.ShouldMoveToTargetPostion = false
	end
end

function ENT:TurnTick()
	if !self.ShouldTurnToTarget then
		if self:GetAngles() != self.TargetAngles then
			self:SetAngles(self.TargetAngles)
		end
		return
	end
	if math.abs(self.TargetAngles.y - self:GetAngles().y) > 2 then
		local angNewAngle = Vector(0, 0, 90)
		angNewAngle.y = math.NormalizeAngle(self:GetAngles().y + ((self.TargetAngles.y - self:GetAngles().y) / 10))
		self:SetAngles(angNewAngle)
	else
		self.ShouldTurnToTarget = false
		if self.TurnCallBack then
			self.TurnCallBack(self)
			self.TurnCallBack = nil
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

