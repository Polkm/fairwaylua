AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')
function ENT:StartTouch(ent) 
	if ent:IsPlayer() then 
		if ent:Team() == TEAM_SPECTATOR then
			ent:Kill()
		else
		ent:SetNWBool("CanPlant",true)
		end
	end
end
function ENT:EndTouch(ent)
	if ent:IsPlayer() then 
		ent:SetNWBool("CanPlant",false)
	end
end
