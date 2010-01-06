local Player = FindMetaTable("Player")

local Stat = {}
Stat.Name = "stat_maxhealth"
Stat.PrintName = "Max Health"
Stat.Desc = "The Maximum amount of Health you can have"
Stat.Default = 100
function Stat:OnSet(ply, intMaxHealth)
	ply:SetMaxHealth(intMaxHealth)
	ply:SetHealth(intMaxHealth)
end
Register.Stat(Stat)

local Stat = {}
Stat.Name = "stat_strength"
Stat.PrintName = "Strength"
Stat.Desc = "The more you have more damage melee attack will do"
Stat.Default = 1
Register.Stat(Stat)

local Stat = {}
Stat.Name = "stat_dexterity"
Stat.PrintName = "Dexterity"
Stat.Desc = "The more you have more damage ranged attack will do"
Stat.Default = 1
Register.Stat(Stat)

local Stat = {}
Stat.Name = "stat_intellect"
Stat.PrintName = "Intellect"
Stat.Desc = ""
Stat.Default = 1
Register.Stat(Stat)

local Stat = {}
Stat.Name = "stat_agility"
Stat.PrintName = "Agility"
Stat.Desc = "The higher this is teh faster you run and reload and attack"
Stat.Default = 1
function Stat:OnSet(ply, intAgility)
	ply:SetWalkSpeed(250 + (intAgility * 10))
	ply:SetRunSpeed(400 + (intAgility * 10))
end
Register.Stat(Stat)

local Stat = {}
Stat.Name = "stat_luck"
Stat.PrintName = "Luck"
Stat.Desc = "You find your self to be more lucky"
Stat.Default = 1
Register.Stat(Stat)

function Player:AddStat(strStat, intAmount)
	self:SetStat(strStat, self:GetStat(strStat) + intAmount)
end

function Player:SetStat(strStat, intAmount)
	self.Stats = self.Stats or {}
	self.Stats[strStat] = intAmount
	if SERVER then
		local tblStatTable = GAMEMODE.DataBase.Stats[strStat]
		if tblStatTable.OnSet then
			tblStatTable:OnSet(self, intAmount)
		end
		umsg.Start("UD_UpdateStats", self)
		umsg.String(strStat)
		umsg.Long(intAmount)
		umsg.End()
	end
end

function Player:GetStat(strStat)
	return self.Stats[strStat]
end

if SERVER then
	hook.Add("PlayerSpawn", "PlayerSpawn_Stats", function(ply)
		for name, stat in pairs(GAMEMODE.DataBase.Stats) do
			if ply.Stats then ply:SetStat(name, ply:GetStat(name)) end
		end
	end)
end