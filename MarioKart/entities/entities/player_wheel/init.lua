AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetCollisionGroup(GROUP_NONE)
	self.Entity:PhysicsInit(SOLID_NONE)
end
