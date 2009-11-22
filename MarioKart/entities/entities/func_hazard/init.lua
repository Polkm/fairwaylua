AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')
function ENT:StartTouch(ent) 
	if ent:GetOwner():IsPlayer() && ent:GetOwner():GetNWEntity("Cart") == ent  then 
		timer.Simple(3,function() 
		for k,v in pairs(ents.FindByClass("func_checkpoint")) do
			if v.Number == ent:GetOwner():GetNWInt("Checkpoint") - 1 then
				ent:SetPos(v.Target:GetPos() + Vector(0,0,50))
				ent:SetAngles(Angle(ent:GetAngles().p,ent:GetAngles().y,0))
				if ent:GetOwner():GetNWEntity("activeitem") != "none" then
					ent:GetOwner():GetNWEntity("activeitem"):Remove()

				end
				return 
			elseif v.Number == ent:GetOwner():GetNWInt("Checkpoint") && ent:GetOwner():GetNWInt("Checkpoint") == 1 then
				ent:SetPos(v.Target:GetPos() + Vector(0,0,50))
				ent:SetAngles(Angle(ent:GetAngles().p,ent:GetAngles().y,0))
				if ent:GetOwner():GetNWEntity("activeitem") != "none" then
					ent:GetOwner():GetNWEntity("activeitem"):Remove()
				end
			end
		end
		end)
	end
end
