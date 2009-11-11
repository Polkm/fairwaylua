AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	GAMEMODE.CheckPointEnts[self.Number] = self
end

function ENT:KeyValue(key, value)
	if key == "number" then
		self.Number = tonumber(value)
	end
	if key == "finish" then
		self.Finish = tobool(value)
	end
	if key == "max" then
		self.Max = tonumber(value)
	end
	if key == "target" then
		self.Target = value
	end
end

function ENT:StartTouch(ent)
	if ent:IsValid() && ent:GetOwner():IsPlayer() then
		if ent:GetOwner():GetNWEntity("Cart") == ent then
			local plyOwner = ent:GetOwner()
			if plyOwner:GetNWInt("CheckPoint") == self.Number then
				plyOwner:SetNWInt("CheckPoint", plyOwner:GetNWInt("CheckPoint") + 1)
				print("Check Point " .. self.Number)
				if self.Finish then
					plyOwner:ConCommand("mk_startRecording")
				end
			else
				local intMaxLaps = self.Max or 5
				if self.Finish && plyOwner:GetNWInt("CheckPoint") >= intMaxLaps then
					plyOwner:SetNWInt("CheckPoint", 2)
					plyOwner:SetNWInt("Lap", plyOwner:GetNWInt("Lap") + 1)
					plyOwner:ConCommand("mk_stopRecording")
					print("LAP!")
				end
			end
			
		end
	end
end