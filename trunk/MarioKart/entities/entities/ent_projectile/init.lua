AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Bobnumber = 0
ENT.Increase = false

function ENT:Initialize()
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	--self:SetSolid(SOLID_VPHYSICS)
end

function ENT:PhysicsCollide(tblData, physObject)
	if tblData.HitEntity:IsWorld() && self.Activated then
		if self.class == "item_koopashell_red"  then
			if tblData.Speed && math.abs(tblData.HitPos.z - self:GetPos().z) < 1 then
				self:Remove()
			end
		end
		local intLastSpeed = math.max(tblData.OurOldVelocity:Length(), tblData.Speed)
		local intNewVelocity = physObject:GetVelocity()
		intNewVelocity = Vector(intNewVelocity.x, intNewVelocity.y, intNewVelocity.z * 0.25):Normalize()
		intLastSpeed = math.max(intNewVelocity:Length(), intLastSpeed)
		local intTargetVelocity = intNewVelocity * intLastSpeed * 0.999
		physObject:SetVelocity(intTargetVelocity)
	else
		local entHitEntity = tblData.HitEntity
		local plyHitEntityOwner = entHitEntity:GetOwner()
		if self.Activated  then
			if entHitEntity == plyHitEntityOwner:GetNWEntity("Cart") then
				if self.Class != "item_koopashell_blue" then
					if !entHitEntity:GetOwner().StarPower then
						tblData.HitEntity:Wipeout(GAMEMODE.mk_Items[self.class].WipeOutType)
					end
						self:Remove()
					return
				else
					if !entHitEntity:GetOwner().StarPower then
						tblData.HitEntity:Wipeout(GAMEMODE.mk_Items[self.class].WipeOutType)
					end
					if plyHitEntityOwner:GetNWEntity("Cart") == self.target then
						self:Remove()
					end
					return
				end
			elseif entHitEntity:GetClass() == "ent_projectile" then
				self:Remove()
				entHitEntity:Remove()
			end
		end
	end
end

function ENT:Think()
	if self.Activated then
		if self.class == "item_koopashell_red" || self.class == "item_koopashell_blue"	then 
			self:GetPhysicsObject():ApplyForceCenter((self.target:GetPos() - self:GetPos()) * 3)
		elseif self.class == "item_badbox" then
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
		end
	end
end

--[[
function ENT:PhysicsSimulate(phys, deltatime)
	trace = {}
	trace.start = self:GetPos()
	trace.filter = self
	trace.endpos = self:GetPos() - Vector(0,0,15)
	local tr = util.TraceLine(trace)
	local up = phys:GetAngle():Up()
	local driver = self:GetOwner()
	local forward = 1000
	local right = 0
	local Velocity = phys:GetVelocity()
	local ForwardVel = phys:GetAngle():Forward():Dot( Velocity )
	local RightVel = phys:GetAngle():Right():Dot( Velocity )
	local UpVel = phys:GetAngle():Up():Dot( Velocity )
	right = RightVel * 0.95
	
	forward = forward - ForwardVel * 0.2

	local Linear = ( Vector( forward, right, -5) ) * deltatime * 250;

	local AngleVel = phys:GetAngleVelocity() 

	local AngleFriction = Vector(AngleVel.x * -1.1,AngleVel.y * -50,AngleVel.z * -50)
	
	local Angular = (AngleFriction) ;
	return Angular, Linear, SIM_LOCAL_ACCELERATION
end
]]
