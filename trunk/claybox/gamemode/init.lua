require("datastream")
require("glon")
AddCSLuaFile("shared.lua")
include("shared.lua")

function GM:PlayerLoadout(ply)
	ply:Give("weapon_physgun")
	ply:Give("weapon_physcannon")
	ply:Give("gmod_tool")
	ply:SelectWeapon("weapon_physgun")
end

function SpawnObject(player, command, arguments)
	if arguments[1] == nil then return end
	if !util.IsValidModel(arguments[1]) then return end
	
	local strModel = arguments[1]
	local iSkin = arguments[2] or 0
	local tblTrace = util.TraceLine(util.GetPlayerTrace(player))
	
	local entProp
	if util.IsValidProp(strModel) then 
		entProp = ents.Create("prop_physics")
		DoPropSpawnedEffect(entProp)
		undo.Create("Prop")
		undo.SetPlayer(player)
		undo.AddEntity(entProp)
		undo.Finish("Prop (" .. tostring(strModel) .. ")")
		player:AddCleanup("props", entProp)
		player:SendLua("achievements.SpawnedProp()")
	elseif util.IsValidRagdoll(strModel) then 
		entProp = ents.Create("prop_ragdoll")
		undo.Create("Ragdoll")
		undo.SetPlayer(player)
		undo.AddEntity(entProp)
		undo.Finish("Ragdoll (" .. tostring(model) .. ")")
		player:AddCleanup("ragdolls", entProp)
		player:SendLua("achievements.SpawnedRagdoll()")
	else
		entProp = ents.Create("prop_effect")
		undo.Create("Effect")
		undo.SetPlayer(player)
		undo.AddEntity(entProp)
		undo.Finish("Effect (" .. tostring(model) .. ")")
		player:AddCleanup("effects", entProp)
	end
	
	entProp:SetModel(strModel)
	entProp:SetPos(tblTrace.HitPos)
	if entProp:GetClass() == "prop_ragdoll" then
		entProp:SetAngles(Angle(entProp:GetAngles().p - 90, entProp.y, entProp.r))
		tblTrace.HitPos = tblTrace.HitPos --Wut?
	end
	entProp:Spawn()
	
	local vecFlushPoint = tblTrace.HitPos - tblTrace.HitNormal * 512 --Find a point that is definitely out of the object in the direction of the floor
	vecFlushPoint = entProp:NearestPoint(vecFlushPoint) --Find the nearest point inside the object to that point
	vecFlushPoint = entProp:GetPos() - vecFlushPoint --Get the difference
	vecFlushPoint = tblTrace.HitPos + vecFlushPoint --Add it to our target pos
	if entProp:GetClass() != "prop_ragdoll" then
		entProp:SetPos(vecFlushPoint)
	else
		--With ragdolls we need to move each physobject
		local vecOffset = vecFlushPoint - entProp:GetPos()
		for i = 0, entProp:GetPhysicsObjectCount() - 1 do
			local phys = entProp:GetPhysicsObjectNum(i)
			phys:SetPos(phys:GetPos() + vecOffset)
		end
	end
end
concommand.Add("silt_spawnobject", SpawnObject)

function GM:CanTool(ply, trace, mode)
	--The jeep spazzes out when applying something
	--todo: Find out what it's reacting badly to and change it in _physprops
	if mode == "physprop" && trace.Entity:IsValid() && trace.Entity:GetClass() == "prop_vehicle_jeep" then
		return false
	end
	
	--If we have a toolsallowed table, check to make sure the toolmode is in it
	if trace.Entity.m_tblToolsAllowed then
		local vFound = false	
		for k, v in pairs(trace.Entity.m_tblToolsAllowed) do
			if mode == v then vFound = true end
		end
		if !vFound then return false end
	end
	
	--Give the entity a chance to decide
	if trace.Entity.CanTool then
		return trace.Entity:CanTool(ply, trace, mode)
	end
	
	return true
end


--[[
propIndex = {}
propIndexTimer = CurTime()

function GM:Initialize()
	if !file.Exists("siltbox/propIndex.txt") then
		propIndexTimer = CurTime()
		BuildPropIndex(propIndex, "models/")
	else
		local h_d, h_e, h_f = debug.gethook()
		debug.sethook()
			propIndex = glon.decode(file.Read("siltbox/propIndex.txt"))
		--debug.sethook(h_d, h_e, h_f)
		--propIndexTimer = CurTime()
		--BuildPropIndex(propIndex, "models/")
	end
	timer.Simple(10, function() 
		local h_a, h_b, h_c = debug.gethook()
		debug.sethook()
			file.Write("siltbox/propIndex.txt", glon.encode(propIndex)) 
		--debug.sethook(h_a, h_b, h_c)
	end)
end

function BuildPropIndex(curTable, dir)
	PrintTable(file.Find("../" .. dir .. "*"))
	local files = file.Find("../" .. dir .. "*")
	for k, v in pairs(files) do
		if !table.HasValue(curTable, (dir .. v):lower()) then
			if v:sub(-4, -1) == ".mdl" then
				if (!v:lower():find("_gestures") && 
					!v:lower():find("_anim") && 
					!v:lower():find("_postures") && 
					!v:lower():find("_intro") && 
					!v:lower():find("_gst") && 
					!v:lower():find("_pst") && 
					!v:lower():find("_shd") && 
					!v:lower():find("_ss") && 
					!v:lower():find("cs_fix") &&
					!v:lower():find("_anm")) then
					table.insert(curTable, 0, (dir .. v):lower())
				end
			elseif v:sub(-4, -4) != '.' then
				propIndexTimer = propIndexTimer + 0.001
				timer.Simple(propIndexTimer - CurTime(), BuildPropIndex, curTable, (dir..v.."/"):lower())
			end
		end
	end
end

function SpawnObject(player, command, arguments)
	if (arguments[1] == nil) then return end
	if (!util.IsValidModel(arguments[1])) then return end
	
	local strModel = arguments[1]
	local iSkin = arguments[2] or 0

	if util.IsValidProp(strModel) then 
		local prop = ents.Create("prop_physics")
		prop:SetModel(strModel)
		local pos = util.TraceLine(util.GetPlayerTrace(player)).HitPos
		pos.Z = pos.Z + (prop:OBBMaxs().Z/ 2)
		prop:SetPos(pos)
		prop:Spawn()
		return
	end
	
	if util.IsValidRagdoll(strModel) then 
		local Ent = ents.Create("prop_ragdoll")
		Ent:SetModel(strModel)
		local pos = util.TraceLine(util.GetPlayerTrace(player)).HitPos
		pos.Z = pos.Z + (Ent:OBBMaxs().Z/ 2)
		Ent:SetPos(pos)
		Ent:Spawn()
		return
	end
end
concommand.Add("silt_spawnobject", SpawnObject)

]]