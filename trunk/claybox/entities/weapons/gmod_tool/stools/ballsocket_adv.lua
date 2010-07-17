TOOL.Category		= "Constraints"
TOOL.Name			= "#Ball Socket - Advanced"
TOOL.Command		= nil
TOOL.ConfigName		= nil

TOOL.ClientConVar[ "forcelimit" ] = "0"
TOOL.ClientConVar[ "torquelimit" ] = "0"
TOOL.ClientConVar[ "xmin" ] = "-180"
TOOL.ClientConVar[ "ymin" ] = "-180"
TOOL.ClientConVar[ "zmin" ] = "-180"
TOOL.ClientConVar[ "xmax" ] = "180"
TOOL.ClientConVar[ "ymax" ] = "180"
TOOL.ClientConVar[ "zmax" ] = "180"
TOOL.ClientConVar[ "xfric" ] = "0"
TOOL.ClientConVar[ "yfric" ] = "0"
TOOL.ClientConVar[ "zfric" ] = "0"
TOOL.ClientConVar[ "nocollide" ] = "0"
TOOL.ClientConVar[ "onlyrotation" ] = "0"

function TOOL:LeftClick(tblTrace)
	if tblTrace.Entity:IsValid() and tblTrace.Entity:IsPlayer() then return end
	--If there's no physics object then we can't constraint it!
	if SERVER and !util.IsValidPhysicsObject(tblTrace.Entity, tblTrace.PhysicsBone) then return false end
	
	local intStage = self:NumObjects()
	local Phys = tblTrace.Entity:GetPhysicsObjectNum(tblTrace.PhysicsBone)
	self:SetObject(intStage + 1, tblTrace.Entity, tblTrace.HitPos, Phys, tblTrace.PhysicsBone, tblTrace.HitNormal)

	if intStage > 0 then
		if CLIENT then return true end
		if !self:GetEnt(1):IsValid() and !self:GetEnt(2):IsValid() then
			self:ClearObjects()
			return
		end
	
		--Get client's CVars
		local _forcelimit = self:GetClientNumber("forcelimit")
		local _torquelimit = self:GetClientNumber("torquelimit")
		local _xmin	= self:GetClientNumber("xmin")
		local _xmax	= self:GetClientNumber("xmax")
		local _ymin	= self:GetClientNumber("ymin")
		local _ymax	= self:GetClientNumber("ymax")
		local _zmin	= self:GetClientNumber("zmin")
		local _zmax	= self:GetClientNumber("zmax")
		local _xfric = self:GetClientNumber("xfric")
		local _yfric = self:GetClientNumber("yfric")
		local _zfric = self:GetClientNumber("zfric")
		local _nocollide = self:GetClientNumber("nocollide")
		local _onlyrotation	= self:GetClientNumber("onlyrotation")
		
		local Ent1, Ent2  = self:GetEnt(1), self:GetEnt(2)
		local Bone1, Bone2 = self:GetBone(1), self:GetBone(2)
		local LPos1, LPos2 = self:GetLocalPos(1), self:GetLocalPos(2)
		
		local constraint = constraint.AdvBallsocket(Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, _forcelimit, _torquelimit, _xmin, _ymin, _zmin, _xmax, _ymax, _zmax, _xfric, _yfric, _zfric, _onlyrotation, _nocollide)
	
		undo.Create("AdvBallsocket")
		undo.AddEntity(constraint)
		undo.SetPlayer(self:GetOwner())
		undo.Finish()
		
		self:GetOwner():AddCleanup("constraints", constraint)

		--Clear the objects so we're ready to go again
		self:ClearObjects()
	else
		self:SetStage(intStage + 1)
	end
	return true
end

function TOOL:Reload(tblTrace)
	if !tblTrace.Entity:IsValid() or tblTrace.Entity:IsPlayer() then return false end
	if CLIENT then return true end
	local bool = constraint.RemoveConstraints(tblTrace.Entity, "AdvBallsocket")
	return bool
end

