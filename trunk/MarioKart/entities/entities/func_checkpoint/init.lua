AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	print("SHIT TASTIC")
end

function ENT:KeyValue(key, value)
	if key == "number" then
		self.Number = value
	end
	if key == "finish" then
		self.Finish = value
	end
end

function ENT:Touch(ent)
	print("Touched1111")
end

function ENT:StartTouch(ent)
	print("Touched")
	if ent:IsValid() && ent:GetOwner():IsPlayer() then
		print("Past First Test")
		if ent:GetOwner():GetNWEntity("Cart") == ent then
			print("Past Second Test")
			local plyOwner = ent:GetOwner()
			if plyOwner:GetNwInt("CheckPoint") == self.Number then
				if !self.Finish then
					plyOwner:SetNWInt("CheckPoint", plyOwner:GetNwInt("CheckPoint") + 1)
					print("Check Point " .. self.Number)
				else
					plyOwner:SetNWInt("CheckPoint", 1)
					plyOwner:SetNWInt("Lap", plyOwner:GetNwInt("Lap") + 1)
					print("LAP!")
				end
			end
		end
	end
end