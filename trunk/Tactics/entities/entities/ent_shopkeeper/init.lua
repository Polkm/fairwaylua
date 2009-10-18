AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/gman.mdl")
	self:PhysicsInit(0)
	self:SetMoveType(0)
	self:SetSolid(SOLID_VPHYSICS)
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