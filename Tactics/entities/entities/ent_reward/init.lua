AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/props_junk/PopCan01a.mdl")
	if self.Type == "ammo" then self:SetModel("models/Items/BoxSRounds.mdl") end
	if self.Type == "health" then self:SetModel("models/healthvial.mdl") end
	if self.Type == "health" && self.Amount == "full" then self:SetModel("models/Items/HealthKit.mdl") end
	if self.Type == "cash" then self:SetModel("models/props/cs_assault/Money.mdl") end
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:GetPhysicsObject():ApplyForceCenter(Vector(math.random(-10, 10), math.random(-10, 10), 200))
end

function ENT:SetType(strType)
	self.Type = strType or "ammo"
	self:SetNWString("type", self.Type)
end
function ENT:SetAmount(varAmount)
	self.Amount = varAmount or "small"
end

function ENT:Use(activator, caller)
	if self:GetNWEntity("PropProtector") != "none" && self:GetNWEntity("PropProtector") != activator then return end
	if self.Type == "ammo" then
		local ShootingGuns = #activator:GetWeapons() -  1
		for _, weapon in pairs(activator:GetWeapons()) do
			if AmmoTypes[weapon:GetPrimaryAmmoType()] then
				--print("giving ammo", AmmoTypes[weapon:GetPrimaryAmmoType()][self.Amount])
				activator:GiveAmmo(math.Round(AmmoTypes[weapon:GetPrimaryAmmoType()][self.Amount] / ShootingGuns), weapon:GetPrimaryAmmoType())
			end
		end
		self:Remove()
	elseif self.Type == "cash" then
		activator:GiveCash(self.Amount, true)
		self:Remove()
	elseif self.Type == "health" && activator:Health() < 100 then
		local AmountToAdd = 0
		if self.Amount == "full" then AmountToAdd = 50
		elseif self.Amount == "half" then AmountToAdd = 100
		end
		activator:SetHealth(math.Clamp((activator:Health() + AmountToAdd), 0, 100))
		self:Remove()
	end
end