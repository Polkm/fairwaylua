AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
include('schds.lua')

function ENT:Initialize()
	self:SetModel(Models[math.random(1,#Models)])
	self:SetHullType(HULL_HUMAN);
	self:SetHullSizeNormal();
	self:SetSolid(SOLID_BBOX)
	self:SetMoveType(MOVETYPE_STEP)
	self:CapabilitiesAdd(CAP_MOVE_GROUND | CAP_ANIMATEDFACE | CAP_TURN_HEAD)
	self:SetMaxYawSpeed(30)
	self:SetHealth(40)
	self:SetVar("IsPlayingSound",false)
	self:SelectSchedule()
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
	--CHECK DIED
	if dmg:GetAttacker():GetActiveWeapon():GetClass() == "weapon_fiveseven" then
		local beacon = ents.Create("beacon_small")
		beacon:SetPos(self:GetOwner():GetPos()) 
		beacon:Spawn()
	end
	self.Panic = true
	self.PanicPos = self:GetPos()
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
		if self.PanicPos != nil && self:GetPos():Distance(self.PanicPos) <= math.random(1500,2500) then 
			self:StartSchedule(schdFleeShot)
		else
			self.Panic = false
			self.PanicPos = nil
		end
	else
		if ActionChose >= 8 then
			self:StartSchedule(schdRun)

		else
			self:StartSchedule(schdWander)
		end
	end
end 
