GM.MapEntities = {}
GM.MapEntities.NPCSpawnPoints = {}
GM.MapEntities.WorldProps = {}

function GM:CreateSpawnPoint(vecPosition, strNPC, intLevel, intSpawnTime)
	table.insert(GAMEMODE.MapEntities.NPCSpawnPoints, {})
	local intNumSpawns = #GAMEMODE.MapEntities.NPCSpawnPoints
	GAMEMODE:UpdateSpawnPoint(intNumSpawns, vecPosition, strNPC, intLevel, intSpawnTime)
end
function GM:RemoveSpawnPoint(intKey)
	local tblSpawnPoint = GAMEMODE.MapEntities.NPCSpawnPoints[intKey]
	if tblSpawnPoint then
		if tblSpawnPoint.Monster then tblSpawnPoint.Monster:Remove() end
		table.remove(GAMEMODE.MapEntities.NPCSpawnPoints, intKey)
	end
	if SERVER && SinglePlayer() && player.GetByID(1) && player.GetByID(1):IsValid() then
		SendUsrMsg("UD_RemoveSpawnPoint", player.GetByID(1), {intKey})
	end
end
function GM:UpdateSpawnPoint(intKey, vecPosition, strNPC, intLevel, intSpawnTime)
	local tblNPCTable = NPCTable(strNPC)
	local tblToUpdateSpawn = GAMEMODE.MapEntities.NPCSpawnPoints[intKey]
	if tblToUpdateSpawn then
		tblToUpdateSpawn.Postion = vecPosition or tblToUpdateSpawn.Postion or Vector(0, 0, 0)
		tblToUpdateSpawn.NPC = strNPC or tblToUpdateSpawn.NPC or "zombie"
		tblToUpdateSpawn.Level = intLevel or tblToUpdateSpawn.Level or 5
		tblToUpdateSpawn.SpawnTime = intSpawnTime or tblToUpdateSpawn.SpawnTime or 0
		if SERVER && SinglePlayer() && player.GetByID(1) && player.GetByID(1):IsValid() then
			SendUsrMsg("UD_UpdateSpawnPoint", player.GetByID(1), {intKey, tblToUpdateSpawn.Postion,	tblToUpdateSpawn.NPC, tblToUpdateSpawn.Level, tblToUpdateSpawn.SpawnTime})
		end
	else
		GAMEMODE:CreateSpawnPoint(vecPosition, strNPC, intLevel, intSpawnTime)
	end
end

