include('shared.lua')
ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.RenderGroup 		= RENDERGROUP_OPAQUE

ENT.Number = 0

function ENT:Draw()
	self.Entity:DrawModel()
	self.Entity:SetAngles(self.Entity:GetAngles() + Angle(0.5,0.5,0.5))
	if self.Number >= 10 then
		self.Entity:SetColor(math.random(100,255),math.random(100,255),math.random(100,255),175)
		self.Number = 0
	end
	self.Number = self.Number + 1
end

