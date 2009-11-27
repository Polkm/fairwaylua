AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:PhysicsInit(SOLID_BBOX)
	self:GetPhysicsObject():EnableGravity(false)
	------------------------------
	self.ShouldMoveToTargetPostion = false
	self.ShouldTurnToTarget = false
	self.TargetAngles = Angle(0, 0, 90)
end

function ENT:SetClass(strClassName)
	self:SetNWString("class", strClassName)
end

function ENT:SetWeapon(strWeaponName)
	self:SetNWString("weapon", strWeaponName)
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

function ENT:TurnTo(vecPosition)
	self.ShouldTurnToTarget = true
	self.TargetAngles = Angle(0, math.NormalizeAngle((vecPosition - self:GetPos()):Angle().y), 90)
end

function ENT:FireGun()
	local bullet = {}
	bullet.Num = 1
	bullet.Src = self:GetPos() + (self:GetForward() * 10)
	bullet.Dir = self:GetAngles():Forward()
	bullet.Spread = Vector(0.01, 0.01, 0)
	bullet.Tracer = 1	
	bullet.Force = 2
	bullet.Damage = 500
	self:FireBullets(bullet)
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
		if self:GetPos():Distance(self.TargetPostion) > (intMoveSpeed / 30) then
			Velocity = Velocity * intMoveSpeed
		else
			Velocity = Velocity * (intMoveSpeed / 30)
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
	end
end

