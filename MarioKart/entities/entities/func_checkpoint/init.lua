AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
timer.Simple(3, function()

	for k,v in pairs(ents.FindByClass("checktarget")) do
		print(v.Name)
		print(self.Target)
		if v.Name == tostring(self.Target) then
			self.Target = v 
			print(self.Target:GetPos())
			return
		end
	end
	
	end)
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
				for k,v in pairs(ents.FindByClass("func_checkpoint")) do
					if mk_CurrentCheckPoint <= self.Number then
						mk_CurrentCheckPoint = self.Number + 1
					end
				end
				plyOwner:SetNWInt("CheckPoint", plyOwner:GetNWInt("CheckPoint") + 1)
				print("Check Point " .. self.Number)
			else
				local intMaxLaps = self.Max or 5
				if self.Finish && plyOwner:GetNWInt("CheckPoint") >= intMaxLaps then
					plyOwner:SetNWInt("CheckPoint", 2)
					mk_CurrentLap = mk_CurrentLap + 1
					plyOwner:SetNWInt("Lap", plyOwner:GetNWInt("Lap") + 1)
					print("LAP!")
				end
			end
			
		end
	end
end