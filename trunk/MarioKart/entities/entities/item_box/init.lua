AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')


function ENT:Initialize()
	self.Entity:SetModel("models/gmodcart/mk_block.mdl")
	self.Entity:SetColor(155,0,0,175)
	self.Entity:SetAngles(Angle(45,45,45))
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:SetCollisionGroup(11)
	self.QuestionMark = ents.Create("player_wheel")
	self.QuestionMark:SetModel("models/gmodcart/mk_question.mdl")
	self.QuestionMark:SetPos(self.Entity:GetPos())
	self.QuestionMark:SetColor(255,255,255,255)
	self.QuestionMark:Spawn()
end

function ENT:Spin()
	self.Entity:SetAngles(self.Entity:GetAngles() + Angle(5,5,5))
end


	timer.Create("BoxSpin",0.05,0, function() for k,v in pairs(ents.FindByClass("item_box")) do v:Spin() end end)

function ENT:OnTakeDamage(dmginfo)
end
function ENT:StartTouch(ent) 

end
function ENT:EndTouch(ent)
end
function ENT:AcceptInput(name,activator,caller)
end
function ENT:KeyValue(key,value)
end
function ENT:OnRemove()
end
function ENT:OnRestore()
end
function ENT:PhysicsCollide(data,physobj)
end
function ENT:PhysicsSimulate(phys,deltatime) 
end
function ENT:PhysicsUpdate(phys) 
end
function ENT:Think() 

end
function ENT:Touch(ent) 
end
function ENT:UpdateTransmitState(Entity)
end
function ENT:Use(activator,caller)
	
end
