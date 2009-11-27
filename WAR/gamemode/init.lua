AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("sh_camera.lua")
AddCSLuaFile("units.lua")
include("shared.lua")
include("sh_camera.lua")
include("units.lua")
include("commands.lua")

function GM:Initialize()
end

function GM:PlayerSpawn(ply)
	--Polkm: Set some things to make cammra movement right
	ply:SetJumpPower(0)
	ply:SetStepSize(500)
	ply:SetWalkSpeed(400)
	ply:SetRunSpeed(1000)
	------------------------------
	ply:CreateSquad("melontrooper")
	ply:CreateSquad("melontrooper")
end

function GM:Tick()
	--Polkm: This is were we think for the wellons, kus the normal "think" function is slow and lagy
	for _, Unit in pairs(ents.FindByClass("ent_plrunit")) do
		--Polkm: Other ways of doing it
		--[[local trace = {}
		trace.start = Unit:GetPos() + Vector(0,0,0)
		trace.endpos = trace.start + Vector(0,0,-300)
		trace.filter = ents.FindByClass("ent_plrunit")
		local trace = util.TraceLine(trace)
		Unit.TargetPostion.z = trace.HitPos.z + 20]]
		
		Unit:StepTick()
		Unit:TurnTick()
	end
end

local Player = FindMetaTable("Player")
function Player:CreateSquad(strGivenSquadName, vecGivenPosition)
	local strSquadName = strGivenSquadName or "melontrooper"
	local tblSquadTable = GAMEMODE.Data.Units[strSquadName]
	local vecCreatePosition = vecGivenPosition or self:GetPos() + Vector(math.random(-500, 500), math.random(-500, 500), 0)
	local tblNewSquad = {}
	tblNewSquad.Class = strSquadName
	tblNewSquad.Owner = self
	if self.Squads then tblNewSquad.SquadID = #self.Squads + 1
	else tblNewSquad.SquadID = 1 end
	tblNewSquad.Units = {}
	for i = 1, tblSquadTable.SquadLimit do
		local entNewUnit = ents.Create("ent_plrunit")
		entNewUnit:SetModel(tblSquadTable.Model)
		entNewUnit:SetOwner(self)
		entNewUnit:SetPos(vecCreatePosition + Vector(math.random(-tblSquadTable.SquadLimit * 15, tblSquadTable.SquadLimit * 15), math.random(-tblSquadTable.SquadLimit * 15, tblSquadTable.SquadLimit * 15), 20))
		entNewUnit.TargetPostion = entNewUnit:GetPos()
		entNewUnit.SquadTable = tblNewSquad
		entNewUnit:Spawn()
		entNewUnit:SetClass("melontrooper")
		entNewUnit:SetWeapon("smg")
		table.insert(tblNewSquad.Units, entNewUnit)
	end
	if !self.Squads then self.Squads = {} end
	table.insert(self.Squads, tblNewSquad)
end