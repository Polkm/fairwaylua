AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_menus.lua")
include("shared.lua")
GM.PlayerSpawnTime = {}

function GM:Initialize()
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

