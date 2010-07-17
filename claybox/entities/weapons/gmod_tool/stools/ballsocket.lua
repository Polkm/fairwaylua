TOOL.Category		= "Constraints"
TOOL.Name			= "#Ball Socket"
TOOL.Command		= nil
TOOL.ConfigName		= nil

TOOL.Mode = "Default"

TOOL.ClientConVar["forcelimit"] = "0"
TOOL.ClientConVar["torquelimit"] = "0"
TOOL.ClientConVar["nocollide"] = "0"

function TOOL:BallSocket(tblTrace, strMode)
	if tblTrace.Entity:IsValid() and tblTrace.Entity:IsPlayer() then return end
	--If there's no physics object then we can't constraint it!
	if SERVER and !util.IsValidPhysicsObject(tblTrace.Entity, tblTrace.PhysicsBone) then return end
	local intStage = self:NumObjects()
	local Phys = tblTrace.Entity:GetPhysicsObjectNum(tblTrace.PhysicsBone)
	self:SetObject(intStage + 1, tblTrace.Entity, tblTrace.HitPos, Phys, tblTrace.PhysicsBone, tblTrace.HitNormal)
	if intStage <= 0 then
		if strMode == "Easy" then
			self:StartGhostEntity(tblTrace.Entity)
		end
		self:SetStage(intStage + 1)
		self.Mode = strMode or "Default"
		return true
	end
	return false
end

function TOOL:LeftClick(tblTrace)
	local boolReturn = self:BallSocket(tblTrace, "Default")
	if boolReturn == nil then return false elseif boolReturn then return true end
	if CLIENT then
		self:ClearObjects()
		if self.Mode == "Easy" then
			self:ReleaseGhostEntity()
		end
		return true
	end
	--Get client's CVars
	local forcelimit = self:GetClientNumber("forcelimit", 0)
	local torquelimit = self:GetClientNumber("torquelimit", 0)
	local nocollide = self:GetClientNumber("nocollide", 0)
	---Get information we're about to use
	local Ent1, Ent2  = self:GetEnt(1), self:GetEnt(2)
	local Bone1, Bone2 = self:GetBone(1), self:GetBone(2)
	local Norm1, Norm2 = self:GetNormal(1),	self:GetNormal(2)
	local WPos = self:GetPos(2)
	local LPos = self:GetLocalPos(2)
	local Phys = self:GetPhys(1)
	
	local entConstraint
	if self.Mode == "Default" then
		entConstraint = constraint.Ballsocket(Ent1, Ent2, Bone1, Bone2, LPos, forcelimit, torquelimit, nocollide)
	else
		--Note: To keep stuff ragdoll friendly try to treat things as physics objects rather than entities
		local Ang1, Ang2 = Norm1:Angle(), (Norm2 * -1):Angle()
		local TargetAngle = Phys:AlignAngles(Ang1, Ang2)
		Phys:SetAngle(TargetAngle)
		--Move the object so that the hitpos on our object is at the second hitpos
		local TargetPos = WPos + (Phys:GetPos() - self:GetPos(1)) + (Norm2)
		--Offset slightly so it can rotate
		TargetPos = TargetPos + Norm2
		--Set the position
		Phys:SetPos(TargetPos)
		--Wake up the physics object so that the entity updates
		Phys:Wake()
		--Create a constraint axis
		entConstraint = constraint.Ballsocket(Ent1, Ent2, Bone1, Bone2, LPos, forcelimit, torquelimit, nocollide)
	end
	
	undo.Create("BallSocket")
	undo.AddEntity(entConstraint)
	undo.SetPlayer(self:GetOwner())
	undo.Finish()
	self:GetOwner():AddCleanup("constraints", entConstraint)
	--Clear the objects so we're ready to go again
	self:ClearObjects()
	if self.Mode == "Easy" then
		self:ReleaseGhostEntity()
	end
	return true
end

function TOOL:RightClick(tblTrace)
	local intStage = self:NumObjects()
	if intStage <= 0 then
		local boolReturn = self:BallSocket(tblTrace, "Easy")
		if boolReturn == nil then return false elseif boolReturn then return true end
	end
	return false
end

function TOOL:Think()
	if self:NumObjects() != 1 or !self.Mode == "Easy" then return end
	self:UpdateGhostEntity()
end

function TOOL:Reload(tblTrace)
	if !tblTrace.Entity:IsValid() or tblTrace.Entity:IsPlayer() then return false end
	if CLIENT then return true end
	
	local bool = constraint.RemoveConstraints(tblTrace.Entity, "Ballsocket")
	return bool
end

function TOOL.BuildCPanel(panel)
	local tblPresetsBox = {}
	tblPresetsBox.Label = "#Presets"
	tblPresetsBox.MenuButton = 1
	tblPresetsBox.Folder = "ballsocket"
	tblPresetsBox.Options = {}
	tblPresetsBox.Options.Default = {}
	tblPresetsBox.Options.Default["ballsocket_forcelimit"] = 0
	tblPresetsBox.Options.Default["ballsocket_torquelimit"] = 0
	tblPresetsBox.Options.Default["ballsocket_nocollide"] = 0
	tblPresetsBox.CVars = {"ballsocket_forcelimit", "ballsocket_torquelimit", "ballsocket_nocollide"}
	panel:AddControl("ComboBox", tblPresetsBox)
	
	panel:AddControl("Slider", {Label = "#BallSocketTool_forcelimit", Description = "#BallSocketTool_forcelimit_desc", Type = "Float", Min = 0, Max = 50000, Command = "ballsocket_forcelimit"})
	panel:AddControl("Slider", {Label = "#BallSocketTool_torquelimit", Description = "#BallSocketTool_torquelimit_desc", Type = "Float", Min = 0, Max = 50000, Command = "ballsocket_torquelimit"})
	panel:AddControl("CheckBox", {Label = "#BallSocketTool_nocollide", Description = "#BallSocketTool_nocollide_desc", Command = "ballsocket_nocollide"})
end

if CLIENT then
	language.Add("Tool_ballsocket_0", "Left click: Prop or ragdoll, Right click: Prop or ragdoll to do easy ballsocket")
end
