AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
local MODEL = Model("models/dav0r/balloon/balloon.mdl")
ENT.Removed = false

function ENT:Initialize()
	self:SetModel(MODEL)
	self:PhysicsInit(SOLID_VPHYSICS)
	
	--Set up our physics object here
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(100)
		phys:Wake()
		phys:EnableGravity(false)
	end
	self:SetForce(1)
	self:StartMotionController()
end

function ENT:SetForce(force)
	self.Force = force * 5000
	self:SetOverlayText("Force: " .. math.floor(force))
end

function ENT:OnTakeDamage(dmginfo)
	--This is to stop a shit storm of stack overflow errors
	--If you can find a beter change it
	if self.Indestructible then return end
	if !self.Removed then
		local r, g, b = self:GetColor()
		
		local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetStart(Vector(r, g, b))
		util.Effect("balloon_pop", effectdata)
		
		local attacker = dmginfo:GetAttacker()
		if IsValid(attacker) and attacker:IsPlayer() then
			attacker:SendLua("achievements.BalloonPopped()")
		end
		
		self:Remove()
		self.Removed = true
		
		if self.Explosive then
			util.BlastDamage(self, self, self:GetPos(), 100, 50)
			local effectdata = EffectData()
			effectdata:SetOrigin(self:GetPos())
			effectdata:SetScale(1)
			effectdata:SetMagnitude(25)
			util.Effect("Explosion", effectdata, true, true)
		end
	end
end

function ENT:PhysicsSimulate(phys, deltatime)
	local vLinear = Vector(0, 0, self.Force) * deltatime
	local vAngular = Vector(0, 0, 0)

	return vAngular, vLinear, SIM_GLOBAL_FORCE
end