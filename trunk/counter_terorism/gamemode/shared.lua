GM.Name 	= "Counter Terrorism"
GM.Author 	= "Polkm and Noobulator"
GM.Email 	= ""
GM.Website 	= ""

DeriveGamemode("fretta")
IncludePlayerClasses()



GM.Alerts = {}
GM.Alerts["cts_win"] = {text = "Counter-Terrorists Win",Sound = "ct/ctwin.wav"}
GM.Alerts["Bombplant"] = {text = "The Bomb Has been Planted",Sound = "ct/bombpl.wav"}
GM.Alerts["ts_win"] = {text = "Terrorists Win",Sound = "ct/terwin.wav"}

GM.Models = {
	Female = {
	"models/player/Group01/Female_01.mdl",
	"models/player/Group01/Female_02.mdl",
	"models/player/Group01/Female_03.mdl",
	"models/player/Group01/Female_04.mdl",
	"models/player/Group01/Female_06.mdl",
	"models/player/Group01/Female_07.mdl",
	}
	,
	Male = {
	"models/player/Group01/Male_01.mdl",
	"models/player/Group01/male_02.mdl",
	"models/player/Group01/male_03.mdl",
	"models/player/Group01/Male_04.mdl",
	"models/player/Group01/Male_05.mdl",
	"models/player/Group01/male_06.mdl",
	"models/player/Group01/male_07.mdl",
	"models/player/Group01/male_08.mdl",
	"models/player/Group01/male_09.mdl",
	}
	,
	CT = {
	"models/player/swat.mdl",
	"models/player/urban.mdl",
	"models/player/riot.mdl",
	"models/player/gasmask.mdl",
	}
}


GM.Help	= "Terrorists explode bomb, counter TERRORIST stop them."
GM.TeamBased = true
GM.AllowAutoTeam = false
GM.AllowSpectating = true
GM.SelectClass = true
GM.SecondsBetweenTeamSwitches = 0
GM.GameLength = 15
GM.RoundLength = 300
GM.NoPlayerDamage = false
GM.NoPlayerSelfDamage = false
GM.NoPlayerTeamDamage = true
GM.NoPlayerPlayerDamage = false
GM.NoNonPlayerPlayerDamage = false
GM.TakeFragOnSuicide = false
GM.AddFragsToTeamScore = true	
GM.ForceJoinBalancedTeams = false	

GM.RealisticFallDamage = true

GM.NoAutomaticSpawning = true	// Players don't spawn automatically when they die, some other system spawns them
GM.RoundBased = true				// Round based, like CS
GM.RoundLength = 300					// Round length, in seconds
GM.RoundPreStartTime = 5			// Preperation time before a round starts
GM.RoundPostLength = 8				// Seconds to show the 'x team won!' screen at the end of a roundf

GM.RoundEndsWhenOneTeamAlive = false	

GM.EnableFreezeCam = true			// TF2 Style Freezecam
GM.DeathLingerTime = 3				// The time between you dying and it going into spectator mode, 0 disables


TEAM_TERRORIST = 1
TEAM_COUNTERTERRORIST = 2


function GM:CreateTeams()
	if !GAMEMODE.TeamBased then return end
	
	team.SetUp(TEAM_TERRORIST, "Terrorists", Color(155,0,0,200), false)
	team.SetSpawnPoint(TEAM_TERRORIST, {"info_player_terrorist"})
	team.SetClass(TEAM_TERRORIST, {"TERRORISTBomber", "TerroristIED"})
	
	team.SetUp(TEAM_COUNTERTERRORIST, "Counter TERRORISTs", Color(30,30,155,200))
	team.SetSpawnPoint(TEAM_COUNTERTERRORIST, {"info_player_counterterrorist"}, true)
	team.SetClass(TEAM_COUNTERTERRORIST, {"CT"})
end

function GM:PlayerCanJoinTeam(ply, TEAMID)
	if SERVER && !self.BaseClass:PlayerCanJoinTeam(ply, TEAMID) then 
		return false
	end
	if ply:Team() == TEAM_COUNTERTERRORIST then
		return false
	end
	return true
end
