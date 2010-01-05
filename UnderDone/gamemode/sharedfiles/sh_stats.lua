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

if SERVER then
	hook.Add("PlayerSpawn", "PlayerSpawn_Stats", function(ply)
		for name, stat in pairs(GAMEMODE.DataBase.Stats) do
			if ply.Stats then ply:SetStat(name, ply:GetStat(name)) end
		end
	end)
end