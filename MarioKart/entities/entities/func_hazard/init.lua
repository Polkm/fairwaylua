AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')
function ENT:StartTouch(ent) 
	if ent:GetOwner():IsPlayer() && ent:GetOwner():GetNWEntity("Cart") == ent  then 
		timer.Simple(3,function() 
		for k,v in pairs(ents.FindByClass("func_checkpoint")) do
			if v.Number == ent:GetOwner():GetNWInt("Checkpoint") then
				ent:SetPos(v.Target:GetPos() + Vector(0,0,50))
			end
		end
		end)
	end
end
