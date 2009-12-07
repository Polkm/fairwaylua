GM.Name 	= "Counter Terorism"
GM.Author 	= "Polkm & Noobulator"
GM.Email 	= ""
GM.Website 	= ""

DeriveGamemode("fretta")
IncludePlayerClasses()

GM.Help	= "Terrorists explode bomb, counter terorist stop them."
GM.TeamBased = true
GM.AllowAutoTeam = false
GM.AllowSpectating = true
GM.SelectClass = true
GM.SecondsBetweenTeamSwitches = 0
GM.GameLength = 10
GM.NoPlayerDamage = false
GM.NoPlayerSelfDamage = false
GM.NoPlayerTeamDamage = true
GM.NoPlayerPlayerDamage = false
GM.NoNonPlayerPlayerDamage = false
GM.TakeFragOnSuicide = false
GM.AddFragsToTeamScore = true	
GM.ForceJoinBalancedTeams = false	

GM.NoAutomaticSpawning = false		
GM.RoundBased = true			
GM.RoundEndsWhenOneTeamAlive = true

TEAM_TERORIST = 1
TEAM_COUNTERTERORIST = 2

function GM:CreateTeams()
	if !GAMEMODE.TeamBased then return end
	
	team.SetUp(TEAM_TERORIST, "Terorists", Color(255, 200, 50), false)
	team.SetSpawnPoint(TEAM_TERORIST, {"info_player_terrorist"})
	team.SetClass(TEAM_TERORIST, {"TeroristBomber", "TerroristIED"})
	
	team.SetUp(TEAM_COUNTERTERORIST, "Counter Terorists", Color(70, 230, 70))
	team.SetSpawnPoint(TEAM_COUNTERTERORIST, {"info_player_counterterrorist"}, true)
	team.SetClass(TEAM_COUNTERTERORIST, {"TerroristIED"})
end

function GM:PlayerCanJoinTeam(ply, TEAMID)
	if SERVER && !self.BaseClass:PlayerCanJoinTeam(ply, TEAMID) then 
		return false
	end
	if ply:Team() == TEAM_COUNTERTERORIST then
		return false
	end
	return true
end
