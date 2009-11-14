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
	
end

function ENT:PhysicsCollide(data,physobj)
	if data.HitEntity:IsWorld() then
		if self.class == "item_koopashell_red" && self.Activated then 
			if data.Speed && math.abs(data.HitPos.z - self:GetPos().z) < 1 then
				self:Remove()
			end
		end
		local LastSpeed = math.max( data.OurOldVelocity:Length(), data.Speed )
		local NewVelocity = physobj:GetVelocity()
		NewVelocity = Vector(NewVelocity.x,NewVelocity.y,NewVelocity.z*0.25)
		NewVelocity:Normalize()
		LastSpeed = math.max( NewVelocity:Length(), LastSpeed )
		
		local TargetVelocity = NewVelocity * LastSpeed * 0.999999999999999999999999999999999999999
		
		physobj:SetVelocity( TargetVelocity )
	else
		for k,v in pairs(player.GetAll()) do
			if data.HitEntity:GetOwner():GetNWEntity("Cart") == v:GetNWEntity("Cart") then
				data.HitEntity:Wipeout(GAMEMODE.mk_Items[self.class].WipeOutType)
				self:Remove()
				return
			end
		end	
	end
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
	if self.class == "item_koopashell_red" then 
		if self.Activated then
			self.Entity:GetPhysicsObject():ApplyForceCenter((self.target:GetPos() - self.Entity:GetPos()) * 3)
		end
	end
end

function ENT:Touch(ent) 
end
function ENT:UpdateTransmitState(Entity)
end
function ENT:Use(activator,caller)
end
