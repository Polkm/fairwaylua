AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
GM.PlayerSpawnTime = {}

WeaponsManifest = {}
NodesManifest = {}
EntsManifest = {}

function GM:Initialize()
	----------------
	WeaponsManifest = weapons.GetList()
	for k, Weapon in pairs(WeaponsManifest) do
		if string.find(Weapon.ClassName, "base") then
			table.remove(WeaponsManifest, k)
		elseif Weapon.Spawnable && Weapon.Spawnable == false then
			table.remove(WeaponsManifest, k)
		elseif !Weapon.Spawnable then
			Weapon.Spawnable = true
		end
	end
	----------------
	EntsManifest = {}
	for k, Ent in pairs(scripted_ents.GetList()) do
		if Ent.t.Spawnable && Ent.t.Spawnable == true then
			table.insert(EntsManifest, Ent)
		end
	end
	----------------
	timer.Simple(1, function() AfterLoad() end)
	timer.Simple(10, function() SpawnARandomNPC() end)
	--timer.Simple(5, function() SpawnARandomEnt() end)
end

function AfterLoad()
	NodesManifest = {}
	table.Add(NodesManifest, ents.FindByClass("path_corner"))
	table.Add(NodesManifest, ents.FindByClass("ai_hint"))
	--table.Add(NodesManifest, ents.FindByClass("info_node"))
end

function SwitchWeapon(plyTarget, strWeapon)
	plyTarget:SelectWeapon(strWeapon)
end
concommand.Add("FS_SwitchWep", function(ply, command, args) SwitchWeapon(ply, tostring(args[1])) end)

function GM:PlayerLoadout(ply)
	GiveRandomGun(ply)
	GiveRandomGun(ply)
	local entity = ents.Create("prop_dynamic")
	entity:SetModel("models/error.mdl")
	entity:Spawn()
	entity:SetAngles(ply:GetAngles())
	entity:SetMoveType(MOVETYPE_NONE)
	entity:SetParent(ply)
	entity:SetPos(ply:GetPos())
	entity:SetRenderMode(RENDERMODE_NONE)
	entity:SetSolid(SOLID_NONE)
	ply:SetViewEntity(entity)
end

function GiveRandomGun(ply)
	if !ply.LastGun then ply.LastGun = "" end
	local Weapon = WeaponsManifest[math.random(1, #WeaponsManifest)]
	if ply.LastGun != Weapon then
		ply:Give(Weapon.ClassName)
		ply:GiveAmmo(120, Weapon.Primary.Ammo)
		ply.LastGun = Weapon
	else
		GiveRandomGun(ply) return
	end
end

function SpawnARandomEnt()
	local randomNode = NodesManifest[math.random(1, #NodesManifest)]
	local ent = ents.Create(EntsManifest[math.random(1, #EntsManifest)].t.ClassName)
	ent:SetPos(randomNode:GetPos())
	ent:Spawn()
	ent:GetPhysicsObject():ApplyForceCenter(Vector(math.random(1, 50), math.random(1, 50), 200))
	timer.Simple(5, function() SpawnARandomEnt() end)
end

function SpawnARandomNPC()
	local randomNode = NodesManifest[math.random(1, #NodesManifest)]
	local zombie = ents.Create("npc_zombie")
	zombie:SetPos(randomNode:GetPos())
	local doesDrop = 0
	if math.random(1, 50) == 1 then doesDrop = 8 end
	zombie:SetKeyValue("spawnflags",tostring(512 + doesDrop))
	zombie:Spawn()
	timer.Simple(10, function() SpawnARandomNPC() end)
end
