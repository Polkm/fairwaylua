--[[-------------------------------------------------------
	This is kind of confusing but it basicly is a shared 
	file that adds all the tools in the tools folder to 
	the menu and set them up into a table
---------------------------------------------------------]]

ToolObj = {}

include('ghostentity.lua')
include('object.lua') --Adds the object functions
if CLIENT then
	include('stool_cl.lua')
end

function ToolObj:Create()
	local tblNewTool = {}
	--Sets up the meta table
	setmetatable(tblNewTool, self)
	self.__index = self
	
	--Declares all this shit for use later
	tblNewTool.Mode				= nil
	tblNewTool.SWEP				= nil
	tblNewTool.Owner			= nil
	tblNewTool.ClientConVar		= {}
	tblNewTool.ServerConVar		= {}
	tblNewTool.Objects			= {}
	tblNewTool.Stage			= 0
	tblNewTool.Message			= "start"
	tblNewTool.LastMessage		= 0
	tblNewTool.AllowedCVar		= 0
	
	return tblNewTool
end

function ToolObj:CreateConVars()
	local strToolMode = self:GetMode()
	if CLIENT then
		for strConvar, varDefaultValue in pairs(self.ClientConVar) do
			--Makes the convars that the tool maker says they need, also sets it up to save the value
			CreateClientConVar(strToolMode .. "_" .. strConvar, varDefaultValue, true, true)
		end
		return --The client bails now
	end
	--Note: I changed this from replicated because replicated convars don't work
	--when they're created via Lua.
	--Makes the server side convar so the owner of the server can stop players from using a tool
	--This is set to notify so that all the clients get a update when it's changed
	self.AllowedCVar = CreateConVar("toolmode_allow_" .. strToolMode, 1, FCVAR_NOTIFY)
end

function ToolObj:GetServerInfo(strProperty)
	--I am alost certine there are no server side proerties
	return GetConVarString(self:GetMode() .. "_" .. strProperty)
end

function ToolObj:GetClientInfo(strProperty)
	--To get the convar values that we made in the above function
	return self:GetOwner():GetInfo(self:GetMode() .. "_" .. strProperty)
end

function ToolObj:GetClientNumber(strProperty, intDefault)
	--To get the convar values that we made in the above function
	return self:GetOwner():GetInfoNum(self:GetMode() .. "_" .. strProperty, intDefault or 0)
end

function ToolObj:Allowed()
	if CLIENT then return true end --Wut?
	return self.AllowedCVar:GetBool()
end

--Now for all the ToolObj redirects
function ToolObj:GetMode() return self.Mode end
function ToolObj:GetSWEP() return self.SWEP end
function ToolObj:GetOwner() return self:GetSWEP().Owner or self.Owner end
function ToolObj:GetWeapon() return self:GetSWEP().Weapon or self.Weapon end

function ToolObj:LeftClick() return false end
function ToolObj:RightClick() return false end
function ToolObj:Reload() self:ClearObjects() end
function ToolObj:Deploy() self:ReleaseGhostEntity() return end
function ToolObj:Holster() self:ReleaseGhostEntity() return end
function ToolObj:Think() self:ReleaseGhostEntity() end

--[[-------------------------------------------------------
	Checks the objects before any action is taken
	This is to make sure that the entities haven't been removed
---------------------------------------------------------]]
function ToolObj:CheckObjects()
	for _, v in pairs(self.Objects) do
		--If its not the world and it is not valid then clear the objects
		if !v.Ent:IsWorld() and !v.Ent:IsValid() then
			self:ClearObjects()
			return --Because we are done here
		end
	end
end

--Get the tools in the stools folder
local tblTools = file.FindInLua(SWEP.Folder.."/stools/*.lua")
for _, strToolName in pairs(tblTools) do
	--Chop off the useless shit
	local char1, char2, strToolMode = string.find(strToolName, "([%w_]*)\.lua")
	--Make an empty tool object
	TOOL = ToolObj:Create()
	TOOL.Mode = strToolMode
	--Add the files to the code
	AddCSLuaFile("stools/" .. strToolName)
	include("stools/" .. strToolName)
	--Make the convars the tool needs
	TOOL:CreateConVars()
	--Add this new tool to the list
	SWEP.Tool[strToolMode] = TOOL
	TOOL = nil
end
--Dont need ToolObj anymore
ToolObj = nil

if CLIENT then
	--This adds the tools to the menu via the shity spawnmenu module
	--TODO: Add in my code to allow tool devs to set the default icon and thumbnail of the tool
	--Keep the tool list handy
	local TOOLS_LIST = SWEP.Tool
	--Add the STOOLS to the tool menu
	local function AddSToolsToMenu()
		for ToolName, TOOL in pairs(TOOLS_LIST) do
			if TOOL.AddToMenu != false then
				spawnmenu.AddToolMenuOption(TOOL.Tab or "Main",
												TOOL.Category or "New Category", 
												ToolName, 
												TOOL.Name or "#"..ToolName, 
												TOOL.Command or "gmod_tool "..ToolName, 
												TOOL.ConfigName or ToolName,
												TOOL.BuildCPanel)
			end
		end
	end
	hook.Add("PopulateToolMenu", "AddSToolsToMenu", AddSToolsToMenu)
end