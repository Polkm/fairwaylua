include('shared.lua')
ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.RenderGroup 		= RENDERGROUP_OPAQUE

ENT.Number = 0
ENT.Tick = 50
ENT.AngularThrow = Angle(0.5, 0.5, 0.5)
ENT.TargetColor = Color(math.random(100, 255), math.random(100, 255), math.random(100, 255), 175)

function ENT:Draw()
	self:DrawModel()
	self:SetAngles(self:GetAngles() + self.AngularThrow)
	local clrNowColorR, clrNowColorG, clrNowColorB, clrNowColorA  = self:GetColor()
	local clrNextColor = Color(
		math.Clamp(clrNowColorR + ((self.TargetColor.r - clrNowColorR ) / self.Tick), 0, 255),
		math.Clamp(clrNowColorG + ((self.TargetColor.b - clrNowColorG) / self.Tick), 0, 255),
		math.Clamp(clrNowColorB + ((self.TargetColor.g - clrNowColorB) / self.Tick), 0, 255),
		math.Clamp(clrNowColorA + ((self.TargetColor.a - clrNowColorA) / self.Tick), 0, 255))
	self:SetColor(clrNextColor.r, clrNextColor.g, clrNextColor.b, clrNextColor.a)
	if self.Number >= self.Tick then
		self.TargetColor = Color(math.random(100, 255), math.random(100, 255), math.random(100, 255), 175)
		self.Number = 0
	end
	self.Number = self.Number + 1
end