function GM:CreateWorldProp(strModel, vecPostion, angAngle, entEntity, Offset)
	if SERVER then
		local tblNewObject = {}
		tblNewObject.SpawnProp = function()
			local entNewProp = ents.Create("prop_physics")
			if strModel && !util.IsValidProp(strModel) then
				entNewProp:Remove()
				entNewProp = ents.Create("prop_dynamic")
			end
			tblNewObject.Entity = entNewProp
			table.insert(GAMEMODE.MapEntities.WorldProps, tblNewObject)
			GAMEMODE:UpdateWorldProp(#GAMEMODE.MapEntities.WorldProps, strModel, Offset, vecPostion, angAngle, entNewProp)
			entNewProp:SetSkin(math.random(0, entNewProp:SkinCount()))
			entNewProp:Spawn()
		end
		tblNewObject.SpawnProp()
	elseif CLIENT then
		table.insert(GAMEMODE.MapEntities.WorldProps, {Entity = entEntity})
		GAMEMODE:UpdateWorldProp(#GAMEMODE.MapEntities.WorldProps, strModel, Offset, vecPostion, angAngle, entEntity)
	end
end
function GM:RemoveWorldProp(intKey)
	local tblWorldProp = GAMEMODE.MapEntities.WorldProps[intKey]
	if tblWorldProp then
		if tblWorldProp.Entity && tblWorldProp.Entity:IsValid() then tblWorldProp.Entity:Remove() end
		table.remove(GAMEMODE.MapEntities.WorldProps, intKey)
	end
	if SERVER && SinglePlayer() && player.GetByID(1) && player.GetByID(1):IsValid() then
		SendUsrMsg("UD_RemoveWorldProp", player.GetByID(1), {intKey})
	end
end
function GM:UpdateWorldProp(intKey, strModel, Offset, vecPosition, angAngle, entEntity)
	local tblToUpdateProp = GAMEMODE.MapEntities.WorldProps[intKey]
	if tblToUpdateProp && tblToUpdateProp.Entity && tblToUpdateProp.Entity:IsValid() then
		local entProp = tblToUpdateProp.Entity
		if SERVER then
			entProp:SetModel(strModel or entProp:GetModel() or "models/props_junk/garbage_metalcan001a.mdl")
			entProp:SetPos(vecPosition or entProp:GetPos() + Vector(0,0,Offset) )
			entProp:SetAngles(angAngle or entProp:GetAngles())
			entProp:PhysicsInit(SOLID_VPHYSICS)
			entProp:SetMoveType(MOVETYPE_NONE)
			entProp:SetKeyValue("spawnflags", 8)
			entProp.Offset = Offset
			entProp.ObjectKey = intKey
			if entProp:GetPhysicsObject():IsValid() then entProp:GetPhysicsObject():Sleep() end
			if SinglePlayer() && player.GetByID(1) && player.GetByID(1):IsValid() then
				SendUsrMsg("UD_UpdateWorldProp", player.GetByID(1), {intKey, Offset, entProp:GetModel(), entProp:GetPos(), entProp:GetAngles(), entProp})
			end
		end
		tblToUpdateProp.Model = entProp:GetModel()
		tblToUpdateProp.Postion = entProp:GetPos()
		tblToUpdateProp.Angle = entProp:GetAngles()
	else
		GAMEMODE:CreateWorldProp(strModel, Offset, vecPosition, angAngle, entEntity)
	end
end

if SERVER then
	function GM:LoadMapObjects()
		local strFileName = "UnderDone/Maps/" .. game.GetMap() .. ".txt"
		if !file.Exists(strFileName) then return end
		local tblDecodedTable = glon.decode(file.Read(strFileName))
		for _, SpawnPoint in pairs(tblDecodedTable.NPCSpawnPoints or {}) do
			GAMEMODE:CreateSpawnPoint(SpawnPoint.Postion, SpawnPoint.NPC, SpawnPoint.Level, SpawnPoint.SpawnTime)
		end
		for k, WorldProp in pairs(tblDecodedTable.WorldProps or {}) do
			timer.Simple(0.1 * k, function() GAMEMODE:CreateWorldProp(WorldProp.Model, WorldProp.Postion, WorldProp.Angle ) end)
		end
	end
	hook.Add("Initialize", "LoadMapObjects", function() GAMEMODE:LoadMapObjects() end)
	function GM:SaveMapObjects()
		local strFileName = "UnderDone/Maps/" .. game.GetMap() .. ".txt"
		local tblSaveTable = table.Copy(GAMEMODE.MapEntities)
		for _, SpawnPoint in pairs(tblSaveTable.NPCSpawnPoints or {}) do
			SpawnPoint.Monster = nil
			SpawnPoint.NextSpawn = nil
		end
		for _, WorldProp in pairs(tblSaveTable.WorldProps or {}) do
			WorldProp.Entity = nil
		end
		file.Write(strFileName, glon.encode(tblSaveTable))
	end
	
	function GM:SpawnMapEntities()
		for _, Spawn in pairs(GAMEMODE.MapEntities.NPCSpawnPoints) do
			if !Spawn.Monster or !Spawn.Monster:IsValid() then
				if !Spawn.NextSpawn then Spawn.NextSpawn = CurTime() + Spawn.SpawnTime end
				if Spawn.SpawnTime > 0 && CurTime() >= Spawn.NextSpawn then
					Spawn.Monster = GAMEMODE:CreateNPC(Spawn.NPC, Spawn)
					Spawn.NextSpawn = nil
				end
			end
		end
	end
	hook.Add("Tick", "SpawnMapEntities", function() GAMEMODE:SpawnMapEntities() end)

	function GM:CreateNPC(strNPC, tblSpawnPoint)
		local tblNPCTable = NPCTable(strNPC)
		local entNewMonster = ents.Create(tblNPCTable.SpawnName)
		if tblNPCTable.Model then
			entNewMonster:SetModel(tblNPCTable.Model)
		end
		entNewMonster:SetPos(tblSpawnPoint.Postion)
		entNewMonster:SetAngles(tblSpawnPoint.Angle or Angle(0, 90, 0))
		entNewMonster:Spawn()
		entNewMonster.Race = tblNPCTable.Race
		entNewMonster.Invincible = tblNPCTable.Invincible
		entNewMonster.Shop = type(tblNPCTable.Shop) == "table"
		local intTotalFlags = 1 + 8192
		if tblNPCTable.Idle then
			entNewMonster:SetNPCState(NPC_STATE_IDLE)
			intTotalFlags = intTotalFlags + 16
		end
		entNewMonster:SetKeyValue("spawnflags", intTotalFlags)
		if tblNPCTable.Weapon then
			entNewMonster:Give(tblNPCTable.Weapon)
		end
		for _, ent in pairs(ents.GetAll()) do
			if ent && ent:IsValid() && (ent:IsNPC() or ent:IsPlayer()) && ent.Race then
				if ent.Race == tblNPCTable.Race then
					entNewMonster:AddEntityRelationship(ent, GAMEMODE.RelationLike, 99)
					if ent:IsNPC() then ent:AddEntityRelationship(entNewMonster, GAMEMODE.RelationLike, 99) end
				else
					if !ent.Invincible then entNewMonster:AddEntityRelationship(ent, GAMEMODE.RelationHate, 99) end
					if !entNewMonster.Invincible && ent:IsNPC() then ent:AddEntityRelationship(entNewMonster, GAMEMODE.RelationHate, 99)  end
				end
			end
		end
		entNewMonster:SetNWString("npc", tblNPCTable.Name)
		local intLevel = math.Clamp(tblSpawnPoint.Level + math.random(-2, 2), 1, tblSpawnPoint.Level + 2)
		entNewMonster:SetNWInt("level", intLevel)
		local intHealth = tblSpawnPoint.Level * tblNPCTable.HealthPerLevel
		entNewMonster:SetMaxHealth(intHealth)
		entNewMonster:SetHealth(intHealth)
		entNewMonster:SetNWInt("MaxHealth", intHealth)
		entNewMonster:SetNWInt("Health", intHealth)
		return entNewMonster
	end
	
	if SinglePlayer() then
		function OnPlayerSpawnMapEditor(ply)
			for key, spawnPoint in pairs(GAMEMODE.MapEntities.NPCSpawnPoints) do
				GAMEMODE:UpdateSpawnPoint(key)
			end
			for key, worldprop in pairs(GAMEMODE.MapEntities.WorldProps) do
				GAMEMODE:UpdateWorldProp(key)
			end
		end
		hook.Add("PlayerSpawn", "OnPlayerSpawnMapEditor", OnPlayerSpawnMapEditor)
		
		concommand.Add("UD_Dev_EditMap_CreateSpawnPoint", function(ply, command, args)
			if !ply:IsAdmin() or !ply:IsPlayer() then return end
			GAMEMODE:CreateSpawnPoint(ply:GetEyeTraceNoCursor().HitPos)
		end)
		concommand.Add("UD_Dev_EditMap_RemoveSpawnPoint", function(ply, command, args)
			if !ply:IsAdmin() or !ply:IsPlayer() then return end
			GAMEMODE:RemoveSpawnPoint(tonumber(args[1]))
		end)
		concommand.Add("UD_Dev_EditMap_UpdateSpawnPoint", function(ply, command, args)
			if !ply:IsAdmin() or !ply:IsPlayer() then return end
			if args[1] && GAMEMODE.MapEntities.NPCSpawnPoints[tonumber(args[1])] then
				GAMEMODE:UpdateSpawnPoint(tonumber(args[1]), nil, args[2], tonumber(args[3]), tonumber(args[4])))
			end
		end)
		
		concommand.Add("UD_Dev_EditMap_CreateWorldProp", function(ply, command, args)
			if !ply:IsAdmin() or !ply:IsPlayer() then return end
			GAMEMODE:CreateWorldProp(nil, ply:GetEyeTraceNoCursor().HitPos)
		end)
		concommand.Add("UD_Dev_EditMap_RemoveWorldProp", function(ply, command, args)
			if !ply:IsAdmin() or !ply:IsPlayer() then return end
			GAMEMODE:RemoveWorldProp(tonumber(args[1]))
		end)
		concommand.Add("UD_Dev_EditMap_UpdateWorldProp", function(ply, command, args)
			if !ply:IsAdmin() or !ply:IsPlayer() then return end
			if args[1] && GAMEMODE.MapEntities.WorldProps[tonumber(args[1])] then
				GAMEMODE:UpdateWorldProp(tonumber(args[1]), args[2], tonumber(args[3]))
			end
		end)
		
		concommand.Add("UD_Dev_EditMap_SaveMap", function(ply, command, args)
			if !ply:IsAdmin() or !ply:IsPlayer() then return end
			GAMEMODE:SaveMapObjects()
		end)
	end
end

if CLIENT then
	if SinglePlayer() then
		usermessage.Hook("UD_UpdateSpawnPoint", function(usrMsg)
			GAMEMODE:UpdateSpawnPoint(usrMsg:ReadLong(), usrMsg:ReadVector(), usrMsg:ReadString(), usrMsg:ReadLong(), usrMsg:ReadLong())
			GAMEMODE.MapEditor.UpatePanel()
		end)
		usermessage.Hook("UD_RemoveSpawnPoint", function(usrMsg)
			GAMEMODE:RemoveSpawnPoint(usrMsg:ReadLong())
			GAMEMODE.MapEditor.UpatePanel()
		end)
		usermessage.Hook("UD_UpdateWorldProp", function(usrMsg)
			GAMEMODE:UpdateWorldProp(usrMsg:ReadLong(), usrMsg:ReadString(), usrMsg:ReadVector(), usrMsg:ReadAngle(), usrMsg:ReadEntity())
			GAMEMODE.MapEditor.UpatePanel()
		end)
		usermessage.Hook("UD_RemoveWorldProp", function(usrMsg)
			GAMEMODE:RemoveWorldProp(usrMsg:ReadLong())
			GAMEMODE.MapEditor.UpatePanel()
		end)
	end
end