AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self.vecAddativeAngularVelocity = Vector(0, 0, 0)
	self.vecAddativeVelocity = Vector(0, 0, 0)
	
	self.Entity:SetModel("models/gmodcart/base_cart.mdl")
	self.Entity:SetMoveType(MOVETYPE_CUSTOM)
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:SetNoDraw(true)
	self.Entity:GetPhysicsObject():SetMass(100)
	self.Entity:GetPhysicsObject():SetMaterial("gmod_ice")
	
	self.Ragdoll = self:AddCartPart(self.Entity, Vector(15, 0, 1), Angle(0, 0, 0), "models/marioragdoll/Super Mario Galaxy/mario/mario.mdl")
	self.BodyFrame = self:AddCartPart(self.Entity,Vector(0, 0, 6), Angle(0, 0, 0), "models/gmodcart/base_cart.mdl")
	self.BackWheel1 = self:AddCartPart(self.BodyFrame, Vector(-12, -21, 2.4), Angle(0, 0, 0), "models/gmodcart/base_cart_wheel.mdl")
	self:SetNWEntity("Wheel1", self.BackWheel1)
	self.BackWheel2 = self:AddCartPart(self.BodyFrame, Vector(-12, 21, 2.4), Angle(0, 0, 0), "models/gmodcart/base_cart_wheel.mdl")
	self:SetNWEntity("Wheel2", self.BackWheel2)
	self.frontWheel1 = self:AddCartPart(self.BodyFrame, Vector(35, -23, 2.4), Angle(0, 0, 0), "models/gmodcart/base_cart_wheel.mdl")
	self.frontWheel2 = self:AddCartPart(self.BodyFrame, Vector(35, 23, 2.4), Angle(0, 0, 0), "models/gmodcart/base_cart_wheel.mdl")
	self.SteerWheel1 = self:AddCartPart(self.BodyFrame, Vector(-6, 0, 4), Angle(0, 0, 0), "models/gmodcart/regular_cart_steerwheel.mdl")
	constraint.NoCollide(self.SteerWheel1, self.BodyFrame, 0, 0)

	self.Entity:StartMotionController()
end

function ENT:AddCartPart(entParent, vecPosition, angAngles, strModel)
	local entNewPart = ents.Create("player_wheel")
	entNewPart:SetPos(entParent:GetPos() + vecPosition)
	entNewPart:SetAngles(entParent:GetAngles() + angAngles)
	entNewPart:SetModel(strModel)
	entNewPart:SetParent(entParent)
	entNewPart:SetCollisionGroup(GROUP_NONE)
	entNewPart:Spawn()
	return entNewPart
end

function ENT:PhysicsCollide(tblData, physObject)
	if self:GetOwner().StarPower then
		if tblData.HitEntity:GetOwner():IsPlayer() && tblData.HitEntity:GetOwner():GetNWEntity("Cart") == tblData.HitEntity && self.LastStarHit != tblData.HitEntity  then
			self.LastStarHit = tblData.HitEntity
			tblData.HitEntity:Wipeout("Spin")
			timer.Simple(1, function() self.LastStarHit = 0 end)
		end
	end
end

function ENT:Wipeout(strType)
	print(strType)
	if strType == "Spin" then
		local intDirection = math.random(-1, 1)
		if intDirection == 0 then intDirection = 1 end
		self.vecAddativeAngularVelocity = Vector(0, 0, self:GetAngles():Forward():Dot(self:GetVelocity()) * intDirection * 0.5)
		self.BodyFrame:SetColor(255, 0, 0, 255)
		self:GetOwner().wipeout = true
		timer.Simple(3, function()
			self.vecAddativeAngularVelocity = Vector(0, 0, 0)
			self.BodyFrame:SetColor(255, 255, 255, 255)
			self:GetOwner().wipeout = false
		end)
	elseif strType == "Explode" then
		self:GetOwner().wipeout = true
		self.BodyFrame:SetColor(255, 0, 0, 255)
		timer.Simple(3, function()
			self.BodyFrame:SetColor(255, 255, 255, 255)
			self:GetOwner().wipeout = false
		end)
	end
