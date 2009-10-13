AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/props_lab/lockers.mdl")
	self:PhysicsInit(0)
	self:SetMoveType(0)
	self:SetSolid(SOLID_VPHYSICS)
	self.LockerDoor1 = ents.Create("prop_physics")
	self.LockerDoor1:SetModel("models/props_lab/lockerdoorleft.mdl")
	self.LockerDoor1:SetPos(self:GetPos() + Vector(10,0,38))
	self.LockerDoor1:SetMoveType(0)
	self.LockerDoor1:SetAngles(self:GetAngles())
	self.LockerDoor1:SetSolid(0)
	self.LockerDoor1:SetKeyValue( "spawnflags", 8)
	self.LockerDoor1:Spawn()
	self.LockerDoor2 = ents.Create("prop_physics")
	self.LockerDoor2:SetModel("models/props_lab/lockerdoorleft.mdl")
	self.LockerDoor2:SetPos(self:GetPos() + Vector(10,-15,38))
	self.LockerDoor2:SetMoveType(0)
	self.LockerDoor2:SetAngles(self:GetAngles())
	self.LockerDoor2:SetSolid(0)
	self.LockerDoor2:SetKeyValue( "spawnflags", 8)
	self.LockerDoor2:Spawn()
	self.LockerDoor3 = ents.Create("prop_physics")
	self.LockerDoor3:SetMoveType(0)
	self.LockerDoor3:SetSolid(0)
	self.LockerDoor3:SetAngles(self:GetAngles())
	self.LockerDoor3:SetKeyValue( "spawnflags", 8)
	self.LockerDoor3:SetModel("models/props_lab/lockerdoorsingle.mdl")
	self.LockerDoor3:SetPos(self:GetPos() + Vector(10,16,38))
	self.LockerDoor3:Spawn()
	
end

function ENT:SetType(strType)
end

function ENT:SetAmount(varAmount)
end

function ENT:Use(activator, caller)
	if activator:IsPlayer()  && activator:GetNWBool("LockerZone") && activator.CanUse then
		activator:ConCommand("tx_locker")
		activator.CanUse = false
		timer.Simple(0.3, function() activator.CanUse = true end)
	end
end