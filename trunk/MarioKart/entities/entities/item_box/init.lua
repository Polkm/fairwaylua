AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

ENT.Bobnumber = 0
ENT.Increase = false

function ENT:Initialize()
	self.Entity:SetModel("models/gmodcart/mk_block.mdl")
	self.Entity:SetColor(155,155,155,175)
	self.Entity:SetAngles(Angle(45,45,45))
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.QuestionMark = ents.Create("player_wheel")
	self.QuestionMark:SetModel("models/gmodcart/mk_question.mdl")
	self.QuestionMark:SetPos(self.Entity:GetPos())
	self.QuestionMark:SetColor(255,255,255,255)
	self.QuestionMark:Spawn()
	self.Ready = true
end

function ENT:Spin()
	if !self.Ready then return end
	self.Entity:SetColor(math.random(0,255),math.random(0,255),math.random(0,255),175)
	self.Entity:SetAngles(self.Entity:GetAngles() + Angle(5,5,5))
	if self.Bobnumber <= 0 && !self.Increase then
		self.Increase = true
	elseif self.Bobnumber >= 10 && self.Increase then
		self.Increase = false
	end
	if self.Increase then
		self.QuestionMark:SetPos(self.QuestionMark:GetPos() + Vector(0,0,.2))
		self.Bobnumber = self.Bobnumber + 1
	else
		self.QuestionMark:SetPos(self.QuestionMark:GetPos() - Vector(0,0,.2))
		self.Bobnumber = self.Bobnumber - 1
	end
end


timer.Create("BoxSpin",0.05,0, function() for k,v in pairs(ents.FindByClass("item_box")) do v:Spin() end end)

function ENT:OnTakeDamage(dmginfo)
end
function ENT:StartTouch(ent)
	local oldpose = self.Entity:GetPos()
	self.Entity:Remove()
	self.QuestionMark:Remove()
	if ent:IsValid() && ent:GetOwner():IsPlayer() then
		if ent:GetOwner():GetNWEntity("Cart") == ent then
			local ply = ent:GetOwner()
			if ply:GetNWString("item") == "empty" then
				local itemtable = {"item_koopashell_green",
				"item_koopashell_red",
				"item_banana",
				}
				
				ply:SetNWString("item",itemtable[math.random(1,#itemtable)])
			end
		end
	end
	timer.Simple(10,function()	local box = ents.Create("item_box")	box:SetPos(oldpose) box:Spawn()  end)
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
