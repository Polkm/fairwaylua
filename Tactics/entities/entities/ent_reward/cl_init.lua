include('shared.lua')
ENT.Spawnable			= false
ENT.AdminSpawnable		= false

function ENT:Initialize()
	self.matIcon = Material("ammo_icon")
	if self:GetNWString("type") == "health" then self.matIcon = Material("health_icon") end
	if self:GetNWString("type") == "cash" then self.matIcon = Material("cash_icon") end
	self.iconHieght = 25
	self.iconMinHieght = 25
	self.iconMaxHieght = 30
	self.iconMoveSpeed = 0.02
end

function ENT:Draw()
	self:DrawModel()
	local ply = LocalPlayer() 
	if self:GetNWEntity("PropProtector") != "none" && self:GetNWEntity("PropProtector") != ply then return end
	render.SetMaterial(self.matIcon)
	self.iconHieght = self.iconHieght + self.iconMoveSpeed
	if self.iconHieght > self.iconMaxHieght or self.iconHieght < self.iconMinHieght then self.iconMoveSpeed = -self.iconMoveSpeed end
	render.DrawSprite(self:GetPos() + Vector(0, 0, self.iconHieght), 20, 20, Color(150, 255, 150, 255))
end