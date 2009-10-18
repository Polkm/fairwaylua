include('shared.lua')
ENT.Spawnable			= false
ENT.AdminSpawnable		= false

function ENT:Initialize()
	self.TehColor = Color(255, 255, 255, 255)
	self.matIcon = Material("cash_icon")
	self.iconHieght = 80
	self.iconMinHieght = 80
	self.iconMaxHieght = 85
	self.iconMoveSpeed = 0.02
end

function ENT:Draw()
	self:DrawModel()
	local ply = LocalPlayer() 
	render.SetMaterial(self.matIcon)
	self.iconHieght = self.iconHieght + self.iconMoveSpeed
	if self.iconHieght > self.iconMaxHieght or self.iconHieght < self.iconMinHieght then self.iconMoveSpeed = -self.iconMoveSpeed end
	self.TehColor.a = math.Clamp((205 - ply:GetPos():Distance(self:GetPos())), 0, 205) + 50
	local intIconSize = self.iconHieght / 5
	render.DrawSprite(self:GetPos() + Vector(0, 0, self.iconHieght), intIconSize, intIconSize, self.TehColor) 
end
