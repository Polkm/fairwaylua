include('shared.lua')
ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.RenderGroup 		= RENDERGROUP_OPAQUE

function ENT:Draw()
	self.Entity:DrawModel()
	self:GetNWEntity("Wheel1"):SetModelScale(Vector(1,2,1))
	self:GetNWEntity("Wheel2"):SetModelScale(Vector(1,2,1))
	local effectdata = EffectData()
	effectdata:SetEntity(self)
	effectdata:SetOrigin(self:GetPos() + (self:GetAngles():Forward() * -20) + (self:GetAngles():Up() * 30))
	effetdata:SetStart(self:GetPos() + (self:GetAngles():Forward() * -20) + (self:GetAngles():Up() * 30))
	effectdata:SetScale( 1 )
	util.Effect("WheelDust", effectdata)	
end

