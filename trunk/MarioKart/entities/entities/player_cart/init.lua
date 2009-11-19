AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self.vecAddativeAngularVelocity = Vector(0, 0, 0)
	self.vecAddativeVelocity = Vector(0, 0, 0)
	
	self.Entity:SetModel("models/gmodcart/base_cart.mdl")
	self.Entity:SetMoveType( MOVETYPE_CUSTOM )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetNoDraw(true)
	self.Entity:GetPhysicsObject():SetMass( 100 )
	self.Entity:GetPhysicsObject():SetMaterial("gmod_ice")
	self.Ragdoll = ents.Create("prop_dynamic")
	self.Ragdoll:SetPos(self.Entity:GetPos() + Vector(15,0,1))
	self.Ragdoll:SetModel("models/marioragdoll/Super Mario Galaxy/mario/mario.mdl")
	self.Ragdoll:SetParent(self.Entity)
	self.Ragdoll:Spawn()
	self.Ragdoll:SetCollisionGroup(GROUP_NONE)
	self.BodyFrame = ents.Create("player_wheel")
	self.BodyFrame:SetPos(self.Entity:GetPos())
	self.BodyFrame:SetModel("models/gmodcart/base_cart.mdl")
	self.BodyFrame:Spawn()
	self.BodyFrame:SetPos(self.Entity:GetPos() + Vector(0,0,6))
	self.BodyFrame:SetParent(self.Entity)
	self.BackWheel1 = ents.Create("player_wheel")
	self:SetNWEntity("Wheel1", self.BackWheel1)
	self.BackWheel1:SetPos(self.BodyFrame:GetPos() + Vector(-12,-21,2.4))
	self.BackWheel1:SetParent(self.Entity)
	self.BackWheel1:SetModel("models/gmodcart/base_cart_wheel.mdl")
	self.BackWheel1:Spawn()
	self.BackWheel2 = ents.Create("player_wheel")
	self:SetNWEntity("Wheel2", self.BackWheel2)
	self.BackWheel2:SetPos(self.BodyFrame:GetPos() + Vector(-12,21,2.4))
	self.BackWheel2:SetParent(self.Entity)
	self.BackWheel2:SetModel("models/gmodcart/base_cart_wheel.mdl")
	self.BackWheel2:Spawn()
	self.frontWheel1 = ents.Create("player_wheel")
	self.frontWheel1:SetPos(self.BodyFrame:GetPos() + Vector(35,-23,2.4))
	self.frontWheel1:SetParent(self.Entity)
	self.frontWheel1:SetModel("models/gmodcart/base_cart_wheel.mdl")
	self.frontWheel1:Spawn()
	self.frontWheel2 = ents.Create("player_wheel")
	self.frontWheel2:SetPos(self.BodyFrame:GetPos() + Vector(35,23,2.4))
	self.frontWheel2:SetParent(self.Entity)
	self.frontWheel2:SetModel("models/gmodcart/base_cart_wheel.mdl")
	self.frontWheel2:Spawn()
	self.SteerWheel1 = ents.Create("player_wheel")
	self.SteerWheel1:SetPos(self.BodyFrame:GetPos() - Vector(-6,0,4))
	self.SteerWheel1:SetParent(self.BodyFrame)
	constraint.NoCollide(self.SteerWheel1,self.BodyFrame,0,0)
	self.SteerWheel1:SetModel("models/gmodcart/regular_cart_steerwheel.mdl")
	self.SteerWheel1:Spawn()
	self.Entity:StartMotionController()
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
function ENT:Think()
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
			intForward = 0
			intBounce = 1
			intYaw = 0
		end
		-- Spin the wheels... Didnt work too well.
		--[[if vecVelocity.x >= 1 then
			self.BackWheel1:SetAngles(self.BackWheel1:GetAngles():Forward() * 10)
			self.BackWheel2:SetAngles(self.BackWheel2:GetAngles():Forward() * 10)
			self.frontWheel1:SetAngles(self.frontWheel1:GetAngles():Forward() * 10)
			self.frontWheel2:SetAngles(self.frontWheel2:GetAngles():Forward() * 10)
		elseif vecVelocity.x <= -1 then
			self.BackWheel1:SetAngles(self.BackWheel1:GetAngles():Forward() * -10)
			self.BackWheel2:SetAngles(self.BackWheel2:GetAngles():Forward() * -10)
			self.frontWheel1:SetAngles(self.frontWheel1:GetAngles():Forward() * -10)
			self.frontWheel2:SetAngles(self.frontWheel2:GetAngles():Forward() * -10)
		end]]
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
		Linear =  Linear/2
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
	if !self:GetOwner().wipeout && GetGlobalString("GameModeState") == "RACE" then
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
	if !self:GetOwner().wipeout && GetGlobalString("GameModeState") == "RACE" then
		if driver:KeyDown(IN_MOVELEFT) then return self:GetOwner().Turn end
		if driver:KeyDown(IN_MOVERIGHT) then return -1* (self:GetOwner().Turn) end
	end
	return self.vecAddativeAngularVelocity.z
end
