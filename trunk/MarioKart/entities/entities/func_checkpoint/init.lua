AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
end

function ENT:KeyValue(key, value)
	if key == "number" then
		self.Number = value
	end
	if key == "finish" then
		self.Finish = value
	end
end

function ENT:StartTouch(ent)
	if ent:IsValid() && ent:IsPlayer() then
		if ent:GetNwInt("CheckPoint") == self.Number then
			if !self.Finish then
				ent:SetNWInt("CheckPoint", ent:GetNwInt("CheckPoint") + 1)
			else
				ent:SetNWInt("CheckPoint", 1)
				ent:SetNWInt("Lap", ent:GetNwInt("Lap") + 1)
			end
		end
	end
end