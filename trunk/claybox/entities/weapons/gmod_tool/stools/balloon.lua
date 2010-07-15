TOOL.Category		= "Construction"
TOOL.Name			= "#Balloons"
TOOL.Command		= nil
TOOL.ConfigName		= nil

TOOL.ClientConVar["indestructible"]	= "0"
TOOL.ClientConVar["explosive"]	= "0"
TOOL.ClientConVar["ropelength"]	= "64"
TOOL.ClientConVar["force"] = "500"
TOOL.ClientConVar["r"] = "255"
TOOL.ClientConVar["g"] = "255"
TOOL.ClientConVar["b"] = "0"
TOOL.ClientConVar["skin"] = "models/balloon/balloon"

cleanup.Register("balloons")

function TOOL:LeftClick(tblTrace, boolAttach)
	if tblTrace.Entity and tblTrace.Entity:IsPlayer() then return false end
	if CLIENT then return true end
	if boolAttach == nil then boolAttach = true end
	--If there's no physics object then we can't constraint it!
	if SERVER and boolAttach and !util.IsValidPhysicsObject(tblTrace.Entity, tblTrace.PhysicsBone) then return false end
	
	local ply = self:GetOwner()
	local indestructible 	= self:GetClientNumber("indestructible", 0)
	local explosive 		= self:GetClientNumber("explosive", 0)
	local length 			= self:GetClientNumber("ropelength", 64)
	local material 			= "cable/rope"
	local force 			= self:GetClientNumber("force", 500)
	local r 				= self:GetClientNumber("r", 255)
	local g 				= self:GetClientNumber("g", 0)
	local b 				= self:GetClientNumber("b", 0)
	local skin 				= self:GetClientInfo("skin")
	
	if skin != "models/balloon/balloon" and skin != "models/balloon/balloon_hl2" then
		r = 255
		g = 255
		b = 255
	end
	if tblTrace.Entity:IsValid() and tblTrace.Entity:GetClass() == "gmod_balloon" and tblTrace.Entity.Player == ply then
		local force = self:GetClientNumber("force", 500)
		tblTrace.Entity:SetForce(force)
		tblTrace.Entity:GetPhysicsObject():Wake()
		tblTrace.Entity:SetColor(r, g, b, 255)
		tblTrace.Entity:SetForce(force)
		tblTrace.Entity:SetMaterial(skin)
		tblTrace.Entity.Indestructible = tobool(indestructible)
		tblTrace.Entity.Explosive = tobool(explosive)
		return true
	end
	if !self:GetSWEP():CheckLimit("balloons") then return false end

	local Pos = tblTrace.HitPos + tblTrace.HitNormal * 10
	local balloon = MakeBalloon(ply, r, g, b, explosive, indestructible, force, skin, {Pos = Pos})
	
	undo.Create("Balloon")
	undo.AddEntity(balloon)

	if boolAttach then
		--The real model should have an attachment!
		local attachpoint = Pos + Vector(0, 0, -10)
		local LPos1 = balloon:WorldToLocal(attachpoint)
		local LPos2 = tblTrace.Entity:WorldToLocal(tblTrace.HitPos)
		
		if tblTrace.Entity:IsValid() then
			local phys = tblTrace.Entity:GetPhysicsObjectNum(tblTrace.PhysicsBone)
			if phys:IsValid() then
				LPos2 = phys:WorldToLocal(tblTrace.HitPos)
			end
		end
		local constraint, rope = constraint.Rope(balloon, tblTrace.Entity, 0, tblTrace.PhysicsBone, LPos1, LPos2, 0, length, 0, 1.5, material, nil)
		undo.AddEntity(rope)
		undo.AddEntity(constraint)
		ply:AddCleanup("balloons", rope)
		ply:AddCleanup("balloons", constraint)
	end
	
	undo.SetPlayer(ply)
	undo.Finish()
	
	ply:AddCleanup("balloons", balloon)
	return true
end

function TOOL:RightClick(tblTrace)
	return self:LeftClick(tblTrace, false)
end

