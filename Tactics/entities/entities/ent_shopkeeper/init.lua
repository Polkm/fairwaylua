AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
ENT.AutomaticFrameAdvance = true
ENT.IdleAnimations = {}

function ENT:Initialize()
	self:SetModel("models/gman.mdl")
	self:SetAngles(self:GetAngles() + Vector(0, 180, 0))
	self:SetSequence("idle")
	self:SetSolid(SOLID_VPHYSICS)
	table.insert(self.IdleAnimations, self:LookupSequence("tiefidget"))
	timer.Simple(math.random(5, 10), function() self:PlayRandomAnim(true) end)
end

function ENT:PlayRandomAnim(boolPlayAgain)
	self:ResetSequence(self.IdleAnimations[math.random(1, #self.IdleAnimations)])
	self:SetPlaybackRate(0.5)
	timer.Simple(self:SequenceDuration() / 0.5, function() self:ResetSequence("idle") end)
	if boolPlayAgain then
		timer.Simple(math.random(15, 30), function() self:PlayRandomAnim(true) end)
	end
end

function ENT:KeyValue(key,value)
end

function ENT:SetType(strType)
end

function ENT:SetAmount(varAmount)
end

function ENT:Use(activator, caller)
	if activator:IsPlayer()  && activator:GetNWBool("LockerZone") && activator.CanUse then
		activator:ConCommand("tx_shop")
		activator.CanUse = false
		timer.Simple(0.3, function() activator.CanUse = true end)
	end
end

function ENT:Think()
	self:NextThink(CurTime())
	return true
end