AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
end
function ENT:AcceptInput(name,activator,caller)
end
function ENT:KeyValue(key,value)
	if key == "Name" then
		self.Name = value
	end
end
function ENT:OnRemove()
end
function ENT:Think() 
end
