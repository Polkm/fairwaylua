--[[-------------------------------------------------------
   Sets the stage to the number of objects
---------------------------------------------------------]]
function ToolObj:UpdateData()
	self:SetStage(self:NumObjects())
end
	
--[[-------------------------------------------------------
   Sets which stage a tool is at
---------------------------------------------------------]]
function ToolObj:SetStage(intStage)
	if SERVER then
		--ewww a network int why does everyone need to know this?
		self:GetWeapon():SetNWInt("Stage", intStage, true)
	end
end

--[[-------------------------------------------------------
   Gets which stage a tool is at
---------------------------------------------------------]]
function ToolObj:GetStage()
	return self:GetWeapon():GetNWInt("Stage", 0)
end

--[[-------------------------------------------------------
   ClearObjects - clear the selected objects
---------------------------------------------------------]]
function ToolObj:ClearObjects()
	self:ReleaseGhostEntity()
	self.Objects = {}
	self:SetStage(0)
end

--[[-------------------------------------------------------
	Since we're going to be expanding this a lot I've tried
	to add accessors for all of this crap to make it harder
	for us to mess everything up.
---------------------------------------------------------]]
function ToolObj:GetEnt(intKey)
	if !self.Objects[intKey] then return NULL end
	return self.Objects[intKey].Ent
end

--[[-------------------------------------------------------
	Returns the world position of the numbered object hit
	We store it as a local vector then convert it to world
	That way even if the object moves it's still valid
---------------------------------------------------------]]
function ToolObj:GetPos(intKey)
	local vecLocalPos = self:GetLocalPos(intKey)
	--If it's the world just return the local pos
	if self.Objects[intKey].Ent:EntIndex() == 0 then
		return vecLocalPos
	else
		--If the phys is valid return its pos, if not return the ent's pos
		if self.Objects[intKey].Phys ~= nil and self.Objects[intKey].Phys:IsValid() then
			return self.Objects[intKey].Phys:LocalToWorld(vecLocalPos)
		else
			return self.Objects[intKey].Ent:LocalToWorld(vecLocalPos)
		end
	end
end

--[[-------------------------------------------------------
	Returns the local position of the numbered hit
---------------------------------------------------------]]
function ToolObj:GetLocalPos(intKey)
	return self.Objects[intKey].Pos
end


--[[-------------------------------------------------------
	Returns the physics bone number of the hit (ragdolls)
---------------------------------------------------------]]
function ToolObj:GetBone(intKey)
	return self.Objects[intKey].Bone
end

--[[-------------------------------------------------------
	Returns the normal vector of the position hit
---------------------------------------------------------]]
function ToolObj:GetNormal(intKey)
	if self.Objects[intKey].Ent:EntIndex() == 0 then
		return self.Objects[intKey].Normal
	else
		local norm
		if self.Objects[intKey].Phys ~= nil and self.Objects[intKey].Phys:IsValid() then
			norm = self.Objects[intKey].Phys:LocalToWorld(self.Objects[intKey].Normal)
		else
			norm = self.Objects[intKey].Ent:LocalToWorld(self.Objects[intKey].Normal)
		end
		return norm - self:GetPos(intKey)
	end
end


--[[-------------------------------------------------------
	Returns the physics object for the numbered hit
---------------------------------------------------------]]
function ToolObj:GetPhys(intKey)
	if self.Objects[intKey].Phys == nil then
		return self:GetEnt(intKey):GetPhysicsObject()
	end
	return self.Objects[intKey].Phys
end


--[[-------------------------------------------------------
	Sets a selected object
---------------------------------------------------------]]
function ToolObj:SetObject(intKey, entTarget, vecPos, phys, intBone, vecNorm)
	self.Objects[intKey] = {}
	self.Objects[intKey].Ent = entTarget
	self.Objects[intKey].Phys = phys
	self.Objects[intKey].Bone = intBone
	self.Objects[intKey].Normal = vecNorm

	--Worldspawn is a special case
	if entTarget:EntIndex() == 0 then
		self.Objects[intKey].Phys = nil
		self.Objects[intKey].Pos = vecPos
	else
		vecNorm = vecNorm + vecPos
		--Convert the position to a local position - so it's still valid when the object moves
		if (phys != nil && phys:IsValid()) then
			self.Objects[intKey].Normal = self.Objects[intKey].Phys:WorldToLocal(vecNorm)
			self.Objects[intKey].Pos = self.Objects[intKey].Phys:WorldToLocal(vecPos)
		else
			self.Objects[intKey].Normal = self.Objects[intKey].Ent:WorldToLocal(vecNorm)
			self.Objects[intKey].Pos = self.Objects[intKey].Ent:WorldToLocal(vecPos)
		end
	end
	if SERVER then
		--Todo: Make sure the client got the same info
	end
end


--[[-------------------------------------------------------
	Returns the number of objects in the list
---------------------------------------------------------]]
function ToolObj:NumObjects()
	if CLIENT then
		return self:GetStage()
	end
	return #self.Objects
end
