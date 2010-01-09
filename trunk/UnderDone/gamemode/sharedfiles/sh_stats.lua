local Player = FindMetaTable("Player")

local Stat = {}
Stat.Name = "stat_maxhealth"
Stat.PrintName = "Max Health"
Stat.Desc = "The Maximum amount of Health you can have"
Stat.Default = 100
function Stat:OnSet(ply, intMaxHealth, intOldMaxHealth)
	ply:SetMaxHealth(intMaxHealth)
end
function Stat:OnSpawn(ply, intMaxHealth)
	print(intMaxHealth, ply:GetMaxHealth())
	ply:Health(intMaxHealth)
end
Register.Stat(Stat)

local Stat = {}
Stat.Name = "stat_strength"
Stat.PrintName = "Strength"
Stat.Desc = "The more you have more damage melee attack will do"
Stat.Default = 1
function Stat:OnSet(ply, intStrength, intOldStrength)
	ply:AddStat("stat_maxhealth", (intStrength - intOldStrength) * 0.5)
end
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
function Stat:OnSet(ply, intAgility, intOldAgility)
	ply:SetWalkSpeed(250 + (intAgility * 10))
	ply:SetRunSpeed(400 + (intAgility * 10))
end
Register.Stat(Stat)

local Stat = {}
Stat.Name = "stat_luck"
Stat.PrintName = "Luck"
Stat.Desc = "You find your self to be more lucky, crit hits"
Stat.Default = 1
Register.Stat(Stat)

function Player:AddStat(strStat, intAmount)
	if intAmount != 0 then
		local intDirection = math.abs(intAmount) / intAmount
		self:SetStat(strStat, self:GetStat(strStat) + (intDirection * math.ceil(math.abs(intAmount))))
	end
end

function Player:SetStat(strStat, intAmount)
	local tblStatTable = GAMEMODE.DataBase.Stats[strStat]
	self.Stats = self.Stats or {}
	local intOldStat = self.Stats[strStat] or tblStatTable.Default
	self.Stats[strStat] = intAmount
	if SERVER then
		if tblStatTable.OnSet then
			tblStatTable:OnSet(self, intAmount, intOldStat)
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
			if ply.Stats then
				ply:SetStat(name, ply:GetStat(name))
				PrintTable(stat)
				if stat.OnSpawn then
					stat:OnSpawn(ply, ply:GetStat(name))
				end
			end
		end
	end)
end

if CLIENT then
	function UpdateStatUsrMsg(usrMsg)
		LocalPlayer():SetStat(usrMsg:ReadString(), usrMsg:ReadLong())
	end
	usermessage.Hook("UD_UpdateStats", UpdateStatUsrMsg)
end