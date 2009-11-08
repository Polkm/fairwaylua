
/*---------------------------------------------------------
   Clientside Vehicles Base
---------------------------------------------------------*/

resource.AddFile("models/gmodcart/regular_cart.mdl")
resource.AddFile("models/gmodcart/regular_cart_wheel.mdl")
resource.AddFile("models/gmodcart/regular_cart_steerwheel.mdl")
resource.AddFile("materials/models/gmodcart/CartBody.vmt")
resource.AddFile("materials/models/gmodcart/CartBody.vtf")
resource.AddFile("materials/models/gmodcart/Wheel.vmt")
resource.AddFile("materials/models/gmodcart/Wheel.vtf")

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )


function ENT:SetupModel()
	self.Entity:SetModel("models/gmodcart/regular_cart.mdl")
	self.Entity:SetPos(self.Entity:GetPos() *  Vector(0,0,10))
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetCollisionGroup(11)
	self.Axis = ents.Create("player_wheel")
	self.Axis:SetNoDraw(false)
	self.Axis:SetPos(self.Entity:GetPos())
	self.Axis:Spawn()
	constraint.Weld(self.Axis,self.Entity,0,0,0,true)
	self.Axis:SetCollisionGroup(0)
	self.BackWheel1 = ents.Create("player_wheel")
	self.BackWheel1:PhysicsInit(SOLID_VPHYSICS)
	self.BackWheel1:SetMoveType(MOVETYPE_VPHYSICS)
	self.BackWheel1:SetSolid(SOLID_VPHYSICS)
	self.BackWheel1:SetPos(self.Entity:GetPos() + Vector(-13,-21,5))
	//self.BackWheel1:SetParent(self.Entity)
	self.BackWheel1:SetCollisionGroup(11)
	self.BackWheel1:Spawn()
	//constraint.Weld(self.BackWheel1,self.Entity,0,0,0,true)
	constraint.Axis(self.Entity ,self.BackWheel1,
                0, 0,
               self.Entity:GetPos() + Vector(-13,-30,5), self.BackWheel1:GetPos(),
                0, 0,
                0, 1,
                self.BackWheel1:GetPos())
	self.BackWheel2 = ents.Create("player_wheel")
	self.BackWheel2:PhysicsInit(SOLID_VPHYSICS)
	self.BackWheel2:SetMoveType(MOVETYPE_VPHYSICS)
	self.BackWheel2:SetSolid(SOLID_VPHYSICS)
	self.BackWheel2:SetPos(self.Entity:GetPos() + Vector(-13,21,5))
	//self.BackWheel2:SetParent(self.Entity)
	self.BackWheel2:SetCollisionGroup(11)
	self.BackWheel2:Spawn()
	//constraint.Weld(self.BackWheel2,self.Entity,0,0,0,true)
		constraint.Axis(self.Entity ,self.BackWheel2,
                0, 0,
               self.Entity:GetPos() + Vector(-13,30,5), self.BackWheel2:GetPos(),
                0, 0,
                0, 1,
                self.BackWheel2:GetPos())
	self.frontWheel1 = ents.Create("player_wheel")
	self.frontWheel1:PhysicsInit(SOLID_VPHYSICS)
	self.frontWheel1:SetMoveType(MOVETYPE_VPHYSICS)
	self.frontWheel1:SetSolid(SOLID_VPHYSICS)
	self.frontWheel1:SetPos(self.Entity:GetPos() + Vector(35,-21,5))
	//self.frontWheel1:SetParent(self.Entity)
	self.frontWheel1:SetCollisionGroup(11)
	self.frontWheel1:Spawn()
	//constraint.Weld(self.frontWheel1,self.Entity,0,0,0,true)
		constraint.Axis(self.Entity ,self.frontWheel1,
                0, 0,
               self.Entity:GetPos() + Vector(35,-30,5), self.frontWheel1:GetPos(),
                0, 0,
                0, 1,
                self.frontWheel1:GetPos())
				
	self.frontWheel2 = ents.Create("player_wheel")
	self.frontWheel2:PhysicsInit(SOLID_VPHYSICS)
	self.frontWheel2:SetMoveType(MOVETYPE_VPHYSICS)
	self.frontWheel2:SetSolid(SOLID_VPHYSICS)
	self.frontWheel2:SetPos(self.Entity:GetPos() + Vector(35,21,5))
	//self.frontWheel2:SetParent(self.Entity)
	self.frontWheel2:SetCollisionGroup(11)
	self.frontWheel2:Spawn()
	//constraint.Weld(self.frontWheel2,self.Entity,0,0,0,true)
	constraint.Axis(self.Entity ,self.frontWheel2,
                0, 0,
               self.Entity:GetPos() + Vector(35,30,5), self.frontWheel2:GetPos(),
                0, 0,
                0, 1,
                self.frontWheel2:GetPos())
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

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()
	self:SetupModel()
	self:SharedInitialize()
	
end






