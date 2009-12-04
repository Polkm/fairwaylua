include('shared.lua')
local matSellectionCircle = Material("SGM/playercircle")
local intCircleSize = 50
ENT.boolAnimPlayed = false

function ENT:Initialize()
	self.GunProp = ents.Create("prop_physics")
	self.GunProp:SetPos(util.LocalToWorld(self, Vector(3, 4, 8), 0))
	self.GunProp:SetAngles(self:GetAngles() + Angle(0, 0, -90))
	self.GunProp:SetModel("models/weapons/w_smg1.mdl")
	self.GunProp:SetParent(self)
	self.GunProp:Spawn()
end

function ENT:OnRemove()
	if self.GunProp and self.GunProp:IsValid() then
		self.GunProp:Remove()
	end
	local tblGibs = {}
	for i = 1, 3 do
		local gib = ents.Create("prop_physics")
		gib:SetPos(self:GetPos())
		gib:SetModel(self.GibModels[math.random(1, #self.GibModels)])
		local intBoxSize = 2
		gib:PhysicsInitBox(Vector(-intBoxSize, -intBoxSize, -intBoxSize), Vector(intBoxSize, intBoxSize, intBoxSize))
		gib:SetMoveType(MOVETYPE_VPHYSICS)
		gib:SetCollisionGroup(COLLISION_GROUP_WORLD)
		gib:Spawn()
		gib:GetPhysicsObject():Wake()
		local intForce = 100
		gib:GetPhysicsObject():SetVelocity(Vector(math.random(-intForce, intForce), math.random(-intForce, intForce), math.random(-intForce, intForce)))
		table.insert(tblGibs, gib)
	end
	timer.Simple(5, function()
		for _, gib in pairs(tblGibs) do
			gib:Remove()
		end
	end)
end

function ENT:Think()
	local strWeapon = self:GetNWString("weapon")
	local strClass = self:GetNWString("class")
	if self.GunProp && self.GunProp:IsValid() && strWeapon then
		local tblWeaponTable = GAMEMODE.Data.Equiptment[strWeapon]
		if tblWeaponTable && tblWeaponTable.Model then
			if tostring(self.GunProp:GetModel()) != tostring(tblWeaponTable.Model) then
				self.GunProp:SetModel(tblWeaponTable.Model)
				local tblAnimTable = GAMEMODE.Data.Equiptment[self:GetNWString("weapon")].HoldPosition
				self.GunProp:SetPos(util.LocalToWorld(self, tblAnimTable.Position, 0))
				self.GunProp:SetAngles(self:GetAngles() + tblAnimTable.Angles)
			end
		end
	end
	if strClass && GAMEMODE.Data.Units[strClass] then
		local tblUnitTable = GAMEMODE.Data.Units[strClass]
		if intCircleSize != tblUnitTable.CircleSize then
			intCircleSize = tblUnitTable.CircleSize
		end
	end
	if self:GetNWString("anim") == "fire" && !self.boolAnimPlayed then
		self.boolAnimPlayed = true
		self:Anim(self:GetNWString("anim"))
	elseif self:GetNWString("anim") == "idle" then
		self.boolAnimPlayed = false
		if timer.IsTimer(tostring(self) .. "AnimTimer") then
			timer.Destroy(tostring(self) .. "AnimTimer")
			local tblAnimTable = GAMEMODE.Data.Equiptment[self:GetNWString("weapon")].HoldPosition
			self.GunProp:SetPos(util.LocalToWorld(self, tblAnimTable.Position, 0))
			self.GunProp:SetAngles(self:GetAngles() + tblAnimTable.Angles)
		end
	end
end

function ENT:Anim(strAnim)
	local tblAnimTable = GAMEMODE.Data.Equiptment[self:GetNWString("weapon")].FireAnim
	local intKeyFrame = 1
	timer.Create(tostring(self) .. "AnimTimer", 0.1, #tblAnimTable, function()
		if !self or !self:IsValid() then return end
		self.GunProp:SetPos(util.LocalToWorld(self, tblAnimTable[intKeyFrame].Position, 0))
		self.GunProp:SetAngles(self:GetAngles() + tblAnimTable[intKeyFrame].Angles)
		intKeyFrame = intKeyFrame + 1
		if intKeyFrame > #tblAnimTable then
			self.boolAnimPlayed = false
		end
	end)
end

function ENT:Draw()
	self:DrawModel()
	if !self:GetOwner() or !self:GetOwner():IsValid() or !self:GetOwner():Team() then return end
	if LocalPlayer():Team() == self:GetOwner():Team() then
		if math.Round(self.LastHieght) != math.Round(self:GetPos().z) then
			local trace = {}
			trace.start = self:GetPos() + Vector(0, 0, 5)
			trace.endpos = trace.start + Vector(0, 0, -100)
			trace.filter = ents.FindByClass("ent_plrunit")
			self.LastTrace = util.TraceLine(trace)
			self.LastHieght = self:GetPos().z
		end

		if not self.LastTrace.HitWorld then self.LastTrace.HitPos = self:GetPos() end

		local color = Color(150, 150, 20, 0)
		if LocalPlayer() == self:GetOwner() then
			color = Color(20, 150, 20, 0)
		end
		if self:GetNWBool("sellected") && LocalPlayer() == self:GetOwner() then
			color.a = 150
		else
			color.a = 50
		end
		
		render.SetMaterial(matSellectionCircle)
		render.DrawQuadEasy(
			self:GetPos() + Vector(0, 0, self.LastTrace.HitPos.z - self:GetPos().z) + self.LastTrace.HitNormal,
			self.LastTrace.HitNormal, 
			intCircleSize, intCircleSize, color)
	end
end