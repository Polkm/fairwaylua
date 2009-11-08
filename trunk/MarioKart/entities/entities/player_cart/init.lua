AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self.Entity:SetModel("models/gmodcart/regular_cart.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:SetCollisionGroup(11)
	self.BackWheel1 = ents.Create("player_wheel")
	self.BackWheel1:PhysicsInit(SOLID_VPHYSICS)
	self.BackWheel1:SetMoveType(MOVETYPE_VPHYSICS)
	self.BackWheel1:SetSolid(SOLID_VPHYSICS)
	self.BackWheel1:SetPos(self.Entity:GetPos() + Vector(-13,-23,5))
	//self.BackWheel1:SetParent(self.Entity)
	self.BackWheel1:SetCollisionGroup(11)
	self.BackWheel1:Spawn()
	constraint.Weld(self.BackWheel1,self.Entity,0,0,0,true)
	self.BackWheel2 = ents.Create("player_wheel")
	self.BackWheel2:PhysicsInit(SOLID_VPHYSICS)
	self.BackWheel2:SetMoveType(MOVETYPE_VPHYSICS)
	self.BackWheel2:SetSolid(SOLID_VPHYSICS)
	self.BackWheel2:SetPos(self.Entity:GetPos() + Vector(-13,23,5))
	//self.BackWheel2:SetParent(self.Entity)
	self.BackWheel2:SetCollisionGroup(11)
	self.BackWheel2:Spawn()
	constraint.Weld(self.BackWheel2,self.Entity,0,0,0,true)
	self.frontWheel1 = ents.Create("player_wheel")
	self.frontWheel1:PhysicsInit(SOLID_VPHYSICS)
	self.frontWheel1:SetMoveType(MOVETYPE_VPHYSICS)
	self.frontWheel1:SetSolid(SOLID_VPHYSICS)
	self.frontWheel1:SetPos(self.Entity:GetPos() + Vector(35,-21,3))
	//self.frontWheel1:SetParent(self.Entity)
	self.frontWheel1:SetCollisionGroup(11)
	self.frontWheel1:Spawn()
	constraint.Weld(self.frontWheel1,self.Entity,0,0,0,true)
	self.frontWheel2 = ents.Create("player_wheel")
	self.frontWheel2:PhysicsInit(SOLID_VPHYSICS)
	self.frontWheel2:SetMoveType(MOVETYPE_VPHYSICS)
	self.frontWheel2:SetSolid(SOLID_VPHYSICS)
	self.frontWheel2:SetPos(self.Entity:GetPos() + Vector(35,21,3))
	//self.frontWheel2:SetParent(self.Entity)
	self.frontWheel2:SetCollisionGroup(11)
	self.frontWheel2:Spawn()
	constraint.Weld(self.frontWheel2,self.Entity,0,0,0,true)
	self.SteerWheel1 = ents.Create("player_wheel")
	self.SteerWheel1:PhysicsInit(SOLID_VPHYSICS)
	self.SteerWheel1:SetMoveType(MOVETYPE_VPHYSICS)
	self.SteerWheel1:SetSolid(SOLID_VPHYSICS)
	self.SteerWheel1:SetPos(self.Entity:GetPos())
	self.SteerWheel1:SetParent(self.Entity)
	self.SteerWheel1:SetCollisionGroup(11)
	constraint.NoCollide(self.SteerWheel1,self.Entity,0,0)
	self.SteerWheel1:Spawn()
	self.SteerWheel1:SetModel("models/gmodcart/regular_cart_steerwheel.mdl")
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
function ENT:PhysicsSimulate(phys,deltatime) 
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
