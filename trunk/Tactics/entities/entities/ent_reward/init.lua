AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/props_junk/PopCan01a.mdl")
	if self:GetNWString("type") == "ammo" then self:SetModel("models/Items/BoxSRounds.mdl") end
	if self:GetNWString("type") == "health" then self:SetModel("models/healthvial.mdl") end
	if self:GetNWString("type") == "health" && self:GetNWString("amount") == "full" then self:SetModel("models/Items/HealthKit.mdl") end
	if self:GetNWString("type") == "cash" then self:SetModel("models/props/cs_assault/Money.mdl") end
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:GetPhysicsObject():ApplyForceCenter(Vector(math.random(-50, 50), math.random(-50, 50), 300))
end

function ENT:SetType(strType)
	self:SetNWString("type", tostring(strType) or "ammo")
end
function ENT:SetAmount(varAmount)
	self:SetNWString("amount", tostring(varAmount) or "small")
end

function ENT:Use(activator, caller)
	if self:GetNWEntity("PropProtector") != "none" && self:GetNWEntity("PropProtector") != activator then return end
	local strType = self:GetNWString("type")
	local strAmount = self:GetNWString("amount")
	if strType == "ammo" then
		activator:GiveAmmoAmount(strAmount)
		self:Remove()
		return
	elseif strType == "cash" then
		local intAmountToGive = tonumber(strAmount)
		activator:GiveCash(intAmountToGive)
		self:Remove()
		return
	elseif strType == "health" && activator:Health() < activator:GetNWInt("MaxHp") then
		local intAmountToAdd = 50
		if strAmount == "full" then intAmountToAdd = activator:GetNWInt("MaxHp") end
		if self:GiveHealth(intAmountToAdd) then
			self:Remove()
			return
		end
	end
end