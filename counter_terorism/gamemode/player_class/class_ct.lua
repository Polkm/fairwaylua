local CLASS = {}

CLASS.DisplayName			= "Counter-Terrorist"
CLASS.WalkSpeed 			= 300
CLASS.CrouchedWalkSpeed 	= 0.2
CLASS.RunSpeed				= 500
CLASS.DuckSpeed				= 0.4
CLASS.JumpPower				= 300
CLASS.DrawTeamRing			= false

function CLASS:Loadout(ply)
	ply:Give("weapon_pistol")
	ply:Give("weapon_ar2")
end

function CLASS:OnSpawn(ply)
end

player_class.Register("CT", CLASS)