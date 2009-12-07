local CLASS = {}

CLASS.DisplayName			= "Terrorist Bomber"
CLASS.WalkSpeed 			= 300
CLASS.CrouchedWalkSpeed 	= 0.2
CLASS.RunSpeed				= 500
CLASS.DuckSpeed				= 0.4
CLASS.JumpPower				= 300
CLASS.DrawTeamRing			= false

function CLASS:Loadout(ply)
	ply:Give("weapon_crowbar")
end

function CLASS:OnSpawn(ply)
	SetGlobalEntity("teroristbomber", ply)
end

player_class.Register("TeroristBomber", CLASS)