AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	for a,b in pairs(ents.FindByClass("snpc_citizen")) do
		//if b:GetPos():Distance(self:GetPos()) <= 500 then
			b:SetEnemy( self, true )
			b:UpdateEnemyMemory( self, self:GetPos() )
			b:StartSchedule( schdRespondToBeacon )
			b.IsRespondingToBeacon = true
			print("shouldmove")
		//end
	end
end
function ENT:AcceptInput(name,activator,caller)
end
function ENT:KeyValue(key,value)
end
function ENT:OnRemove()
end
function ENT:Think() 
end
