AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')
function ENT:StartTouch(ent) 
	if ent:IsPlayer() then 
		ent:SetNWBool("PvpFlag", true)
	end
end
function ENT:EndTouch(ent)
	if ent:IsPlayer() then 
		ent:SetNWBool("PvpFlag", false)
	end
end
