AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:GetPhysicsObject():EnableGravity(false)
	------------------------------
	self.ShouldMoveToTarget = false
	self.TargetPostion = Vector(0, 0, 0)
	self.ShouldFaceTarget = false
	------------------------------
	local gun = ents.Create("prop_physics")
	gun:SetModel("models/Weapons/w_smg1.mdl")
	local gunPos = self:GetPos()
	gunPos = gunPos + (self:GetForward() * 5)
	gunPos = gunPos + (self:GetUp() * 9)
	gun:SetPos(gunPos)
	local gunAngle = self:GetAngles()
	gunAngle.r = -90
	gun:SetAngles(gunAngle)
	gun:SetParent(self)
	gun:Spawn()
	self.GunProp = gun
end

function ENT:Sellect()
	if !self:GetOwner().SellectedSquads then self:GetOwner().SellectedSquads = {} end
	if table.HasValue(self:GetOwner().SellectedSquads, self.SquadTable) then return end
	for k, Unit in pairs(self.SquadTable.Units) do Unit:SetNWBool("sellected", true) end
	table.insert(self:GetOwner().SellectedSquads, self.SquadTable)
end

function ENT:MoveToTarget()
	self.ShouldMoveToTarget = true
end
function ENT:FaceTarget()
	self.ShouldFaceTarget = true
end
function ENT:StopMoving()
	self.ShouldMoveToTarget = false
end
function ENT:StopFacing()
	self.ShouldFaceTarget = false
end
function ENT:FireGun()
	local bullet = {}
	bullet.Num = 1
	bullet.Src = self.GunProp:GetPos() + (self.GunProp:GetForward() * 10)
	bullet.Dir = self.GunProp:GetAngles():Forward()
	bullet.Spread = Vector(0.01, 0.01, 0)
	bullet.Tracer = 1	
	bullet.Force = 2
	bullet.Damage = 500
	self:FireBullets(bullet)
end

function ENT:Attack(objTarget)
	local Target = objTarget
	if !Target then return end
	
	
	
end

function ENT:StepTwardsTarget()
	if self:GetPos():Distance(self.TargetPostion) > 1 then
		local Slope = (self.TargetPostion - self:GetPos()):GetNormal()
		local Velocity = Slope
		if self:GetPos():Distance(self.TargetPostion) > (GAMEMODE.Data.Units[self.SquadTable.Class].MoveSpeed / 30) then
			Velocity = Velocity * GAMEMODE.Data.Units[self.SquadTable.Class].MoveSpeed
		else
			Velocity = Velocity * (GAMEMODE.Data.Units[self.SquadTable.Class].MoveSpeed / 30)
		end
		Velocity.x = math.Round(Velocity.x)
		Velocity.y = math.Round(Velocity.y)
		Velocity.z = math.Round(Velocity.z)
		self:GetPhysicsObject():SetVelocity(Velocity)
	else
		self:GetPhysicsObject():SetVelocity(Vector(0, 0, 0))
		self:SetPos(self.TargetPostion)
		self:StopMoving()
		self:StopFacing()
	end
end

function ENT:FaceTwardsTarget()
	local Yaw = self:GetAngles().y
	local TargetYaw = (self.TargetPostion - self:GetPos()):Angle().y
	if Yaw != TargetYaw then
		local MoveAngle = self:GetAngles()
		MoveAngle.y = TargetYaw
		self:SetAngles(MoveAngle)
	end
end