function TOOL.BuildCPanel(panel)
	local tblPresetsBox = {}
	tblPresetsBox.Label = "#Presets"
	tblPresetsBox.MenuButton = 1
	tblPresetsBox.Folder = "ballsocket_advanced"
	tblPresetsBox.Options = {}
	tblPresetsBox.Options.Default = {}
	tblPresetsBox.Options.Default["ballsocket_adv_forcelimit"] = 0
	tblPresetsBox.Options.Default["ballsocket_adv_torquelimit"] = 0
	tblPresetsBox.Options.Default["ballsocket_adv_xmin"] = -180
	tblPresetsBox.Options.Default["ballsocket_adv_ymin"] = -180
	tblPresetsBox.Options.Default["ballsocket_adv_zmin"] = -180
	tblPresetsBox.Options.Default["ballsocket_adv_xmax"] = 180
	tblPresetsBox.Options.Default["ballsocket_adv_ymax"] = 180
	tblPresetsBox.Options.Default["ballsocket_adv_zmax"] = 180
	tblPresetsBox.Options.Default["ballsocket_adv_xfric"] = 0
	tblPresetsBox.Options.Default["ballsocket_adv_yfric"] = 0
	tblPresetsBox.Options.Default["ballsocket_adv_zfric"] = 0
	tblPresetsBox.Options.Default["ballsocket_adv_onlyrotation"] = 0
	tblPresetsBox.Options.Default["ballsocket_adv_nocollide"] = 0
	tblPresetsBox.CVars = {"ballsocket_adv_forcelimit", "ballsocket_adv_torquelimit", "ballsocket_adv_xmin", "ballsocket_adv_ymin", "ballsocket_adv_zmin", "ballsocket_adv_xmax",
		"ballsocket_adv_ymax", "ballsocket_adv_zmax", "ballsocket_adv_xfric", "ballsocket_adv_yfric", "ballsocket_adv_zfric", "ballsocket_adv_onlyrotation", "ballsocket_adv_nocollide"}
	panel:AddControl("ComboBox", tblPresetsBox)
	
	panel:AddControl("Slider", {Label = "#AdvBallsocketTool_forcelimit", Description = "#AdvBallsocketTool_forcelimit_desc", Type = "Float", Min = 0, Max = 50000, Command = "ballsocket_adv_forcelimit"})
	panel:AddControl("Slider", {Label = "#AdvBallsocketTool_torquelimit", Description = "#AdvBallsocketTool_torquelimit_desc", Type = "Float", Min = 0, Max = 50000, Command = "ballsocket_adv_torquelimit"})
	
	panel:AddControl("Slider", {Label = "#AdvBallsocketTool_xmin", Description = "#AdvBallsocketTool_xmin_desc", Color = GAMEMODE.ColorPallet["Red"], Type = "Float", Min = -180, Max = 180, Command = "ballsocket_adv_xmin"})
	panel:AddControl("Slider", {Label = "#AdvBallsocketTool_xmax", Description = "#AdvBallsocketTool_xmax_desc", Color = GAMEMODE.ColorPallet["Red"], Type = "Float", Min = -180, Max = 180, Command = "ballsocket_adv_xmax"})
	panel:AddControl("Slider", {Label = "#AdvBallsocketTool_xfriction", Description = "#AdvBallsocketTool_xfriction_desc", Color = GAMEMODE.ColorPallet["Red"], Type = "Float", Min = 0, Max = 100, Command = "ballsocket_adv_xfric"})
	
	panel:AddControl("Slider", {Label = "#AdvBallsocketTool_ymin", Description = "#AdvBallsocketTool_ymin_desc", Color = GAMEMODE.ColorPallet["Green"], Type = "Float", Min = -180, Max = 180, Command = "ballsocket_adv_ymin"})
	panel:AddControl("Slider", {Label = "#AdvBallsocketTool_ymax", Description = "#AdvBallsocketTool_ymax_desc", Color = GAMEMODE.ColorPallet["Green"], Type = "Float", Min = -180, Max = 180, Command = "ballsocket_adv_ymax"})
	panel:AddControl("Slider", {Label = "#AdvBallsocketTool_yfriction", Description = "#AdvBallsocketTool_yfriction_desc", Color = GAMEMODE.ColorPallet["Green"], Type = "Float", Min = 0, Max = 100, Command = "ballsocket_adv_yfric"})
	
	panel:AddControl("Slider", {Label = "#AdvBallsocketTool_zmin", Description = "#AdvBallsocketTool_zmin_desc", Color = GAMEMODE.ColorPallet["Blue"], Type = "Float", Min = -180, Max = 180, Command = "ballsocket_adv_zmin"})
	panel:AddControl("Slider", {Label = "#AdvBallsocketTool_zmax", Description = "#AdvBallsocketTool_zmax_desc", Color = GAMEMODE.ColorPallet["Blue"], Type = "Float", Min = -180, Max = 180, Command = "ballsocket_adv_zmax"})
	panel:AddControl("Slider", {Label = "#AdvBallsocketTool_zfriction", Description = "#AdvBallsocketTool_zfriction_desc", Color = GAMEMODE.ColorPallet["Blue"], Type = "Float", Min = 0, Max = 100, Command = "ballsocket_adv_zfric"})
	
	panel:AddControl("CheckBox", {Label = "#AdvBallsocketTool_freemove", Description = "#AdvBallsocketTool_freemove_desc", Command = "ballsocket_adv_onlyrotation"})
	panel:AddControl("CheckBox", {Label = "#AdvBallsocketTool_nocollide", Description = "#AdvBallsocketTool_nocollide_desc", Command = "ballsocket_adv_nocollide"})
end


