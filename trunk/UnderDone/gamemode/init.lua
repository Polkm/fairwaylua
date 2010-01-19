require("glon")
AddCSLuaFile("shared.lua")
AddCSLuaFile("sh_resource.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
include("itemdata/sh_items_base.lua")
include("sh_resource.lua")
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

function UseKeyPressed(ply, key)
	local vecHitPos = ply:GetEyeTrace().HitPos
	local entLookEnt = nil
	for _, ent in pairs(ents.FindInSphere(vecHitPos, 20) or {}) do
		if (ent.Item or ent.Shop) && ent:GetClass() != "weapon_primaryweapon" && ent:GetPos():Distance(ply:GetPos()) < 70 then
			if !entLookEnt or ent:GetPos():Distance(vecHitPos) < entLookEnt:GetPos():Distance(vecHitPos) then
				entLookEnt = ent
			end
		end
	end
	if !entLookEnt or !entLookEnt:IsValid() then return end
	if entLookEnt.Item then
		local intAmount = 1
		if entLookEnt.Amount then intAmount = entLookEnt.Amount end
		if ply:AddItem(entLookEnt.Item, intAmount) then
			if entLookEnt:GetParent() && entLookEnt:GetParent():IsValid() then
				entLookEnt:GetParent():Remove()
			end
			entLookEnt:Remove()
		end
	end
	if entLookEnt.Shop then
		ply.UseTarget = entLookEnt
		ply:ConCommand("UD_OpenShopMenu " .. entLookEnt.Shop)
	end
	if entLookEnt.Pile then
		local intAmount = 1
		for _, Item in pairs(GAMEMODE.Pile) do
			if v.Amount then intAmount = v.Amount end
			if ply:AddItem(v, intAmount) then
				entLookEnt:Remove()
			end
		end
	end
end
hook.Add("KeyPress", "UseKeyPressed", function(ply, key) if key == IN_USE then UseKeyPressed(ply, key) end end)

function GM:PlayerUse(plyPlayer, entEntity)
	return true
end

function OnPropBreak(entBreaker, entProp)
	if entBreaker:IsValid() and entBreaker:IsPlayer() and entProp:IsValid() then
		for i = 1, math.random(1, 3) do
			local entLoot = CreateWorldItem("wood")
			entLoot:SetPos(entProp:GetPos())
			entLoot:GetPhysicsObject():ApplyForceCenter(Vector(math.random(-100, 100), math.random(-100, 100), math.random(350, 400)))
		end
		if entProp.ObjectKey && GAMEMODE.MapEntities.WorldProps[entProp.ObjectKey] then
			local tblWorldObject = GAMEMODE.MapEntities.WorldProps[entProp.ObjectKey]
			timer.Simple(math.random(45, 75), function()
				tblWorldObject.SpawnProp()
			end)
		end
	end
end
hook.Add("PropBreak", "OnPropBreak", OnPropBreak)

--[[function GM:ScalePlayerDamage(ply,hitgroup,dmginfo)
	local inrange = ents.FindInBox( Vector(558.787659, 289.451447, -72.497879), Vector(949.335632, -1113.920288, 98.019356))
	if (table.HasValue( inrange, ply )) then
		dmginfo:SetDamage(0)
	end
end]]
 