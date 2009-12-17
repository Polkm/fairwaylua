AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	SetGlobalBool("Bombplanted",true)
	SetGlobalEntity("TheBomb", self)
	SetGlobalInt("BombTime",0)
	self.Time = 0.5
	self.Entity:SetModel("models/weapons/w_c4_planted.mdl")	
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self:GetPhysicsObject():EnableMotion(false)
	self.Timer = 0
	self:TimerAdd()
end

function ENT:TimerAdd()
	self.Entity.Timer = self.Entity.Timer + 1
	SetGlobalInt("BombTime",self.Entity.Timer)
	self:ChangeBeep()
	if self.Entity.Timer >= 45 then	
		self:Asplode()
	/*elseif self.Entity.Timer == 43 then
		local lastent = nil
		for _,camera in pairs(ents.FindByClass("End_Camera")) do
			if lastent != nil && lastent:GetPos():Distance(self:GetPos()) > camera:GetPos():Distance(self:GetPos()) then
				lastent = camera
			end
		end
			for _,playr in pairs(player.GetAll()) do 
				if playr:Team() > 0 && playr:Alive() then
					playr:Spectate(lastent)
				end
			end
		timer.Simple(1,function() if self:IsValid() then self:TimerAdd() end end)*/
	elseif self.Entity.Timer < 45 then	
		timer.Simple(1,function() if self:IsValid() then self:TimerAdd() end end)
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
	for _,playr in pairs(player.GetAll()) do
		playr:ConCommand("PlayAlert ts_win")
	end
	GAMEMODE:RoundEndWithResult(TEAM_TERRORIST)
	self:Remove()
end

function ENT:Think() 
end

function ENT:ChangeBeep()
	self:EmitSound(Sound("weapons/c4/c4_beep1.wav"))
	if self.Timer >= 20 then
		print(self.Timer)
		if !self.Beacon then 
			local beacon = ents.Create("beacon_small")
			beacon:SetPos(self:GetPos())
			beacon:Spawn()
		end
		timer.Simple(self.Time,function() if self:IsValid() then self:EmitSound("weapons/c4/c4_beep1.wav") end end )		
		if self.Timer >= 35 then
			self.Time = 0.33
			self:EmitSound(Sound("weapons/c4/c4_beep1.wav"))
			timer.Simple( self.Time * 2,function() if self:IsValid() then self:EmitSound("weapons/c4/c4_beep1.wav") end end )	
		end
	end
end

function ENT:Use( activator, caller )
	if activator:IsPlayer() then
		if activator:Team() == TEAM_COUNTERTERRORIST then 
			activator:Freeze( true ) 
			GAMEMODE:Diffuse(activator,self)
		end
	end
end
