include('shared.lua')
local matSellectionCircle = Material("SGM/playercircle")
local intCircleSize = 50

function ENT:Initialize()
	self.GunProp = ents.Create("prop_physics")
	self.GunProp:SetPos(util.LocalToWorld(self, Vector(3, 4, 9), 0))
	self.GunProp:SetAngles(self:GetAngles() + Angle(0, 0, -90))
	self.GunProp:SetModel("models/weapons/w_smg1.mdl")
	self.GunProp:SetParent(self)
	self.GunProp:Spawn()
end

function ENT:Think()
	local strWeapon = self:GetNWString("weapon")
	local strClass = self:GetNWString("class")
	if self.GunProp && self.GunProp:IsValid() && strWeapon then
		local tblWeaponTable = GAMEMODE.Data.Equiptment[strWeapon]
		if tostring(self.GunProp:GetModel()) != tostring(tblWeaponTable.Model) then
			print(tblWeaponTable.Model, self.GunProp:GetModel())
			self.GunProp:SetModel(tblWeaponTable.Model)
		end
	end
	if strClass && GAMEMODE.Data.Units[strClass] then
		local tblUnitTable = GAMEMODE.Data.Units[strClass]
		if intCircleSize != tblUnitTable.CircleSize then
			intCircleSize = tblUnitTable.CircleSize
		end
	end
end

function ENT:Draw()
	self:DrawModel()
	if !self:GetOwner() then return end
	if LocalPlayer():Team() == self:GetOwner():Team() then
		if math.Round(self.LastHieght) != math.Round(self:GetPos().z) then
			print("new trace")
			local trace = {}
			trace.start = self:GetPos() + Vector(0, 0, 5)
			trace.endpos = trace.start + Vector(0, 0, -100)
			trace.filter = ents.FindByClass("ent_plrunit")
			self.LastTrace = util.TraceLine(trace)
			self.LastHieght = self:GetPos().z
		end

		if not self.LastTrace.HitWorld then self.LastTrace.HitPos = self:GetPos() end

		local color = Color(150, 150, 20, 0)
		if LocalPlayer() == self:GetOwner() then
			color = Color(20, 150, 20, 0)
		end
		if self:GetNWBool("sellected") && LocalPlayer() == self:GetOwner() then
			color.a = 150
		else
			color.a = 50
		end
		
		render.SetMaterial(matSellectionCircle)
		render.DrawQuadEasy(
			self:GetPos() + Vector(0, 0, self.LastTrace.HitPos.z - self:GetPos().z) + self.LastTrace.HitNormal,
			self.LastTrace.HitNormal, 
			intCircleSize, intCircleSize, color)
	end
end