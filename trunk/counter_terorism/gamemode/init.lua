AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

SetGlobalEntity("teroristbomber", nil)

function GM:ResetTeams()
	for _, player in pairs(team.GetPlayers(TEAM_TERORIST)) do
		player:SetTeam(TEAM_COUNTERTERORIST)
	end
end

function GM:CheckRoundEnd()
	if !GAMEMODE:InRound() then return end
	if team.NumPlayers(TEAM_COUNTERTERORIST) > 0 and team.NumPlayers(TEAM_TERORIST) > 0 then
		PrintMessage(HUD_PRINTTALK, "Terorists Won!")
		GAMEMODE:RoundEndWithResult(TEAM_TERORIST)
		GAMEMODE:ResetTeams()
	end
	timer.Create("CheckRoundEnd", 1, 0, function() GAMEMODE:CheckRoundEnd() end)
end

function GM:RoundTimerEnd()
	if !GAMEMODE:InRound() then return end
	if team.NumPlayers(TEAM_COUNTERTERORIST) >= 1 then 
		PrintMessage( HUD_PRINTTALK, "Counter Terorists Won!")
		GAMEMODE:RoundEndWithResult(TEAM_COUNTERTERORIST)
	else
		PrintMessage(HUD_PRINTTALK, "Game draw")
		GAMEMODE:RoundEndWithResult(ROUND_RESULT_DRAW)
	end	
	GAMEMODE:ResetTeams()
end

function GM:PlayerSpawn(ply)
	self.BaseClass:PlayerSpawn(ply)
	if team.NumPlayers(TEAM_TERORIST) < team.NumPlayers(TEAM_COUNTERTERORIST) / 3 then
		local randomguy = table.Random(team.GetPlayers(TEAM_COUNTERTERORIST))
		randomguy:SetTeam(TEAM_TERORIST)
		randomguy:SetPlayerClass("TeroristBomber")
		randomguy:KillSilent()
	end
end