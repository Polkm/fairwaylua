include('shared.lua')
ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.RenderGroup 		= RENDERGROUP_OPAQUE
ENT.Number = 0
function ENT:Draw()
	self.Entity:DrawModel()
	if self:GetNWString("item") == "item_badbox" then
		self.Entity:SetAngles(self.Entity:GetAngles() + Angle(0.5,0.5,0.5))
		if self.Number >= 10 then
			self.Entity:SetColor(math.random(100,255),math.random(100,255),math.random(100,255),175)
			self.Number = 0
		end
		self.Number = self.Number + 1
	elseif self:GetNWString("item") == "item_koopashell_green" ||  self:GetNWString("item") == "item_koopashell_red" ||  self:GetNWString("item") == "item_koopashell_blue" then
		self.Entity:SetAngles(self.Entity:GetAngles() + Angle(0,0.5,0))
	end
end

