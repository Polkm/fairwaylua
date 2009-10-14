include('shared.lua')
ENT.Spawnable			= false
ENT.AdminSpawnable		= false
function ENT:Initialize()
	self.TehColor = Color(255, 255, 255, 255)
	self.matIcon = Material(self.AmmoIcon)
	self.iconHieght = 25
	self.iconMinHieght = 25
	self.iconMaxHieght = 30
	self.iconMoveSpeed = 0.02
	if self:GetNWString("type") == "health" then
		self.matIcon = Material(self.HealthIcon)
		local intAmountToGive = 50
		if self:GetNWString("amount") == "full" then intAmountToGive = 100 end
		self.TehColor = Color(100 - intAmountToGive * 2.55, intAmountToGive * 2.55, 0, 255)
	elseif self:GetNWString("type") == "cash" then
		self.matIcon = Material(self.CashIcon)
		self.TehColor = Color(255, 255, 71, 255)
	end
end

function ENT:Draw()
	self:DrawModel()
	local ply = LocalPlayer() 
	if self:GetNWEntity("PropProtector") != "none" && self:GetNWEntity("PropProtector") != ply then return end
	render.SetMaterial(self.matIcon)
	self.iconHieght = self.iconHieght + self.iconMoveSpeed
	if self.iconHieght > self.iconMaxHieght or self.iconHieght < self.iconMinHieght then self.iconMoveSpeed = -self.iconMoveSpeed end
	self.TehColor.a = math.Clamp((205 - ply:GetPos():Distance(self:GetPos())), 0, 205) + 50
	local intIconSize = self.iconHieght / 1.7
	render.DrawSprite(self:GetPos() + Vector(0, 0, self.iconHieght), intIconSize, intIconSize, self.TehColor)
end

 