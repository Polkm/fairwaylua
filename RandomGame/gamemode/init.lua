AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_menus.lua")
include("shared.lua")
include("player.lua")
include("inventory.lua")
require("datastream")
-- DataStreams

function GM:Initialize()
end

function SendDataToAClient(ply) 
datastream.StreamToClients(ply,"LockerTransfer", {Upg = ply.Locker,} ) 
end
concommand.Add("LockerUpdate",SendDataToAClient)