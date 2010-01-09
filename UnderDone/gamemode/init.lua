require("glon")
AddCSLuaFile("shared.lua")
AddCSLuaFile("sh_resource.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_mainmenu.lua")
AddCSLuaFile("cl_jdraw.lua")
AddCSLuaFile("cl_papperdoll.lua")
AddCSLuaFile("cl_papperdoll_editor.lua")
include("shared.lua")
include("itemdata/sh_items_base.lua")
include("sh_resource.lua")
include("player_ex.lua")
include("commands.lua")
include("savingloading.lua")

function GM:PlayerInitialSpawn(ply)
end

function GM:PlayerAuthed(ply, SteamID, UniqueID)
	ply:LoadGame()
end

function GM:PlayerSpawn(ply)
	--ply:ConCommand("UD_AddNotification You got an alowance of " .. tostring(alowence) .. " Dollars") 
	hook.Call("PlayerLoadout", GAMEMODE, ply)
	hook.Call("PlayerSetModel", GAMEMODE, ply)
end

function GM:PlayerLoadout(ply)
	if !ply.Data or !ply.Data.Paperdoll then return end
	local strPrimaryWeapon = ply.Data.Paperdoll["slot_primaryweapon"]
	if !strPrimaryWeapon then return end
	local tblItemTable = GAMEMODE.DataBase.Items[strPrimaryWeapon]
	if !tblItemTable then return end
	ply:Give("weapon_primaryweapon")
	ply:GetWeapon("weapon_primaryweapon"):SetWeapon(tblItemTable)
	return true
end

function GM:PlayerUse(ply, entity)
	if entity.Item then
		local intAmount = 1
		if entity.Amount then intAmount = entity.Amount end
		if ply:AddItem(entity.Item, intAmount) then entity:Remove() end
		entity:Remove()
	end
	return true
end