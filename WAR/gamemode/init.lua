AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("units.lua")
include("shared.lua")
include("units.lua")
include("commands.lua")

function GM:Initialize()
end

function GM:PlayerSpawn(ply)
	--Polkm: We make this thing to have a entity to look at
	local entity = ents.Create("prop_dynamic")
	entity:SetModel("models/error.mdl")
	entity:Spawn()
	entity:SetAngles(ply:GetAngles())
	entity:SetMoveType(MOVETYPE_NONE)
	entity:SetParent(ply)
	entity:SetPos(ply:GetPos())
	entity:SetRenderMode(RENDERMODE_NONE)
	entity:SetSolid(SOLID_NONE)
	ply:SetViewEntity(entity)
	--Polkm: Set some things to make cammra movement right
	ply:SetJumpPower(0)
	ply:SetStepSize(500)
	ply:SetWalkSpeed(400)
	ply:SetRunSpeed(1000)
	------------------------------
	ply:CreateSquad("melontrooper")
	ply:CreateSquad("melontrooper")
	ply:CreateSquad("melontrooper")
	ply:CreateSquad("melontrooper")
end

function GM:Tick()
	--Polkm: This is were we think for the wellons, kus the normal "think" function is slow and lagy
	for k, Unit in pairs(ents.FindByClass("ent_plrunit")) do
		--Polkm: Other ways of doing it
		--[[local trace = {}
		trace.start = Unit:GetPos() + Vector(0,0,0)
		trace.endpos = trace.start + Vector(0,0,-300)
		trace.filter = ents.FindByClass("ent_plrunit")
		local trace = util.TraceLine(trace)
		Unit.TargetPostion.z = trace.HitPos.z + 20]]
		
		if Unit.ShouldMoveToTarget then
			Unit:StepTwardsTarget()
		end
		
		if Unit.ShouldFaceTarget then
			Unit:FaceTwardsTarget()
		end
		
		local newAngle = Unit:GetAngles()
		newAngle.r = 90
		Unit:SetAngles(newAngle)
	end
end

local Player = FindMetaTable("Player")
function Player:CreateSquad(strSquadName, vecPosition)
	local SquadName = strSquadName or "melontrooper"
	local SquadTable = GAMEMODE.Data.Units[SquadName]
	local CreatePosition = vecPosition or self:GetPos() + Vector(math.random(-500, 500), math.random(-500, 500), 0)
	local NewSquad = {}
	NewSquad.Class = SquadName
	NewSquad.Owner = self
	if self.Squads then NewSquad.SquadID = #self.Squads + 1
	else NewSquad.SquadID = 1 end
	NewSquad.Units = {}
	for i = 1, SquadTable.SquadLimit do
		local NewUnit = ents.Create("ent_plrunit")
		NewUnit:SetModel(SquadTable.Model)
		NewUnit:SetOwner(self)
		NewUnit:SetPos(CreatePosition + Vector(math.random(-SquadTable.SquadLimit * 15, SquadTable.SquadLimit * 15), math.random(-SquadTable.SquadLimit * 15, SquadTable.SquadLimit * 15), 20))
		NewUnit.TargetPostion = NewUnit:GetPos()
		NewUnit.SquadTable = NewSquad
		NewUnit:Spawn()
		table.insert(NewSquad.Units, NewUnit)
	end
	if !self.Squads then self.Squads = {} end
	table.insert(self.Squads, NewSquad)
end