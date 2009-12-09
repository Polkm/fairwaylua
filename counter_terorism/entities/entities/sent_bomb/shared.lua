ENT.Type 		= "anim"
ENT.PrintName	= ""
ENT.Author		= ""
ENT.Contact		= ""

function ENT:Initialize()
	if (CLIENT) then
		GAMEMODE:PlayAlert("Bombplant")
	end
end