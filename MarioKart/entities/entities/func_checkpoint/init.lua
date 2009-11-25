AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	GAMEMODE.CheckPointEnts[self.Number] = self
	timer.Simple(1, function()
		for _, ent in pairs(ents.FindByClass("checktarget")) do
			if ent.Name ==  self.Target then
				self.Target = ent
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
		self.Target = tostring(value)
	end
end

function ENT:StartTouch(ent)
	if ent:IsValid() && ent:GetOwner():IsPlayer() then
		if ent:GetOwner():GetNWEntity("Cart") == ent then
			local plyOwner = ent:GetOwner()
			if plyOwner:GetNWInt("CheckPoint") == self.Number then
				plyOwner:SetNWInt("CheckPoint", plyOwner:GetNWInt("CheckPoint") + 1)
			else
				local intMaxLaps = self.Max or 5
				if self.Finish && plyOwner:GetNWInt("CheckPoint") >= intMaxLaps then
					if plyOwner:GetNWInt("Lap") <= 0 then return end
					plyOwner:SetNWInt("CheckPoint", 2)
					if GAMEMODE.WinLaps <= plyOwner:GetNWInt("Lap") then
						GAMEMODE:RaceFinish()
						GAMEMODE:FinishPlayer(plyOwner)
						--print("FINISHED!")
					else
						plyOwner:SetNWInt("Lap", plyOwner:GetNWInt("Lap") + 1)
						if plyOwner:GetNWInt("Lap") == GAMEMODE.WinLaps then
							plyOwner:ConCommand("mk_Sound FinalLap")
							timer.Simple(5, function() plyOwner:ConCommand("mk_Sound BackGround") end)
						end
						--print("LAP!")
					end
				end
			end
			
		end
	end
end