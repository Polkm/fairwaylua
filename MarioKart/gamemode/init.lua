AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
GM.PlayerSpawnTime = {}

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
	for j,h in pairs(ents.FindByClass("func_checkpoint")) do 
		if h.Number == mk_CurrentCheckPoint then
			print(h.Target)
				for k,v in pairs(player.GetAll()) do 
					for a,b in pairs(player.GetAll()) do
						if v:GetNWInt("CheckPoint") == b:GetNWInt("CheckPoint") then
							if v:GetPos():Distance(h.Target:GetPos()) > b:GetPos():Distance(h.Target:GetPos()) && v:GetNWInt("Place") > b:GetNWInt("Place")  then
								v:SetNWInt("Place",b:GetNWInt("Place"))
							end
						end
					end
				end
		end
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

