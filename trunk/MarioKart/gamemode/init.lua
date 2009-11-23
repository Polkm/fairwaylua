AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_ghost.lua")
AddCSLuaFile("cl_placespanel.lua")
AddCSLuaFile("cl_charactercreation.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
include("player.lua")
GM.PlayerSpawnTime = {}
GM.CheckPointEnts = {}
GM.PrepTime = 15
GM.WinLaps = 3
GM.CatchUpTime = 30

function GM:Initialize()
	util.PrecacheModel("models/marioragdoll/SuperMarioGalaxy/mario/mario.mdl")
	util.PrecacheModel("models/gmodcart/base_cart.mdl")
	util.PrecacheModel("models/gmodcart/base_cart_wheel.mdl")
	util.PrecacheModel("models/gmodcart/regular_cart_steerwheel.mdl")
	GAMEMODE:StartPrep()
end

function GM:StartPrep()
	for k,v in pairs(player.GetAll()) do
		v:SetNWEntity("WatchEntity",v:GetNWEntity("Cart"))
	end
	SetGlobalEntity("Winner","none")
	SetGlobalString("GameModeState", "PREP")
	if timer.IsTimer("mk_GameModeTimer") then
		timer.Destroy("mk_GameModeTimer")
	end
	SetGlobalInt("CountDown", GAMEMODE.PrepTime)
	timer.Create("mk_CountDown", 1, 0, function()
		SetGlobalInt("CountDown", GetGlobalInt("CountDown") - 1)
		if GetGlobalInt("CountDown") <= 0 then
			GAMEMODE:StartRace()
			timer.Destroy("mk_CountDown")
		end
	end)
	timer.Simple(GAMEMODE.PrepTime / 2, function()
		GAMEMODE:PositionRacers()
		SetGlobalInt("GameModeTime", GAMEMODE.PrepTime / 2)
		timer.Create("mk_GameModeTimer", 0.1, 0, function() SetGlobalInt("GameModeTime", GetGlobalInt("GameModeTime") - 0.1) end)
	end)
end

function GM:ShouldCollide( enta, entb )
if entb:IsPlayer() then return false end
return true
end

function GM:RaceFinish(ply)
		SetGlobalString("GameModeState", "PENDING")
		ply.Finished = true
		ply:ConCommand("mk_Sound End")
		ply.CanUse = false
		if GetGlobalEntity("Winner") == "none" then
			SetGlobalEntity("Winner",ply)
			timer.Simple(GAMEMODE.CatchUpTime, function() timer.Destroy("mk_GameModeTimer") GAMEMODE:StartPrep() end)
		end
		for _, player in pairs(player.GetAll()) do
			player:ChatPrint(ply:Nick() .. " Came in " .. ply:GetNWInt("Place") ..
			"With a time of " .. (string.ToMinutesSecondsMilliseconds(math.Round(GetGlobalInt("GameModeTime") * 10) / 10)))
			if player.Finished && GetGlobalEntity("Winner") != "none" then
				player:SetNWEntity("WatchEntity", GetGlobalEntity("Winner"):GetNWEntity("Cart"))
			end
		end
end

function GM:PositionRacers()
	for k,v in pairs(player.GetAll()) do
		v:SetViewEntity(v:GetNWEntity("Cart"))
		v:ConCommand("mk_Sound StartLineUp")
		v:Spawn()
	end
end

function GM:StartRace()
	SetGlobalString("GameModeState", "RACE")
	SetGlobalInt("GameModeTime", 0)
	GAMEMODE:CleanUpMap()
	for k,v in pairs(player.GetAll()) do
		v:ConCommand("mk_Sound BackGround")
	end
	timer.Create("mk_GameModeTimer", 0.1, 0, function() SetGlobalInt("GameModeTime", GetGlobalInt("GameModeTime") + 0.1) end)
end

function GM:CleanUpMap()
	for _, ent in pairs(ents.FindByClass("ent_projectile")) do
		ent:Remove()
	end
end

function GM:Tick()
	local tblPlayerTable = {}
	local intDefaultPlace = 1
	for playerNum, player in pairs(player.GetAll()) do
		local intPlace = intDefaultPlace
		if player:GetNWInt("Lap") == 0 then
			--intPlace = player:GetNWInt("Place")
		else
			for place, otherPlayer in pairs(tblPlayerTable) do
				if otherPlayer:GetNWInt("Lap") > 0 then
					if player:GetNWInt("Lap") > otherPlayer:GetNWInt("Lap") then
						intPlace = place
					elseif player:GetNWInt("Lap") == otherPlayer:GetNWInt("Lap") then
						if player:GetNWInt("CheckPoint") > otherPlayer:GetNWInt("CheckPoint") then
							intPlace = place
						elseif player:GetNWInt("CheckPoint") == otherPlayer:GetNWInt("CheckPoint") then
							local entCheckPoint = GAMEMODE.CheckPointEnts[player:GetNWInt("CheckPoint")] or GAMEMODE.CheckPointEnts[1]
							entCheckPoint = entCheckPoint.Target
							local entPlayerCart = player:GetNWEntity("Cart")
							local entOtherPlayerCart = otherPlayer:GetNWEntity("Cart")
							if entPlayerCart:GetPos():Distance(entCheckPoint:GetPos()) <= entOtherPlayerCart:GetPos():Distance(entCheckPoint:GetPos()) then
								intPlace = place
							end
						end
					end
				end
			end
		end
		table.insert(tblPlayerTable, intPlace, player)
		intDefaultPlace = intDefaultPlace + 1
	end
	PrintTable(tblPlayerTable)
	for place, player in pairs(tblPlayerTable) do
		player:SetNWInt("Place", place)
	end
end

local ClientResources = 0
local function ProcessFolder(Location)
	for k, v in pairs(file.Find(Location .. '*')) do
		if !string.find(Location, ".svn") then
			if file.IsDir(Location .. v) then
				ProcessFolder(Location .. v .. '/')
			else
				local OurLocation = string.gsub(Location .. v, '../gamemodes/' .. GM.Path .. '/content/', '')
				if !string.find(Location, '.db') then			
					ClientResources = ClientResources + 1
					resource.AddFile(OurLocation)
				end
			end
		end
	end
end

GM.Path = "MarioKart"
if !SinglePlayer() then
	ProcessFolder('../gamemodes/' .. GM.Path .. '/content/models/')
	ProcessFolder('../gamemodes/' .. GM.Path .. '/content/materials/')
	ProcessFolder('../gamemodes/' .. GM.Path .. '/content/sound/')
end

