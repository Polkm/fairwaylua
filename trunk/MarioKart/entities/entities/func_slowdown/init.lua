AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')


function ENT:StartTouch(ent)
	if ent:GetOwner():IsPlayer() && ent:GetOwner():GetNWEntity("Cart") == ent  then 
		ent:GetOwner().SlowDown = true
		print("hahhaa")
	end
end

function ENT:EndTouch(ent)
	if ent:GetOwner():IsPlayer() && ent:GetOwner():GetNWEntity("Cart") == ent then 
		ent:GetOwner().SlowDown = false
			print("aww")
	end
end