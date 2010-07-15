TOOL.Category		= "Poser"
TOOL.Name			= "#Rag Doll Poser"
TOOL.Command		= nil
TOOL.ConfigName		= nil

TOOL.CurrentTable = {}

function TOOL:LeftClick(trace)
	if !trace.Entity then return false end
	if !trace.Entity:IsValid() then return false end
	if trace.Entity:IsPlayer() then return false end	
	if trace.Entity:GetClass() != "prop_ragdoll" then return false end
	if CLIENT then return true end
	if trace.Entity:GetPhysicsObjectCount() <= 1 then return false end
	
	local ent = trace.Entity
	local bones = ent:GetPhysicsObjectCount()
	
	self.CurrentTable = {}

	for bone = 1, bones do
		local physBone = ent:GetPhysicsObjectNum(bone - 1)
		local tblNewBone = {}
		tblNewBone.Position = physBone:GetPos()
		tblNewBone.Angles = physBone:GetAngle()
		table.insert(self.CurrentTable, tblNewBone)
	end
	
	PrintTable(self.CurrentTable)
	return true
end


function TOOL:RightClick(trace)
	if !trace.Entity then return false end
	if !trace.Entity:IsValid() then return false end
	if trace.Entity:IsPlayer() then return false end	
	if trace.Entity:GetClass() != "prop_ragdoll" then return false end
	if CLIENT then return true end
	if trace.Entity:GetPhysicsObjectCount() <= 1 then return false end
	
	local ent = trace.Entity
	local bones = ent:GetPhysicsObjectCount()
	
	ent:GetTable().StatueInfo = {}
	ent:GetTable().StatueInfo.Welds = {}

	for bone = 1, bones do
		local bone1 = bone - 1
		local bone2 = bones - bone
	
		local physBone = ent:GetPhysicsObjectNum(bone1)
		if self.CurrentTable[bone1] && self.CurrentTable[bone1].Angles then
			physBone:SetPos(self.CurrentTable[bone1].Position)
			physBone:SetAngle(self.CurrentTable[bone1].Angles)
		end
	end
	
	
	
	return true
end

