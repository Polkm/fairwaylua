AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

ENT.Bobnumber = 0
ENT.Increase = false

ENT.SpawnPos = Vector(0, 0, 0)

function ENT:Initialize()
	self:SetModel("models/gmodcart/mk_block.mdl")
	self:SetColor(math.random(0, 255),math.random(0, 255),math.random(0, 255), 190)
	self:SetAngles(Angle(45, 45, 45))
	self:SetMoveType(MOVETYPE_NONE)
	self:PhysicsInit(SOLID_BBOX)
	self.QuestionMark = ents.Create("player_wheel")
	self.QuestionMark:SetModel("models/gmodcart/mk_question.mdl")
	self.QuestionMark:SetMoveType(MOVETYPE_NONE)
	self.QuestionMark:SetPos(self:GetPos())
	self.QuestionMark:SetColor(255, 255, 255, 255)
	self.QuestionMark:Spawn()
	self.Ready = true
	self.SpawnPos = self:GetPos()
	--self:Spin()
end

function ENT:OnTakeDamage(dmginfo)
end
function ENT:StartTouch(ent)
	if ent:GetOwner():IsPlayer() && ent:GetOwner():GetNWEntity("Cart") != ent then return end
	local SpawnPos = self.SpawnPos
	self:Remove()
	self.QuestionMark:Remove()
	if ent:IsValid() && ent:GetOwner():IsPlayer() then
		if ent:GetOwner():GetNWEntity("Cart") == ent then
			local ply = ent:GetOwner()
			if ply:GetNWString("item") == "empty" then
				local itemtable = {}
				if ply:GetNWInt("Place") > 8 then
					itemtable = GAMEMODE.PositionItemTables[9]
				else
					itemtable = GAMEMODE.PositionItemTables[ply:GetNWInt("Place")]
				end
				ply:SetNWString("item",itemtable[math.random(1,#itemtable)])
			end
		end
	end
	timer.Simple(10,function()	local box = ents.Create("item_box")	box:SetPos(SpawnPos) box:Spawn()  end)
end

