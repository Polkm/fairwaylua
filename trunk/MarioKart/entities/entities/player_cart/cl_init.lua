include('shared.lua')
ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.RenderGroup 		= RENDERGROUP_OPAQUE

function ENT:Draw()
	self.Entity:DrawModel()
	self:GetNWEntity("Wheel1"):SetModelScale(Vector(1,2,1))
	self:GetNWEntity("Wheel2"):SetModelScale(Vector(1,2,1))
end

