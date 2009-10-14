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
		local intShootingGuns = #activator:GetWeapons()
		for _, weapon in pairs(activator:GetWeapons()) do
			if AmmoTypes[weapon:GetPrimaryAmmoType()] then
				local intAmmoToGive = math.Round(AmmoTypes[weapon:GetPrimaryAmmoType()][strAmount] / intShootingGuns)
				if activator.Perks["perk_ammoup"] != nil && activator.Perks["perk_ammoup"].Active then
					activator:GiveAmmo(math.Round(intAmmoToGive*1.5), weapon:GetPrimaryAmmoType())
					print("perked")
				else
					activator:GiveAmmo(intAmmoToGive , weapon:GetPrimaryAmmoType())
				end				
			end
		end
		self:Remove()
		return
	elseif strType == "cash" then
		local intAmountToGive = tonumber(strAmount)
		if intAmountToGive > 0 then
			if activator.Perks["perk_ammoup"] != nil && activator.Perks["perk_ammoup"].Active  then
				activator:GiveCash(math.Round(intAmountToGive/2))
				print("perkedm")
			elseif activator.Perks["perk_gamble"] != nil && activator.Perks["perk_gamble"].Active then
				local chance = math.random(1,2)
				if chance == 1 then
					activator:GiveCash(-1*intAmountToGive)
				else
					activator:GiveCash(2*intAmountToGive)
				end
			else
				activator:GiveCash(intAmountToGive)
			end
			self:Remove() 
		end
		return
	elseif strType == "health" && activator:Health() < activator:GetNWInt("MaxHp")  then
		local intAmountToAdd = 50
		if strAmount == "full" then intAmountToAdd = activator:GetNWInt("MaxHp") end
		local intNewHealth = math.Clamp((activator:Health() + intAmountToAdd), 0, activator:GetNWInt("MaxHp"))
		activator:SetHealth(intNewHealth)
		self:Remove()
		return
	end
end