AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

ENT.Bobnumber = 0
ENT.Increase = false

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
function ENT:PhysicsCollide(data,physobj)
	if data.HitEntity:IsWorld() then
		local oldspeed = data.OurOldVelocity
		self:SetVelocity(oldspeed + oldspeed * -2)
		
	end
end
function ENT:PhysicsSimulate(phys,deltatime) 
	print("running")
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

function ENT:UseItem() 
	print("fired")
	constraint.NoCollide(self,self:GetOwner(),0,0)
	self:SetParent(nil)
	self:SetAngles(self:GetOwner():GetNWEntity("Cart"):GetAngles())
	self:SetPos(self:GetOwner():GetNWEntity("Cart"):GetPos() - self:GetOwner():GetNWEntity("Cart"):GetAngles():Forward() * -30 + self:GetOwner():GetNWEntity("Cart"):GetAngles():Up() * 20)
	self:StartMotionController()
	timer.Simple(5, function()
	constraint.RemoveAll(self)
	timer.Simple(30,function() if self:IsValid() then self:Remove() end end)
	end)
end

function ENT:Think() 
end
function ENT:Touch(ent) 
end
function ENT:UpdateTransmitState(Entity)
end
function ENT:Use(activator,caller)
end
