AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')


function ENT:Initialize()
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetSolid(SOLID_VPHYSICS)
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

function ENT:UseItem() 
	local cart = self:GetOwner():GetNWEntity("Cart")
	self:SetParent(nil)
	self.Entity:PhysicsInitSphere( 8.1, "metal_bouncy" )
	self.Entity:GetPhysicsObject():Wake()
	constraint.NoCollide(self.Entity,cart,0,0)
	self:SetAngles(cart:GetAngles())
	self:SetPos(cart:GetPos() - cart:GetAngles():Forward() * -30 + cart:GetAngles():Up() * 20)
	self.Entity:GetPhysicsObject():ApplyForceCenter(cart:GetAngles():Forward() + cart:GetAngles():Forward() * 1200)
	
	timer.Simple(1, function()
	constraint.RemoveAll(self.Entity)
	timer.Simple(30,function() if self:IsValid() then self:Remove() end end)
	end)
end

function ENT:PhysicsCollide(data,physobj)

	//if data.HitEntity:IsWorld() then
		local LastSpeed = math.max( data.OurOldVelocity:Length(), data.Speed )
		local NewVelocity = physobj:GetVelocity()
		NewVelocity = Vector(NewVelocity.x,NewVelocity.y,NewVelocity.z*0.5)
		NewVelocity:Normalize()
		LastSpeed = math.max( NewVelocity:Length(), LastSpeed )
		
		local TargetVelocity = NewVelocity * LastSpeed * 0.999999999999999999999999999999999999999
		
		physobj:SetVelocity( TargetVelocity )
	//elseif data.HitEntity:GetOwner():IsPlayer() then

	//end
end









function ENT:PhysicsSimulate(phys,deltatime) 
	trace = {}
	trace.start = self:GetPos()
	trace.filter = self
	trace.endpos = self:GetPos() - Vector(0,0,15)
	local tr = util.TraceLine(trace)
	local up = phys:GetAngle():Up()
	local driver = self:GetOwner()
	local forward = 1000
	local right = 0
	local Velocity = phys:GetVelocity()
	local ForwardVel = phys:GetAngle():Forward():Dot( Velocity )
	local RightVel = phys:GetAngle():Right():Dot( Velocity )
	local UpVel = phys:GetAngle():Up():Dot( Velocity )
	right = RightVel * 0.95
	
	forward = forward - ForwardVel * 0.2

	local Linear = ( Vector( forward, right, -5) ) * deltatime * 250;

	local AngleVel = phys:GetAngleVelocity() 

	local AngleFriction = Vector(AngleVel.x * -1.1,AngleVel.y * -50,AngleVel.z * -50)
	
	local Angular = (AngleFriction) ;
	return Angular, Linear, SIM_LOCAL_ACCELERATION
end

function ENT:PhysicsUpdate(phys) 
end

function ENT:Think() 
end
function ENT:Touch(ent) 
end
function ENT:UpdateTransmitState(Entity)
end
function ENT:Use(activator,caller)
end
