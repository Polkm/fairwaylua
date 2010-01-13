GM.MapEntities = {}
GM.MapEntities.NPCSpawnPoints = {}

function GM:CreateSpawnPoint(vecPosition, strNPC, intLevel, intSpawnTime)
	table.insert(GAMEMODE.MapEntities.NPCSpawnPoints, {})
	local intNumSpawns = #GAMEMODE.MapEntities.NPCSpawnPoints
	GAMEMODE:UpdateSpawnPoint(intNumSpawns, vecPosition, strNPC, intLevel, intSpawnTime)
end
function GM:UpdateSpawnPoint(intKey, vecPosition, strNPC, intLevel, intSpawnTime)
	local tblToUpdateSpawn = GAMEMODE.MapEntities.NPCSpawnPoints[intKey]
	if tblToUpdateSpawn then
		tblToUpdateSpawn.Postion = vecPosition or tblToUpdateSpawn.Postion or Vector(0, 0, 0)
		tblToUpdateSpawn.NPC = strNPC or tblToUpdateSpawn.NPC or "zombie"
		tblToUpdateSpawn.Level = intLevel or tblToUpdateSpawn.Level or 5
		tblToUpdateSpawn.SpawnTime = intSpawnTime or tblToUpdateSpawn.SpawnTime or 10
		if SERVER && SinglePlayer() then
			SendUsrMsg("UD_UpdateMapObjects", player.GetByID(1), {intKey, tblToUpdateSpawn.Postion,	tblToUpdateSpawn.NPC, tblToUpdateSpawn.Level, tblToUpdateSpawn.SpawnTime})
		end
	else
		GAMEMODE:CreateSpawnPoint(vecPosition, strNPC, intLevel, intSpawnTime)
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
	end
	hook.Add("Initialize", "LoadMapObjects", function() GAMEMODE:LoadMapObjects() end)
	function GM:SaveMapObjects()
		local strFileName = "UnderDone/Maps/" .. game.GetMap() .. ".txt"
		local tblSaveTable = table.Copy(GAMEMODE.MapEntities)
		for _, SpawnPoint in pairs(tblSaveTable.NPCSpawnPoints or {}) do
			SpawnPoint.Monster = nil
			SpawnPoint.NextSpawn = nil
		end
		file.Write(strFileName, glon.encode(tblSaveTable))
	end
	
	function GM:SpawnMapEntities()
		for _, Spawn in pairs(GAMEMODE.MapEntities.NPCSpawnPoints) do
			if !Spawn.Monster or !Spawn.Monster:IsValid() then
				if !Spawn.NextSpawn then Spawn.NextSpawn = CurTime() + Spawn.SpawnTime end
				if CurTime() >= Spawn.NextSpawn then
					Spawn.Monster = GAMEMODE:CreateNPC(Spawn.NPC, Spawn)
					Spawn.NextSpawn = nil
				end
			end
		end
		for _, ply in pairs(player.GetAll()) do
			if ply && ply:IsValid() then
				GAMEMODE.Player = ply
			end
		end
		for _, ent in pairs(ents.GetAll()) do
			if ent && ent:IsValid() then
				if ent.Relation then
					if GAMEMODE.Player:GetPos():Distance(ent:GetPos()) > GM.MonsterViewDistance then
						ent:AddEntityRelationship(GAMEMODE.Player, ent.Relation, 99)
						ent:SetNPCState( NPC_STATE_IDLE )
					end
				end
			end
		end
	end
	hook.Add("Tick", "SpawnMapEntities", function() GAMEMODE:SpawnMapEntities() end)

	function GM:CreateNPC(strNPC, tblSpawnPoint)
		local tblNPCTable = NPCTable(strNPC)
		local entNewMonster = ents.Create(tblNPCTable.SpawnName)
		entNewMonster:SetPos(tblSpawnPoint.Postion)
		entNewMonster:Spawn()
		entNewMonster.Relation = tblNPCTable.Relation
		for _, ply in pairs(player.GetAll()) do
			entNewMonster:AddEntityRelationship(ply, tblSpawnPoint.Relation, 99)
		end
		if tblNPCTable.Relation == GAMEMODE.RelationHate then
			GAMEMODE.NPCEnemy = entNewMonster
			if GAMEMODE.NPCAlly then
				GAMEMODE.NPCAlly:AddEntityRelationship(entNewMonster, GAMEMODE.RelationHate, 99)
				entNewMonster:AddEntityRelationship(GAMEMODE.NPCAlly, GAMEMODE.RelationHate, 99)
			end
		end
		if tblNPCTable.Relation == GAMEMODE.RelationLike then
			GAMEMODE.NPCAlly = entNewMonster
			if GAMEMODE.NPCEnemy then
				GAMEMODE.NPCEnemy:AddEntityRelationship(entNewMonster, GAMEMODE.RelationHate, 99)
				entNewMonster:AddEntityRelationship(GAMEMODE.NPCEnemy, GAMEMODE.RelationHate, 99)
			end
		end
		if tblNPCTable.Race == "combine" then
			entNewMonster:Give("weapon_crowbar")
		end
		if tblNPCTable.Race == tblNPCTable.Race then
			entNewMonster:AddEntityRelationship(entNewMonster, GAMEMODE.RelationLike, 99)	
		end
		entNewMonster:SetNWInt("level", tblSpawnPoint.Level)
		local intHealth = tblSpawnPoint.Level * tblNPCTable.HealthPerLevel
		entNewMonster:SetMaxHealth(intHealth)
		entNewMonster:SetHealth(intHealth)
		entNewMonster:SetNWInt("Health", intHealth)
		entNewMonster:SetNWInt("MaxHealth", intHealth)
		return entNewMonster
	end
	
	if SinglePlayer() then
		function OnPlayerSpawnMapEditor(ply)
			for key, spawnPoint in pairs(GAMEMODE.MapEntities.NPCSpawnPoints) do
				GAMEMODE:UpdateSpawnPoint(key)
			end
		end
		hook.Add("PlayerSpawn", "OnPlayerSpawnMapEditor", OnPlayerSpawnMapEditor)
		
		concommand.Add("UD_Dev_EditMap_CreateSpawnPoint", function(ply, command, args)
			if !ply:IsAdmin() or !ply:IsPlayer() then return end
			GAMEMODE:CreateSpawnPoint(ply:GetEyeTraceNoCursor().HitPos)
		end)
		concommand.Add("UD_Dev_EditMap_UpdateSpawnPoint", function(ply, command, args)
			if !ply:IsAdmin() or !ply:IsPlayer() then return end
			if args[1] && GAMEMODE.MapEntities.NPCSpawnPoints[tonumber(args[1])] then
				GAMEMODE:UpdateSpawnPoint(tonumber(args[1]), nil, args[2], tonumber(args[3]), tonumber(args[4]))
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
		usermessage.Hook("UD_UpdateMapObjects", function(usrMsg)
			GAMEMODE:UpdateSpawnPoint(usrMsg:ReadLong(), usrMsg:ReadVector(), usrMsg:ReadString(), usrMsg:ReadLong(), usrMsg:ReadLong())
		end)
	end
end