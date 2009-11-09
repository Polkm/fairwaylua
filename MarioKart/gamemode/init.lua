AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_menus.lua")
include("shared.lua")
GM.PlayerSpawnTime = {}

function GM:Initialize()
util.PrecacheModel( "models/marioragdoll/SuperMarioGalaxy/mario/mario.mdl" )
util.PrecacheModel( "models/gmodcart/regular_cart.mdl" )
util.PrecacheModel("models/gmodcart/cart_wheel.mdl" )
util.PrecacheModel("models/gmodcart/regular_cart_steerwheel.mdl" )
end

function GM:PlayerInitialSpawn(ply)
	//ply:SetModel("models/gmodcart/regular_cart.mdl")
end

function GM:PlayerSpawn(ply)
	local cart = ents.Create("player_cart")
	cart:SetPos(Vector(0,0,20))
	cart:Spawn()
	ply:SetNWEntity("Cart",cart)
	cart:SetOwner(ply)
	ply:SetViewEntity(cart)
	ply:Give("weapon_physgun")
end

local ClientResources = 0;
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

