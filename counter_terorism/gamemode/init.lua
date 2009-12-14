AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

SetGlobalEntity("TERRORISTbomber", nil)

function GM:Initialize()
		if ( GAMEMODE.GameLength > 0 ) then
			timer.Simple( GAMEMODE.GameLength * 60, function() GAMEMODE:EndOfGame( true ) end )
			SetGlobalFloat( "GameEndTime", CurTime() + GAMEMODE.GameLength * 60 )
		end
		
		// If we're round based, wait 5 seconds before the first round starts
		if ( GAMEMODE.RoundBased ) then
			timer.Simple( 10, function() GAMEMODE:StartRoundBasedGame() end )
		end
		
		if ( GAMEMODE.AutomaticTeamBalance ) then
			timer.Create( "CheckTeamBalance", 30, 0, function() GAMEMODE:CheckTeamBalance() end )
		end
--Precache all the models
	/*util.PrecacheModel(	"models/Humans/Group01/Male_01.mdl")
	util.PrecacheModel("models/Humans/Group01/male_02.mdl")
	util.PrecacheModel("models/Humans/Group01/male_03.mdl")
	util.PrecacheModel("models/Humans/Group01/Male_04.mdl")
	util.PrecacheModel("models/Humans/Group01/Male_05.mdl")
	util.PrecacheModel("models/Humans/Group01/male_06.mdl")
	util.PrecacheModel("models/Humans/Group01/male_07.mdl")
	util.PrecacheModel("models/Humans/Group01/male_08.mdl")
	util.PrecacheModel("models/Humans/Group01/male_09.mdl")
	util.PrecacheModel(	"models/Humans/Group01/Female_01.mdl")
	util.PrecacheModel(	"models/Humans/Group01/Female_02.mdl")
	util.PrecacheModel(	"models/Humans/Group01/Female_03.mdl")
	util.PrecacheModel(	"models/Humans/Group01/Female_04.mdl")
	util.PrecacheModel(	"models/Humans/Group01/Female_06.mdl")
	util.PrecacheModel(	"models/Humans/Group01/Female_07.mdl")*/
end

function GM:ResetTeams()
	for _, player in pairs(team.GetPlayers(TEAM_TERRORIST)) do
		player:SetTeam(TEAM_COUNTERTERRORIST)
		player:SetPlayerClass("class_ct")
	end
end

