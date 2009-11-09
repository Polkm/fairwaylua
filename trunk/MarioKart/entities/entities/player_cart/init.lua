AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self.Entity:SetModel("models/gmodcart/regular_cart.mdl")
	self.Entity:SetMoveType( MOVETYPE_CUSTOM )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetCollisionGroup(GROUP_WORLD)
	self.Entity:SetNoDraw(true)
	self.Entity:GetPhysicsObject():SetMass( 100 )
	self.Ragdoll = ents.Create("prop_dynamic")
	self.Ragdoll:SetPos(self.Entity:GetPos() + Vector(5,0,7))
	self.Ragdoll:SetModel("models/marioragdoll/SuperMarioGalaxy/mario/mario.mdl")
	self.Ragdoll:SetParent(self.Entity)
	self.Ragdoll:Spawn()
	self.Ragdoll:SetCollisionGroup(GROUP_NONE)
	self.BodyFrame = ents.Create("player_wheel")
	self.BodyFrame:SetPos(self.Entity:GetPos())
	self.BodyFrame:Spawn()
	self.BodyFrame:SetModel("models/gmodcart/regular_cart.mdl")
	self.BodyFrame:SetPos(self.Entity:GetPos() + Vector(0,0,10))
	self.BodyFrame:SetParent(self.Entity)
	self.BackWheel1 = ents.Create("player_wheel")
	self.BackWheel1:SetPos(self.BodyFrame:GetPos() + Vector(-13,-21,5))
	self.BackWheel1:SetParent(self.Entity)
	self.BackWheel1:SetModel("models/gmodcart/cart_wheel.mdl")
	self.BackWheel1:Spawn()
	self.BackWheel2 = ents.Create("player_wheel")
	self.BackWheel2:SetPos(self.BodyFrame:GetPos() + Vector(-13,21,5))
	self.BackWheel2:SetParent(self.Entity)
	self.BackWheel2:SetModel("models/gmodcart/cart_wheel.mdl")
	self.BackWheel2:Spawn()
	self.frontWheel1 = ents.Create("player_wheel")
	self.frontWheel1:SetPos(self.BodyFrame:GetPos() + Vector(35,-21,5))
	self.frontWheel1:SetParent(self.Entity)
	self.frontWheel1:SetModel("models/gmodcart/cart_wheel.mdl")
	self.frontWheel1:Spawn()
	self.frontWheel2 = ents.Create("player_wheel")
	self.frontWheel2:SetPos(self.BodyFrame:GetPos() + Vector(35,21,5))
	self.frontWheel2:SetParent(self.Entity)
	self.frontWheel2:SetModel("models/gmodcart/cart_wheel.mdl")
	self.frontWheel2:Spawn()
	self.SteerWheel1 = ents.Create("player_wheel")
	self.SteerWheel1:SetPos(self.BodyFrame:GetPos())
	self.SteerWheel1:SetParent(self.BodyFrame)
	constraint.NoCollide(self.SteerWheel1,self.BodyFrame,0,0)
	self.SteerWheel1:SetModel("models/gmodcart/regular_cart_steerwheel.mdl")
	self.SteerWheel1:Spawn()
	self.Entity:StartMotionController()
end

function ENT:OnTakeDamage(dmginfo)
end
function ENT:StartTouch(ent) 

end
function ENT:EndTouch(ent)
end
function ENT:AcceptInput(name,activator,caller)
end
function ENT:KeyValue(key,value)
end
function ENT:OnRemove()
end
function ENT:OnRestore()
end
function ENT:PhysicsCollide(data,physobj)
end

function ENT:PhysicsSimulate( phys, deltatime )
	local up = phys:GetAngle():Up()
	trace = {}
	trace.start = self:GetPos()
	trace.filter = self
	trace.endpos = self:GetPos() - Vector(0,0,10)
	local tr = util.TraceLine(trace)
	if ( up.z < 0.33 ) || !tr.Hit then
		return SIM_NOTHING
	end
	local driver = self:GetOwner()
	local forward = 0
	local right = 0
	local Velocity = phys:GetVelocity()
	local ForwardVel = phys:GetAngle():Forward():Dot( Velocity )
	local RightVel = phys:GetAngle():Right():Dot( Velocity )
	if ( driver ) then
		forward = self:GetForwardAcceleration( driver, phys, ForwardVel )
		bounce = self:GetUpAcceleration( driver , phys , ForwardVel)
		/*if Velocity.x >= 1 then
			self.BackWheel1:SetAngles(self.BackWheel1:GetAngles():Forward() * 10)
			self.BackWheel2:SetAngles(self.BackWheel2:GetAngles():Forward() * 10)
			self.frontWheel1:SetAngles(self.frontWheel1:GetAngles():Forward() * 10)
			self.frontWheel2:SetAngles(self.frontWheel2:GetAngles():Forward() * 10)
		elseif Velocity.x <= -1 then
			self.BackWheel1:SetAngles(self.BackWheel1:GetAngles():Forward() * -10)
			self.BackWheel2:SetAngles(self.BackWheel2:GetAngles():Forward() * -10)
			self.frontWheel1:SetAngles(self.frontWheel1:GetAngles():Forward() * -10)
			self.frontWheel2:SetAngles(self.frontWheel2:GetAngles():Forward() * -10)
		end */
		yaw		= self:GetTurnYaw( driver, phys, ForwardVel )
		if yaw > 0 then
			self.frontWheel1:SetAngles(self.Entity:GetAngles() + Angle(0,15,0))
			self.frontWheel2:SetAngles(self.Entity:GetAngles() + Angle(0,15,0))
		elseif yaw < 0 then
			self.frontWheel1:SetAngles(self.Entity:GetAngles() + Angle(0,-15,0))
			self.frontWheel2:SetAngles(self.Entity:GetAngles() + Angle(0,-15,0))
		else
			self.frontWheel1:SetAngles(self.Entity:GetAngles() )
			self.frontWheel2:SetAngles(self.Entity:GetAngles() )
		end
	end

	right = RightVel * 0.95


	forward = forward - ForwardVel * 0.01
	

	local Linear = ( Vector( forward, right, bounce ) ) * deltatime * 250;
	

	local AngleVel = phys:GetAngleVelocity()

	local AngleFriction = AngleVel * -1.1
	
	local Angular = (AngleFriction + Vector( 0, 0, yaw )) * deltatime * 250;

	return Angular, Linear, SIM_LOCAL_ACCELERATION
end

function ENT:PhysicsUpdate(phys) 
end
function ENT:Think()
	local phys = self.Entity:GetPhysicsObject()
	if ( phys && self:GetOwner() ) then
		phys:Wake()
	end
end

function ENT:GetForwardAcceleration( driver, phys, ForwardVel )
	if (!driver || !driver:IsValid()) then return 0 end
	if ( driver:KeyDown( IN_FORWARD ) ) then return 250 end
	if ( driver:KeyDown( IN_BACK ) ) then return -150 end
	return 0
end

function ENT:GetUpAcceleration( driver, phys, ForwardVel )
	if (!driver || !driver:IsValid()) then return 0 end
	if ( driver:KeyDown( IN_JUMP ) ) then return 250 end
	return 0
end

function ENT:GetTurnYaw( driver, phys, ForwardVel )
	if ( !driver || !driver:IsValid() ) then return 0 end
	if ( driver:KeyDown( IN_MOVELEFT ) ) then return 150 end
	if ( driver:KeyDown( IN_MOVERIGHT ) ) then return -150 end
	return 0
end

function ENT:Touch(ent) 
end
function ENT:UpdateTransmitState(Entity)
end
function ENT:Use(activator,caller)
	
end
