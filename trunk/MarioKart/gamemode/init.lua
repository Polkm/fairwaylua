AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_ghost.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
include("player.lua")
GM.PlayerSpawnTime = {}
GM.CheckPointEnts = {}
GM.GameModeState = "PREP"

function GM:Initialize()
	util.PrecacheModel("models/marioragdoll/SuperMarioGalaxy/mario/mario.mdl")
	util.PrecacheModel("models/gmodcart/base_cart.mdl")
	util.PrecacheModel("models/gmodcart/base_cart_wheel.mdl")
	util.PrecacheModel("models/gmodcart/regular_cart_steerwheel.mdl")
	GAMEMODE:StartPrep()
end

function GM:StartPrep()
	GAMEMODE.GameModeState = "PREP"
	timer.Simple(30, function()
		
	end)
end

function GM:PositionRacers()
	for k,v in pairs(player.GetAll()) do
		v:Spawn()
	end
end

function GM:StartRace()
	GAMEMODE.GameModeState = "RACE"
end

function GM:Tick()
	local tblPlayerTable = {}
	for _, player in pairs(player.GetAll()) do
		local intPlace = 1
		for place, otherPlayer in pairs(tblPlayerTable) do
			if player:GetNWInt("Lap") > otherPlayer:GetNWInt("Lap") then
				intPlace = place
			else
				if player:GetNWInt("CheckPoint") > otherPlayer:GetNWInt("CheckPoint") then
					intPlace = place
				elseif player:GetNWInt("CheckPoint") == otherPlayer:GetNWInt("CheckPoint") then
					local entCheckPoint = GAMEMODE.CheckPointEnts[player:GetNWInt("CheckPoint")] or GAMEMODE.CheckPointEnts[1]
					entCheckPoint = entCheckPoint.Target
					local entPlayerCart = player:GetNWEntity("Cart")
					local entOtherPlayerCart = otherPlayer:GetNWEntity("Cart")
					if entPlayerCart:GetPos():Distance(entCheckPoint:GetPos()) <= entOtherPlayerCart:GetPos():Distance(entCheckPoint:GetPos()) then
						intPlace = place
					elseif entPlayerCart:GetPos():Distance(entCheckPoint:GetPos()) > entOtherPlayerCart:GetPos():Distance(entCheckPoint:GetPos()) then
						intPlace = place + 1
					end
				elseif player:GetNWInt("CheckPoint") < otherPlayer:GetNWInt("CheckPoint") then
					intPlace = place + 1
				end
			end
		end
		table.insert(tblPlayerTable, intPlace, player)
	end
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

