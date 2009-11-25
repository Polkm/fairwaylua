AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_ghost.lua")
AddCSLuaFile("cl_placespanel.lua")
AddCSLuaFile("cl_charactercreation.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("sh_items.lua")
include("shared.lua")
include("sh_items.lua")
include("player.lua")
GM.PlayerSpawnTime = {}
GM.CheckPointEnts = {}

function GM:Initialize()
	util.PrecacheModel("models/marioragdoll/SuperMarioGalaxy/mario/mario.mdl")
	util.PrecacheModel("models/gmodcart/base_cart.mdl")
	util.PrecacheModel("models/gmodcart/base_cart_wheel.mdl")
	util.PrecacheModel("models/gmodcart/regular_cart_steerwheel.mdl")
	GAMEMODE:StartPrep()
end

function GM:StartPrep()
	--[[for _, ply in pairs(player.GetAll()) do
		ply:SetNWEntity("WatchEntity", ply:GetNWEntity("Cart"))
	end]]
	SetGlobalString("GameModeState", "PREP")
	SetGlobalEntity("Winner", "none")
	if timer.IsTimer("mk_GameModeTimer") then timer.Destroy("mk_GameModeTimer") end
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

function GM:ShouldCollide(enta, entb)
	if !enta:IsWorld() && entb:IsPlayer() then return false end
	return true
end

function GM:PositionRacers()
	local IntTakens = 0
	local tblSpawnPoints = ents.FindByClass("info_player_start")
	for _, ply in pairs(player.GetAll()) do
		ply:ConCommand("mk_Sound StartLineUp")
		for _, spawnPoint in pairs(tblSpawnPoints) do 
			if !spawnPoint.Taken then
				ply:Spawn()
				GAMEMODE:SpawnCart(ply)
				ply:GetNWEntity("Cart"):SetPos(spawnPoint:GetPos() + Vector(0,0,10))
				ply:GetNWEntity("Cart"):SetAngles(spawnPoint:GetAngles())
				ply:GetNWEntity("Cart"):SetVelocity(Vector(0,0,0))
				spawnPoint.Taken = true	
				break
			else
				IntTakens = IntTakens + 1
			end
		end
		if IntTakens == table.Count(tblSpawnPoints) then
			local entSellectedSpawn = tblSpawnPoints[math.random(1, table.Count(tblSpawnPoints))]
			GAMEMODE:SpawnCart(ply)
			ply:GetNWEntity("Cart"):SetPos(entSellectedSpawn:GetPos() + Vector(0,0,30))
			ply:GetNWEntity("Cart"):SetAngles(entSellectedSpawn:GetAngles())
			ply:GetNWEntity("Cart"):SetVelocity(Vector(0,0,0))
		end
	end
end

function GM:StartRace()
	SetGlobalString("GameModeState", "RACE")
	SetGlobalInt("GameModeTime", 0)
	GAMEMODE:CleanUpMap()
	for _, ply in pairs(player.GetAll()) do
		ply:ConCommand("mk_Sound BackGround")
	end
	for _, spawnPoint in pairs(ents.FindByClass("info_player_start")) do 
		spawnPoint.Taken = false
	end
	timer.Create("mk_GameModeTimer", 0.1, 0, function() SetGlobalInt("GameModeTime", GetGlobalInt("GameModeTime") + 0.1) end)
end

function GM:RaceFinish()
	if GetGlobalString("GameModeState") == "RACE" then
		SetGlobalString("GameModeState", "PENDING")
		timer.Simple(GAMEMODE.CatchUpTime, function() timer.Destroy("mk_GameModeTimer") GAMEMODE:StartPrep() end)
	end
end

function GM:CleanUpMap()
	for _, ent in pairs(ents.FindByClass("ent_projectile")) do
		ent:Remove()
	end
end

function GM:Tick()
	local tblPlayerTable = {}
	for playerNum, Player in pairs(player.GetAll()) do
		local intPlace = playerNum
		if Player:GetNWInt("Lap") <= 0 then
			intPlace = Player:GetNWInt("Place")
		else
			for place, otherPlayer in pairs(tblPlayerTable) do
				if otherPlayer:GetNWInt("Lap") > 0 then
					if Player:GetNWInt("Lap") > otherPlayer:GetNWInt("Lap") then
						if place < intPlace then intPlace = place end
					elseif Player:GetNWInt("Lap") == otherPlayer:GetNWInt("Lap") then
						if Player:GetNWInt("CheckPoint") > otherPlayer:GetNWInt("CheckPoint") then
							if place < intPlace then intPlace = place end
						elseif Player:GetNWInt("CheckPoint") == otherPlayer:GetNWInt("CheckPoint") then
							local entCheckPoint = GAMEMODE.CheckPointEnts[Player:GetNWInt("CheckPoint")] or GAMEMODE.CheckPointEnts[1]
							entCheckPoint = entCheckPoint.Target
							local entPlayerCart = Player:GetNWEntity("Cart")
							local entOtherPlayerCart = otherPlayer:GetNWEntity("Cart")
							if entPlayerCart:GetPos():Distance(entCheckPoint:GetPos()) <= entOtherPlayerCart:GetPos():Distance(entCheckPoint:GetPos()) then
								if place < intPlace then intPlace = place end
							end
						end
					end
				end
			end
		end
		table.insert(tblPlayerTable, intPlace, Player)
	end
	for place, Player in pairs(tblPlayerTable) do
		Player:SetNWInt("Place", place)
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