function GM:OnPreRoundStart( num )

	game.CleanUpMap()
	UTIL_StripAllPlayers()
	GAMEMODE:ResetTeams()
	if team.NumPlayers(TEAM_TERRORIST) < team.NumPlayers(TEAM_COUNTERTERRORIST) / 3 then
		local randomguy = table.Random(team.GetPlayers(TEAM_COUNTERTERRORIST))
		randomguy:SetTeam(TEAM_TERRORIST)
		randomguy:SetPlayerClass("TERRORISTBomber")
		randomguy:KillSilent()
		randomguy:Spawn()
	end
	if team.NumPlayers(TEAM_TERRORIST) >= 1 then 
		local ChosenBomber = team.GetPlayers(TEAM_TERRORIST)[math.random(1,#team.GetPlayers(TEAM_TERRORIST))]
		ChosenBomber:SetPlayerClass("TerroristIED")
		ChosenBomber:KillSilent()
		ChosenBomber:Spawn()
	end
	
	UTIL_SpawnAllPlayers()
	UTIL_FreezeAllPlayers()
	GAMEMODE:SpawningCitizens()

end

function GM:OnRoundStart( num )
	UTIL_UnFreezeAllPlayers()
	timer.Create( "CheckRoundEnd", 1, 0, function() GAMEMODE:CheckRoundEnd() end )
end

function GM:SpawningCitizens()
	local intervaltime = GAMEMODE.RoundPreStartTime / table.Count(ents.FindByClass("info_player_start"))
	local number = 1
	for j,h in pairs(ents.FindByClass("info_player_start")) do
		local Blocked = false
		for k,v in pairs(ents.FindInBox(h:GetPos()+ Vector(80,80,200),h:GetPos()+ Vector(-80,-80,-200))) do
			if v:GetClass() == "snpc_citizen" or v:IsPlayer() then
				Blocked = true
			end
		end
			if !Blocked then
			timer.Simple(intervaltime * number, 
				function()
					local ent = ents.Create("snpc_citizen")
					ent:SetPos(h:GetPos())
					ent:Spawn()
				end)
			number = number + 1
		end
	end
end

function GM:CheckRoundEnd()
	if ( !GAMEMODE.RoundBased ) then return end
	if ( !GAMEMODE:InRound() ) then return end
	if team.NumPlayers(TEAM_COUNTERTERRORIST) <= 0 && team.NumPlayers(TEAM_TERRORIST) <= 0 then
		GAMEMODE:RoundEndWithResult(ROUND_RESULT_DRAW)
	elseif team.NumPlayers(TEAM_COUNTERTERRORIST) <= 0 then
		GAMEMODE:RoundEndWithResult(ROUND_RESULT_DRAW)
	elseif team.NumPlayers(TEAM_TERRORIST) <= 0 then
		GAMEMODE:RoundEndWithResult(ROUND_RESULT_DRAW)	
	end

end

function GM:CheckPlayerDeathRoundEnd()

	if ( !GAMEMODE.RoundBased ) then return end
	if ( !GAMEMODE:InRound() ) then return end
	local alivects = 0 
	local alivets = 0 
	for _,playr in pairs(player.GetAll()) do 
		if playr:Team() == 2 && playr:Alive() then
			alivects = alivects + 1 
		elseif playr:Team() == 1 && playr:Alive() then
			alivets = alivets + 1 
		end
	end
	if alivects <= 0 and alivets > 0 then
		for _,playr in pairs(player.GetAll()) do
			playr:ConCommand("PlayAlert ts_win")
		end
		GAMEMODE:RoundEndWithResult(TEAM_TERRORIST)
	elseif alivects > 0 and alivets <= 0 && !GAMEMODE.Bombplanted then
		for _,playr in pairs(player.GetAll()) do
			playr:ConCommand("PlayAlert cts_win")
		end
		GAMEMODE:RoundEndWithResult(TEAM_COUNTERTERRORIST)
	end
end

function GM:PlayerDeathThink( pl )

	pl.DeathTime = pl.DeathTime or CurTime()
	local timeDead = CurTime() - pl.DeathTime
	
	// If we're in deathcam mode, promote to a generic spectator mode
	if ( GAMEMODE.DeathLingerTime > 0 && timeDead > GAMEMODE.DeathLingerTime && ( pl:GetObserverMode() == OBS_MODE_FREEZECAM || pl:GetObserverMode() == OBS_MODE_DEATHCAM ) ) then
		GAMEMODE:BecomeObserver( pl )
	end
	
	// If we're in a round based game, player NEVER spawns in death think
	if ( GAMEMODE.NoAutomaticSpawning ) then return end
	
	// The gamemode is holding the player from respawning.
	// Probably because they have to choose a class..
	if ( !pl:CanRespawn() ) then return end

	// Don't respawn yet - wait for minimum time...
	if ( GAMEMODE.MinimumDeathLength ) then 
	
		pl:SetNWFloat( "RespawnTime", pl.DeathTime + GAMEMODE.MinimumDeathLength )
		
		if ( timeDead < pl:GetRespawnTime() ) then
			return
		end
		
	end

	// Force respawn
	if ( pl:GetRespawnTime() != 0 && GAMEMODE.MaximumDeathLength != 0 && timeDead > GAMEMODE.MaximumDeathLength ) then
		pl:Spawn()
		return
	end

	// We're between min and max death length, player can press a key to spawn.
	if ( pl:KeyPressed( IN_ATTACK ) || pl:KeyPressed( IN_ATTACK2 ) || pl:KeyPressed( IN_JUMP ) ) then
		pl:Spawn()
	end
	
end

function GM:RoundTimerEnd()
	if !GAMEMODE:InRound() then return end
	if team.NumPlayers(TEAM_COUNTERTERRORIST) >= 1 && GAMEMODE.Bombplanted != true then 
		GAMEMODE:RoundEndWithResult(TEAM_COUNTERTERRORIST)
	else
		GAMEMODE:RoundEndWithResult(ROUND_RESULT_DRAW)
	end	
end

function GM:RoundEnd()
	if ( !GAMEMODE:InRound() ) then 
		MsgN("WARNING: RoundEnd being called while gamemode not in round...")
		debug.Trace()
		return 
	end
	GAMEMODE:OnRoundEnd( GetGlobalInt( "RoundNumber" ) )
	self:SetInRound( false )
	timer.Destroy( "RoundEndTimer" )
	timer.Destroy( "CheckRoundEnd" )
	SetGlobalFloat( "RoundEndTime", -1 )

	timer.Simple( GAMEMODE.RoundPostLength, function()   GAMEMODE:PreRoundStart( GetGlobalInt( "RoundNumber" )+1 ) end )
end

function GM:PlayerSpawn(ply)	
	self.BaseClass:PlayerSpawn(ply)
	if ply:Team() == TEAM_TERRORIST then
		--Decides Gender and Model
		local model = GAMEMODE.Models.Male[math.random(1,#GAMEMODE.Models.Male)]
		local MaleorFemale = math.random(0,1) 
		if MaleorFemale == 1 then
			ply.GenderMale = true
		else
			model = GAMEMODE.Models.Female[math.random(1,#GAMEMODE.Models.Female)]
		end
		ply:SetModel(model)
		GAMEMODE:SetPlayerSpeed(ply,85,250)
		------------------------------------
	elseif ply:Team() == TEAM_COUNTERTERRORIST then
		local model = GAMEMODE.Models.CT[math.random(1,#GAMEMODE.Models.CT)]
		ply:SetModel(model)
		GAMEMODE:SetPlayerSpeed(ply,150,211)
		ply:SetNWBool("isdf", false)
		ply:SetNWInt("dftime", 0)
	end
	ply:SetJumpPower(200)
end

function GM:Diffuse(ply,entity)
	local old = ply:GetNWInt("dftime")
	ply:SetNWBool("isdf", true)
	if ply:Health() >= 1 then
		if ply:GetNWInt("dftime") >= 64 then
			ply:Freeze( false ) 
			entity:Remove()
			ply:SetNWBool("isdf", false)
		
			timer.Simple(3,	function() 
			for _,playr in pairs(player.GetAll()) do
				playr:ConCommand("PlayAlert cts_win")
			end
			//GAMEMODE:RoundEndWithResult(TEAM_COUNTERTERRORIST) 
			
						end)
		else
		timer.Simple(0.125, function() ply:SetNWInt("dftime", old +1) GAMEMODE:Diffuse(ply,entity) end)
		end
	end
end

function PlayerDisconnectedHook(ply)
	if ply == SetGlobalEntity("TERRORISTbomber") then 
		PrintMessage(HUD_PRINTCENTER,"The bomb carrier has left, restarting")
		SetGlobalEntity("TERRORISTbomber",nil)
	end		
end
hook.Add( "PlayerDisconnected", "PlayerDisconnectedHook", PlayerDisconnectedHook )

function GM:PlayerHurt(ply,attacker)
	if ply:Team() == TEAM_TERRORIST then
		if ply.GenderMale then
			ply:EmitSound(Sound("vo/npc/male01/pain0"..math.random(1,9)..".wav"),100,100)
		else
			ply:EmitSound(Sound("vo/npc/female01/pain0"..math.random(1,9)..".wav"),100,100)
		end
	end
end 

