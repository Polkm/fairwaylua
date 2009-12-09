AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	Bombplanted = true
	self.Entity:SetModel("models/weapons/w_c4_planted.mdl")	
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self:GetPhysicsObject():EnableMotion(false)
	self.Entity.Timer = 0
	timer.Simple(1,function() self:TimerAdd() end)
	for k,v in pairs(player.GetAll()) do
		BOMBPL(v)
		team.SetScore(TEAM_TERROR, team.GetScore(TEAM_TERROR)+1)
	end
end
function ENT:TimerAdd()
	self.Entity.Timer = self.Entity.Timer + 1
	self:ChangeBeep()
	if self.Entity.Timer >= 45 then	
		self:Asplode()
	elseif self.Entity.Timer < 45 then	
		timer.Simple(1,function() self:TimerAdd() end)
	end
end
function ENT:Asplode()
	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	effectdata:SetNormal(self:GetPos())
	util.Effect("eff_Boomboom",effectdata)
	util.BlastDamage(self,self,self:GetPos(),600,300)
	util.ScreenShake(self:GetPos(),15,5,0.6,1200)
	self:EmitSound("weapon_AWP.Single",400,400)
	PrintMessage(HUD_PRINTCENTER,"TERRORISTS WIN")
	for k,v in pairs(player.GetAll()) do
		TERWIN(v)
		team.SetScore(TEAM_TERROR, team.GetScore(TEAM_TERROR)+1)
	end
	timer.Simple(1,function() self:Remove() end)
	timer.Simple(3,EndGame())
end
function ENT:Think() 
end

function ENT:ChangeBeep()
	self:EmitSound(Sound("weapons/c4/c4_beep1.wav"))
	if self.Entity.Timer >= 25	then  
		timer.Simple(0.5,function() self:EmitSound(Sound("weapons/c4/c4_beep1.wav")) end) 
	end
end

function ENT:Use( activator, caller )
	if activator:IsPlayer() then
		if activator:Team() == TEAM_CT then 
			activator:Freeze( true ) 
			diffuse(activator,self)
		end
	end
end
