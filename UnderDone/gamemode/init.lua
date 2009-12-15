require("glon")
AddCSLuaFile("shared.lua")
AddCSLuaFile("sh_camera.lua")
AddCSLuaFile("sh_resource.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_mainmenu.lua")
include("shared.lua")
include("sh_camera.lua")
include("sh_resource.lua")
include("player_ex.lua")
include("commands.lua")
include("inventory.lua")
include("savingloading.lua")

function GM:PlayerInitialSpawn(ply)
	ply:KillSilent()
end

function GM:PlayerAuthed(ply, SteamID, UniqueID)
	ply:LoadGame()
end

function GM:PlayerSpawn(ply)
	--[[
	if ply.Ragdoll then
		for k,v in pairs(ply.Ragdoll.Inventory) do
			TransferItem(ply, ply.Ragdoll, k, v)
		end
	end
	local alowence = 50
	AddItemToInv(ply, "money", alowence)
	ply:ConCommand("UD_AddNotification You got an alowance of " .. tostring(alowence) .. " Dollars") 
	]]
	hook.Call("PlayerLoadout", GAMEMODE, ply)
	hook.Call("PlayerSetModel", GAMEMODE, ply)
end

function GM:PlayerLoadout(ply)
	if ply.Loadout then
		for weapon, hasWeapon in pairs(ply.Loadout) do
			if hasWeapon then ply:Give(weapon) end
		end
	end
	return true
end

function GM:PlayerUse(ply, entity)
	if entity.Item then
		local intAmount = 1
		if entity.Amount then intAmount = entity.Amount end
		if AddItemToInv(ply, entity.Item, intAmount) then entity:Remove() end
	end
	return true
end

function GM:CanHearPlayersVoice(plyFirst, plySecond)
	if !IsValid(plySecond) || !IsValid(plyFirst) then return false end --InValid
	local intChatDistance = 1000
	if plyFirst:GetPos():Distance(plySecond:GetPos()) >= intChatDistance then return false end --Too Far
	return true --All good :)
end

function GM:PlayerCanSeePlayersChat(strText, bTeamOnly, pListener, pSpeaker)
	if !IsValid(pSpeaker) || !IsValid(pListener) then return false end --InValid
	local tblText = string.ToTable(strText)
	local intChatDistance = 700
	if tblText[#tblText] == "!" && #tblText > 1 then intChatDistance = 5000 end
	if pListener:GetPos():Distance(pSpeaker:GetPos()) >= intChatDistance then return false end --Too Far
	return true --All good :)
end