AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
GM.PlayerSpawnTime = {}
GM.PosibleColors = {}
GM.PosibleColors["red"] = "models/gmodcart/CartBody_red"
GM.CheckPointEnts = {}

function GM:Initialize()
	util.PrecacheModel("models/marioragdoll/SuperMarioGalaxy/mario/mario.mdl")
	util.PrecacheModel("models/gmodcart/base_cart.mdl")
	util.PrecacheModel("models/gmodcart/base_cart_wheel.mdl")
	util.PrecacheModel("models/gmodcart/regular_cart_steerwheel.mdl")
	mk_CurrentCheckPoint = 1
	mk_CurrentLap = 1
end

function GM:SetPlayerColor(ply, strColor)
	if GAMEMODE.PosibleColors[strColor] then
		ply:GetNWEntity("Cart").BodyFrame:SetMaterial(GAMEMODE.PosibleColors[strColor])
	end
end
concommand.Add("mk_changeCarColor", function(ply, command, args)
	GAMEMODE:SetPlayerColor(ply, args[1])
end)

function GM:Think()
	local tblPlayerTable = {}
	for _, player in pairs(player.GetAll()) do
		local intPlace = 1
		for place, otherPlayer in pairs(tblPlayerTable) do
			if player:GetNWInt("Lap") > otherPlayer:GetNWInt("Lap") then
				intPlace = place
			elseif player:GetNWInt("CheckPoint") > otherPlayer:GetNWInt("CheckPoint") then
				intPlace = place
			elseif player:GetNWInt("CheckPoint") == otherPlayer:GetNWInt("CheckPoint") then
				local entCheckPoint = GAMEMODE.CheckPointEnts[player:GetNWInt("CheckPoint")]
				if !entCheckPoint then entCheckPoint = GAMEMODE.CheckPointEnts[1] end
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
		table.insert(tblPlayerTable, intPlace, player)
	end
	for place, player in pairs(tblPlayerTable) do
		player:SetNWInt("Place", place)
	end
end

function GM:PlayerInitialSpawn(ply)
	//ply:SetModel("models/gmodcart/regular_cart.mdl")
end

function GM:PlayerSpawn(ply)
	if ply:GetNWEntity("Cart"):IsValid() then ply:GetNWEntity("Cart"):Remove() end
	local cart = ents.Create("player_cart")
	local box = ents.Create("item_box")
	box:SetPos(Vector(0, 0, 40))
	box:Spawn()
	cart:SetPos(ply:GetPos())
	cart:Spawn()
	cart:SetOwner(ply)
	ply:SetNWEntity("Cart", cart)
	ply:SetNWInt("CheckPoint", 1)
	ply:SetNWInt("Lap", 1)
	ply:SetNWInt("Place",1)
	ply.CanJump = true
	GAMEMODE:SetPlayerSpeed(ply,0,0)
	cart:SetPos(ply:GetPos())
	cart:SetAngles(ply:GetAngles())
end


local ClientResources = 0
local function ProcessFolder ( Location )
	for k, v in pairs(file.Find(Location .. '*')) do
		if !string.find(Location, ".svn") then
			if file.IsDir(Location .. v) then
				ProcessFolder(Location .. v .. '/')
			else
				local OurLocation = string.gsub(Location .. v, '../gamemodes/' .. GM.Path .. '/content/', '')
				
				if !string.find(Location, '.db') then			
					ClientResources = ClientResources + 1;
					resource.AddFile(OurLocation);
				end
			end
		end
	end
end

GM.Path = "MarioKart";
if !SinglePlayer() then
	ProcessFolder('../gamemodes/' .. GM.Path .. '/content/models/');
	ProcessFolder('../gamemodes/' .. GM.Path .. '/content/materials/');
	ProcessFolder('../gamemodes/' .. GM.Path .. '/content/sound/');
end

