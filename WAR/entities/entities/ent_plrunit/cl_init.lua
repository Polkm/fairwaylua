include('shared.lua')

local CircleMat = Material("SGM/playercircle")
function ENT:Draw()
	self.Entity:DrawModel()
	if !self:GetOwner() then return end
	if LocalPlayer():Team() == self:GetOwner():Team() then
		if self.Lastpos != self:GetPos() then
			local trace = {}
			trace.start = self:GetPos() + Vector(0,0,5)
			trace.endpos = trace.start + Vector(0,0,-200)
			trace.filter = ents.FindByClass("ent_plrunit")
			self.LastTrace = util.TraceLine(trace)
			self.Lastpos = self:GetPos()
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
		
		render.SetMaterial(CircleMat)
		render.DrawQuadEasy(
			self.LastTrace.HitPos + self.LastTrace.HitNormal,
			self.LastTrace.HitNormal, 
			40, 40, color)
	end
end