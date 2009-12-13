AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
include('schds.lua')

ENT.NPCDataTable = {}
ENT.Threat = 0
ENT.HasTarget = false
ENT.IsRespondingToBeacon = false
ENT.LastEnemyPos = Vector(0,0,0)
ENT.NeedsToChase = false
ENT.LastEnemy = nil
ENT.IsChasing = false

function ENT:Initialize()
	self:SetModel(Models.female[0])
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetSolid(SOLID_BBOX) 
	self:SetMoveType(MOVETYPE_STEP)
	self:CapabilitiesAdd(CAP_MOVE_GROUND | CAP_OPEN_DOORS | CAP_ANIMATEDFACE | CAP_TURN_HEAD | CAP_WEAPON_RANGE_ATTACK1 | CAP_USE_SHOT_REGULATOR | CAP_AIM_GUN)
	self:SetMaxYawSpeed(5000)
	self:SetHealth(100)
	self:Give( "weapon_deagle" )
	self.NPCDataTable.Cop = true
end

function ENT:OnTakeDamage(dmg)
	umsg.Start('zomblood');
		umsg.Vector(dmg:GetDamagePosition());
	umsg.End();
	self:SetHealth(self:Health() - dmg:GetDamage())
	if self:Health() <= 0 then
		self:Ragdoll(dmg:GetDamageForce())
		self.HasTarget = false
		self:Remove()
		return
	end
	if self.IsRespondingToBeacon then
		self.IsRespondingToBeacon = false
	end
	for k,v in pairs(WatchEntities) do 
		if dmg:GetAttacker():GetClass() == v && dmg:GetAttacker():Alive() then
			dmg:GetAttacker().Threat = dmg:GetAttacker().Threat + 1
				if dmg:GetAttacker():GetPos():Distance(self:GetPos()) <= 50 then
					self:StartSchedule( schdMelee )
				else
					self:StartSchedule( schdShoot )
				end
				self.HasTarget = true
			return
		end
	end
end 

function ENT:Think(  )
if !self.HasTarget then return end
	for a,b in pairs(WatchEntities) do
		for k,v in pairs( ents.FindByClass( b ) ) do
			if (  v:IsValid() && v != self && v:GetClass() == b && v.Threat >= 1 && self:Visible(v)  ) then
				self:SetEnemy( v, true )
				self:UpdateEnemyMemory( v, v:GetPos() )
				self.LastEnemyPos = v:GetPos()
				self.NeedsToChase = false
				return
			elseif (  v:IsValid() && v != self && v:GetClass() == b && v.Threat >= 1 && !self:Visible(v)  ) then
				self.LastEnemyPos = v:GetPos()
				self.NeedsToChase = true
			end
		end	
	end
end 

function ENT:SelectSchedule()
	if self.IsRespondingToBeacon then
		self:StartSchedule( schdRespondToBeacon )
		return
	end
	if self.NeedsToChase then
		self:StartSchedule( schdRunToEnemy )
		self.IsChasing = true
		return
	end
	for a,b in pairs(WatchEntities) do
		for k,v in pairs( ents.FindByClass( b ) ) do
			if (  v:IsValid() && v != self && v:GetClass() == b && v.Threat >= 1 && self:Visible(v)  ) then
				self:SetEnemy( v, true )
				self:UpdateEnemyMemory( v, v:GetPos() )
				if v:GetPos():Distance(self:GetPos()) <= 50 then
					self:StartSchedule( schdMelee )
				else
					self:StartSchedule( schdShoot )
				end
				self.HasTarget = true
				return
			elseif (  v:IsValid() && v != self && v:GetClass() == b && v.Threat <= 0  ) then
				self.HasTarget = false
			end
		end	
	end
	self:StartSchedule( schdWander ) //run the schedule we created earlier
end