end
function ENT:Wipeout_Explode()
end

function ENT:PhysicsSimulate(phys, deltatime)
	local vecUp = phys:GetAngle():Up()
	local tblTrace = {}
	tblTrace.start = self:GetPos()
	tblTrace.filter = self
	tblTrace.endpos = self:GetPos() - Vector(0,0,3)
	local trcDownTrace = util.TraceLine(tblTrace)
	local plyDriver = self:GetOwner()
	local intForward = 0
	local intRight = 0
	local vecVelocity = phys:GetVelocity()
	local vecForwardVel = phys:GetAngle():Forward():Dot(vecVelocity)
	local vecRightVel = phys:GetAngle():Right():Dot(vecVelocity)
	if plyDriver then
		intForward = self:GetForwardAcceleration(plyDriver, phys, vecForwardVel)
		intBounce = self:GetUpAcceleration(plyDriver, phys, vecForwardVel)
		intYaw = self:GetTurnYaw(plyDriver, phys, vecForwardVel)
		if vecUp.z < 0.33 || !trcDownTrace.Hit then
			intForward = vecForwardVel * 0.1
			intBounce = 1
			intYaw = 0
		end
		if intYaw > 0 then
			self.frontWheel1:SetAngles(self.Entity:GetAngles() + Angle(0,15,0))
			self.frontWheel2:SetAngles(self.Entity:GetAngles() + Angle(0,15,0))
		elseif intYaw < 0 then
			self.frontWheel1:SetAngles(self.Entity:GetAngles() + Angle(0,-15,0))
			self.frontWheel2:SetAngles(self.Entity:GetAngles() + Angle(0,-15,0))
		else
			self.frontWheel1:SetAngles(self.Entity:GetAngles())
			self.frontWheel2:SetAngles(self.Entity:GetAngles())
		end
	end
	intRight = vecRightVel * 0.95
	intForward = intForward - vecForwardVel * 0.2
	
	local Linear = Vector(intForward, intRight, intBounce) * deltatime * 250
	local AngleFriction = phys:GetAngleVelocity() * -1.1
	local Angular = (AngleFriction + Vector(0, 0, intYaw)) * deltatime * 250
	
	if self:GetOwner().SlowDown && self:GetOwner().CanSlowDown then 
		Linear =  Linear/3
	end
	return Angular, Linear, SIM_LOCAL_ACCELERATION
end

function ENT:PhysicsUpdate(phys) 
end
function ENT:Think()
	local phyEntity = self.Entity:GetPhysicsObject()
	if phyEntity && self:GetOwner() then
		phyEntity:Wake()
	end
end

function ENT:GetForwardAcceleration(driver, phys, vecForwardVel)
	if !driver || !driver:IsValid() then return 0 end
	if !self:GetOwner().wipeout && GetGlobalString("GameModeState") != "PREP" then
		if driver:KeyDown(IN_FORWARD) then return self:GetOwner().Forward end
		if driver:KeyDown(IN_BACK) then return -150 end
	end
	return 0
end

function ENT:GetUpAcceleration(driver, phys, vecForwardVel)
	local Velocity = phys:GetVelocity()
	local vecForwardVel = phys:GetAngle():Forward():Dot(Velocity)
	if !driver || !driver:IsValid() || vecForwardVel <= 100 then return 0 end
	if driver:KeyDown(IN_JUMP) then return 2000 end
	return 180
end

function ENT:GetTurnYaw(driver, phys, vecForwardVel)
	if !driver || !driver:IsValid() then return 0 end
	if !self:GetOwner().wipeout && GetGlobalString("GameModeState") != "PREP" then
		if driver:KeyDown(IN_MOVELEFT) then return self:GetOwner().Turn end
		if driver:KeyDown(IN_MOVERIGHT) then return -1* (self:GetOwner().Turn) end
	end
	return self.vecAddativeAngularVelocity.z
end
