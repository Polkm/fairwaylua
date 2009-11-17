AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

ENT.Bobnumber = 0
ENT.Increase = false

function ENT:Initialize()
	self:SetModel("models/gmodcart/mk_block.mdl")
	self:SetColor(155,155,155,175)
	self:SetAngles(Angle(45,45,45))
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetSolid(SOLID_VPHYSICS)
	self.QuestionMark = ents.Create("player_wheel")
	self.QuestionMark:SetModel("models/gmodcart/mk_question.mdl")
	self.QuestionMark:SetPos(self:GetPos())
	self.QuestionMark:SetColor(255,255,255,255)
	self.QuestionMark:Spawn()
	self.Ready = true
	--self:Spin()
end

function ENT:Think()
	if !self.Ready then return end
	self:SetColor(math.random(0,255),math.random(0,255),math.random(0,255),175)
	self:SetAngles(self:GetAngles() + Angle(5,5,5))
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
	--timer.Simple(0.1, function() self:Spin() end)
end

function ENT:OnTakeDamage(dmginfo)
end
function ENT:StartTouch(ent)
	if ent:GetOwner():IsPlayer() && ent:GetOwner():GetNWEntity("Cart") != ent then return end
	local oldpose = self:GetPos()
	self:Remove()
	self.QuestionMark:Remove()
	if ent:IsValid() && ent:GetOwner():IsPlayer() then
		if ent:GetOwner():GetNWEntity("Cart") == ent then
			local ply = ent:GetOwner()
			if ply:GetNWString("item") == "empty" then
				local itemtable = {"item_mushroom",
				"item_koopashell_red",
				"item_banana",
				}
				
				ply:SetNWString("item",itemtable[math.random(1,#itemtable)])
			end
		end
	end
	timer.Simple(10,function()	local box = ents.Create("item_box")	box:SetPos(oldpose) box:Spawn()  end)
end

