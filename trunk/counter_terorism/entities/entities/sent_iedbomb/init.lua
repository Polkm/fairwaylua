AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self.Entity:SetModel(MODELS[math.random(1,#MODELS)])	
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self:GetPhysicsObject():ApplyForceCenter(Vector(0,0,1))
	self.IsBeeping = false
end


function ENT:Think()
	local Dist = self:GetOwner():GetPos():Distance(self:GetPos())
	if Dist >= 1000 then
		local Flare = ents.Create("env_flare")
		Flare:SetPos(self:GetPos())
		Flare:SetKeyValue("scale",tostring(math.Round(Dist/500)))
		Flare:SetKeyValue("spawnflags","2")
		Flare:Spawn()
		Flare:Activate()
		timer.Simple(.5,function() Flare:Fire("Die",0) end)
		if !self.IsBeeping then
			self.IsBeeping = true
			self:EmitSound(Sound("weapons/c4/c4_beep1.wav"))
			timer.Simple(.4,function() self.IsBeeping = false end)
		end
	end
end

function ENT:OnTakeDamage(dmg)
	if dmg:GetAttacker():IsPlayer() then
		if self:IsValid() then
			self:Asplodeied()
		end
	end
end 

function ENT:Asplodeied()
	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	effectdata:SetNormal(self:GetPos())
	util.Effect("eff_Boomboom",effectdata)
	util.BlastDamage(self,self,self:GetPos(),100,200)
	util.ScreenShake(self:GetPos(),15,5,0.6,1200)
	self:EmitSound("weapon_AWP.Single",400,400)
end