AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
include('schds.lua')

function ENT:Initialize()
	local model = MaleModels[math.random(1,#MaleModels)]
	local MaleorFemale = math.random(0,1) 
	if MaleorFemale == 1 then
		self.Male = true
	else
		model = FemaleModels[math.random(1,#FemaleModels)]
	end
	self:SetModel(model)
	self:SetHullType(HULL_HUMAN);
	self:SetHullSizeNormal();
	self:SetSolid(SOLID_BBOX)
	self:SetMoveType(MOVETYPE_STEP)
	self:CapabilitiesAdd(CAP_MOVE_GROUND | CAP_ANIMATEDFACE | CAP_TURN_HEAD)
	self:SetMaxYawSpeed(30)
	self:SetHealth(30)
	self:SetVar("IsPlayingSound",false)
	self:SelectSchedule()
end

function ENT:Think()
	if self.Panic then
		local num = math.random(1,30)
		if !self.soundplaying then
			if num == 1 then
				self.soundplaying = true
				if self.Male then 
					self:EmitSound(PanicMaleSounds[math.random(1,#PanicMaleSounds)],90,100)
				else
					self:EmitSound(PanicFemaleSounds[math.random(1,#PanicFemaleSounds)],90,100)
				end
				timer.Simple(math.random(2,4),function() if self:IsValid() then self.soundplaying = false end end)
			end
		end
	end
end

function ENT:OnTakeDamage(dmg)
	umsg.Start('zomblood');
		umsg.Vector(dmg:GetDamagePosition());
	umsg.End();
	--SET VARS
	self:SetHealth(self:Health() - dmg:GetDamage())
	--PLAY SOUNDS
	if string.find(string.lower(self.Entity:GetModel()),"female") then
		self.Entity:EmitSound(Sound("vo/npc/female01/pain0"..math.random(1,9)..".wav"),100,100)
	else
		self.Entity:EmitSound(Sound("vo/npc/male01/pain0"..math.random(1,9)..".wav"),100,100)
	end
	self.PanicEnt = dmg:GetAttacker()
	--CHECK DIED
	print(self:GetPos():Distance(dmg:GetAttacker():GetPos()))
	if dmg:GetAttacker():GetActiveWeapon():GetClass() == "weapon_fiveseven" && self:GetPos():Distance(dmg:GetAttacker():GetPos()) >= 1000 then
		local beacon = ents.Create("beacon_small")
		beacon:SetPos(self:GetPos()) 
		beacon:Spawn()
	end
	self.Panic = true
	if self:Health() <= 0 then
		self:Ragdoll(dmg)
		self.Entity:Remove()
		return
	end
	self:SetSchedule(schdFleeShot)
end 

function ENT:SelectSchedule()
	local ActionChose = math.random(1,10)
	if self.Panic then
		if self.PanicEnt:IsValid() && self:GetPos():Distance(self.PanicEnt:GetPos()) <= math.random(1500,2500) then 
			self:StartSchedule(schdFleeShot)
		else
			self.Panic = false
			self.PanicEnt = nil
		end
	else
		if ActionChose >= 8 then
			self:StartSchedule(schdRun)

		else
			self:StartSchedule(schdWander)
		end
	end
end 
