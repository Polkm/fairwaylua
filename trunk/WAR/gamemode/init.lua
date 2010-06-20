AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_jdraw.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("sh_camera.lua")
AddCSLuaFile("sh_units.lua")
AddCSLuaFile("sh_locker.lua")
AddCSLuaFile("sh_util.lua")
include("shared.lua")
include("sh_camera.lua")
include("sh_units.lua")
include('sh_locker.lua')
include('sh_util.lua')
include("sv_commands.lua")
include("sv_savingloading.lua")

GM.SquadResponditory = {}

function GM:Initialize()
end

function GM:PlayerAuthed(ply, SteamID, UniqueID)
	ply:LoadGame()
end

function GM:PlayerSpawn(ply)
	--Polkm: Set some things to make cammra movement right
	ply:SetJumpPower(0)
	ply:SetStepSize(500)
	ply:SetWalkSpeed(400)
	ply:SetRunSpeed(1000)
	------------------------------
end

function GM:ScalePlayerDamage(ply,  hitgroup,  dmginfo)
	dmginfo:ScaleDamage(0)
end

--[[
local Locker = {}
Locker["boots"] = 1
Locker["grenades"] = 5
Locker["smg"] = 1
Locker["shotgun"] = 5

local Squads = {}
Squads[1] = {}
Squads[1].Class = "melontrooper"
Squads[1].Exp = 100
Squads[1].Equipment = {}
Squads[1].Equipment["boots"] = 1
Squads[1].Equipment["grenades"] = 3
Squads[1].Units = {}
Squads[1].Units[1] = {}
Squads[1].Units[1].Equipment = {}
Squads[1].Units[1].Equipment["smg"] = 1
Squads[1].Units[2] = {}
Squads[1].Units[2].Equipment = {"shotgun"}
Squads[1].Units[3] = {}
Squads[1].Units[3].Equipment = {"shotgun"}
Squads[2] = {}
Squads[2].Class = "melontrooper"
Squads[2].Exp = 50
Squads[2].Equipment = {}
Squads[2].Equipment["grenades"] = 2
Squads[2].Units = {}
Squads[2].Units[1] = {}
Squads[2].Units[1].Equipment = {"shotgun"}
Squads[2].Units[2] = {}
Squads[2].Units[2].Equipment = {"shotgun"}
Squads[2].Units[3] = {}
Squads[2].Units[3].Equipment = {"shotgun"}

local ActiveSquads = {1, 2}
]]

local Player = FindMetaTable("Player")
function Player:CreateSquad(strGivenSquadClass, vecHomePosition, strWeapon)
	local strSquadClass = strGivenSquadClass or "melontrooper"
	local strWeaponClass = strWeapon or "smg"
	local tblClassTable = GAMEMODE.Data.Classes[strSquadClass]
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
		entNewUnit:SetOwner(self)
		entNewUnit:SetClass(strSquadClass)
		entNewUnit:SetWeapon(strWeaponClass)
		entNewUnit:Spawn()
		entNewUnit.SquadTable = tblNewSquad
		table.insert(tblNewSquad.Units, entNewUnit)
	end
	self.Squads = self.Squads or {}
	table.insert(self.Squads, tblNewSquad)
	table.insert(GAMEMODE.SquadResponditory, tblNewSquad)
end

function GM:GetSquadByID(intSquadID)
	for _, Squad in pairs(GAMEMODE.SquadResponditory) do
		if Squad.SquadID == intSquadID then
			return Squad
		end
	end
end

