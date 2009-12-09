AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

SetGlobalEntity("TERRORISTbomber", nil)

function GM:ResetTeams()
	for _, player in pairs(team.GetPlayers(TEAM_TERRORIST)) do
		player:SetTeam(TEAM_COUNTERTERRORIST)
	end
end

function GM:OnPreRoundStart( num )

	game.CleanUpMap()
	
	UTIL_StripAllPlayers()
	UTIL_SpawnAllPlayers()
	UTIL_FreezeAllPlayers()
	
	if team.NumPlayers(TEAM_TERRORIST) < team.NumPlayers(TEAM_COUNTERTERRORIST) / 3 then
		local randomguy = table.Random(team.GetPlayers(TEAM_COUNTERTERRORIST))
		randomguy:SetTeam(TEAM_TERRORIST)
		randomguy:SetPlayerClass("TERRORISTBomber")
		randomguy:KillSilent()
	end

end

function GM:OnRoundStart( num )
	UTIL_UnFreezeAllPlayers()
	GAMEMODE:SpawningCitizens()
end

function GM:SpawningCitizens()
	for j,h in pairs(ents.FindByClass("info_player_start")) do
			for i=0, 25 do
				local Blocked = false
				for k,v in pairs(ents.FindInBox(h:GetPos()+ Vector(80,80,200),h:GetPos()+ Vector(-80,-80,-200))) do
					if v:GetClass() == "snpc_citizen" or v:IsPlayer() then
						Blocked = true
					end
				end
				if !Blocked then
					local ent = ents.Create("snpc_citizen")
					ent:SetPos(h:GetPos())
					ent:Spawn()
					break
				end
			end
		end
end
function GM:CheckRoundEnd()
	if !GAMEMODE:InRound() then return end
	if team.NumPlayers(TEAM_COUNTERTERRORIST) < 0 and team.NumPlayers(TEAM_TERRORIST) > 0 then
		GAMEMODE:RoundEndWithResult(TEAM_TERRORIST)
		GAMEMODE:ResetTeams()
	elseif team.NumPlayers(TEAM_COUNTERTERRORIST) > 0 and team.NumPlayers(TEAM_TERRORIST) < 0 then
		GAMEMODE:RoundEndWithResult(TEAM_COUNTERTERRORIST)
		GAMEMODE:ResetTeams()
	end
	timer.Create("CheckRoundEnd", 1, 0, function() GAMEMODE:CheckRoundEnd() end)
end

function GM:RoundTimerEnd()
	if !GAMEMODE:InRound() then return end
	if team.NumPlayers(TEAM_COUNTERTERRORIST) >= 1 then 
		GAMEMODE:RoundEndWithResult(TEAM_COUNTERTERRORIST)
	else
		GAMEMODE:RoundEndWithResult(ROUND_RESULT_DRAW)
	end	
	GAMEMODE:ResetTeams()
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
		------------------------------------
	elseif ply:Team() == TEAM_COUNTERTERRORIST then
		local model = GAMEMODE.Models.CT[math.random(1,#GAMEMODE.Models.CT)]
		ply:SetModel(model)
	end
end

function GM:Diffuse(ply,entity)
	local old = ply:GetNWInt("dftime")
	ply:SetNWBool("isdf", true)
	if ply:Health() >= 1 then
		if ply:GetNWInt("dftime") >= 64 then
			ply:Freeze( false ) 
			entity:Remove()
			ply:SetNWBool("isdf", false)
			PrintMessage(HUD_PRINTCENTER,"COUNTER-TERRORISTS WIN")
			for k,v in pairs(player.GetAll()) do
				CTSWIN(v)
			end
			timer.Simple(3,EndGame())
		else
		timer.Simple(0.125, function() ply:SetNWInt("dftime", old +1) diffuse(ply,entity) end)
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

