AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_jdraw.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("sh_camera.lua")
AddCSLuaFile("sh_units.lua")
include("shared.lua")
include("sh_camera.lua")
include("sh_units.lua")
include("commands.lua")
GM.SquadResponditory = {}

function GM:Initialize()
end

function GM:PlayerSpawn(ply)
	--Polkm: Set some things to make cammra movement right
	ply:SetJumpPower(0)
	ply:SetStepSize(500)
	ply:SetWalkSpeed(400)
	ply:SetRunSpeed(1000)
	------------------------------
	ply:CreateSquad("melontrooper", nil, "shotgun")
	ply:CreateSquad("melontrooper", nil, "smg")
end

function GM:Tick()
	--Polkm: This is were we think for the wellons, kus the normal "think" function is slow and lagy
	for _, Squad in pairs(GAMEMODE.SquadResponditory) do
		if Squad.Units then
			for _, Unit in pairs(Squad.Units)do
				if Unit and Unit:IsValid() then
					Unit:StepTick()
					Unit:TurnTick()
				end
			end
		end
	end
end

local Player = FindMetaTable("Player")
function Player:CreateSquad(strGivenSquadName, vecHomePosition, strWeapon)
	local strSquadClass = strGivenSquadName or "melontrooper"
	local strWeaponClass = strWeapon or "smg"
	local tblClassTable = GAMEMODE.Data.Units[strSquadClass]
	local vecSquadHomePosition = vecHomePosition or self:GetPos() + Vector(math.random(-500, 500), math.random(-500, 500), 0)
	local intSquadID = #GAMEMODE.SquadResponditory + 1
	local tblNewSquad = {}
	tblNewSquad.Class = strSquadClass
	tblNewSquad.Owner = self
	tblNewSquad.SquadID = intSquadID
	tblNewSquad.HomePos = vecSquadHomePosition
	tblNewSquad.Units = {}
	for i = 1, tblClassTable.SquadLimit do
		local entNewUnit = ents.Create("ent_plrunit")
		entNewUnit:SetPos(vecSquadHomePosition + GAMEMODE:GetPlacement(tblClassTable.SquadLimit))
		entNewUnit.TargetPostion = entNewUnit:GetPos()
		entNewUnit:SetModel(tblClassTable.Model)
		entNewUnit:SetOwner(self)
		entNewUnit:SetClass(strSquadClass)
		entNewUnit:SetWeapon(strWeaponClass)
		entNewUnit:Spawn()
		entNewUnit:SetNWInt("health", tblClassTable.Health)
		entNewUnit.SquadTable = tblNewSquad
		table.insert(tblNewSquad.Units, entNewUnit)
	end
	table.insert(GAMEMODE.SquadResponditory, tblNewSquad)
end

function GM:GetSquadByID(intSquadID)
	for _, Squad in pairs(GAMEMODE.SquadResponditory) do
		if Squad.SquadID == intSquadID then
			return Squad
		end
	end
end