function TOOL.BuildCPanel(panel)
	local tblPresetsBox = {}
	tblPresetsBox.Label = "#Presets"
	tblPresetsBox.MenuButton = 1
	tblPresetsBox.Folder = "balloon"
	tblPresetsBox.Options = {}
	tblPresetsBox.Options.Default = {}
	tblPresetsBox.Options.Default["balloon_indestructible"] = 0
	tblPresetsBox.Options.Default["balloon_explosive"] = 0
	tblPresetsBox.Options.Default["balloon_ropelength"] = 64
	tblPresetsBox.Options.Default["balloon_ropematerial"] = "cable/rope"
	tblPresetsBox.Options.Default["balloon_force"] = 600
	tblPresetsBox.Options.Default["balloon_r"] = 255
	tblPresetsBox.Options.Default["balloon_g"] = 255
	tblPresetsBox.Options.Default["balloon_b"] = 0
	tblPresetsBox.CVars = {"balloon_indestructible", "balloon_explosive", "balloon_ropelength", "balloon_ropematerial", "balloon_force", "balloon_r", "balloon_g", "balloon_b"}
	panel:AddControl("ComboBox", tblPresetsBox)
	
	local tblSkinSellector = {}
	tblSkinSellector.Label = "#Balloon_skin"
	tblSkinSellector.MenuButton = 0
	tblSkinSellector.Options = {}
	tblSkinSellector.Options["#Blank"] = {["balloon_skin"] = "models/balloon/balloon"}
	tblSkinSellector.Options["#HalfLife2"] = {["balloon_skin"] = "models/balloon/balloon_hl2"}
	tblSkinSellector.Options["#MILFMAN"] = {["balloon_skin"] = "models/balloon/balloon_milfman"}
	tblSkinSellector.Options["#Target"] = {["balloon_skin"] = "models/balloon/balloon_nips"}
	panel:AddControl("ComboBox", tblSkinSellector)
	
	panel:AddControl("Color", {Label = "#Balloon_color", Red = "balloon_r", Green = "balloon_g", Blue = "balloon_b", ShowAlpha = 0, ShowHSV = 1, ShowRGB = 1, Multiplier = 255})
	panel:AddControl("Slider", {Label = "#Balloon_ropelength", Type = "Float", Min = 4, Max = 400, Command = "balloon_ropelength"})
	panel:AddControl("Slider", {Label = "#Balloon_force", Description = "#Balloon_force_desc", Type = "Float", Min = -1000, Max = 2500, Command = "balloon_force"})
	panel:AddControl("CheckBox", {Label = "#Tool_balloon_indestructible", Command = "balloon_indestructible"})
	panel:AddControl("CheckBox", {Label = "#Tool_balloon_explosive", Command = "balloon_explosive"})
end

if CLIENT then
	language.Add("Tool_balloon_indestructible", "Indestructible")
	language.Add("Tool_balloon_explosive", "Explosive")
end

function MakeBalloon(ply, r, g, b, explosive, indestructible, force, skin, Data)
	if !ply:CheckLimit("balloons") then return nil end

	local balloon = ents.Create("gmod_balloon")
	if !balloon:IsValid() then return end
	duplicator.DoGeneric(balloon, Data)
	balloon:Spawn()
	duplicator.DoGenericPhysics(balloon, ply, Data)
	
	balloon:SetRenderMode(RENDERMODE_TRANSALPHA)
	balloon:SetColor(r, g, b, 255)
	balloon:SetForce(force)
	balloon:SetPlayer(ply)
	balloon.Indestructible = tobool(indestructible)
	balloon.Explosive = tobool(explosive)

	balloon:SetMaterial(skin)
	
	balloon.Player = ply
	balloon.r = r
	balloon.g = g
	balloon.b = b
	balloon.skin = skin
	balloon.force = force
	balloon.indestructible = indestructible
	balloon.explosive = explosive
	
	ply:AddCount("balloons", balloon)
	return balloon
end
duplicator.RegisterEntityClass("gmod_balloon", MakeBalloon, "r", "g", "b", "explosive", "indestructible", "force", "skin", "Data")