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
		tblToUpdateSpawn.SpawnTime = intSpawnTime or tblToUpdateSpawn.SpawnTime or 0
		if SERVER && SinglePlayer() && player.GetByID(1) && player.GetByID(1):IsValid() then
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
		entNewMonster:SetPos(tblSpawnPoint.Postion)
		entNewMonster:Spawn()
		entNewMonster.Race = tblNPCTable.Race
		if tblNPCTable.Race == "combine" then
			entNewMonster:Give("weapon_crowbar")
		end
		for _, ent in pairs(ents.GetAll()) do
			if ent && ent:IsValid() && ent.Race then
				if ent.Race == tblNPCTable.Race then
					entNewMonster:AddEntityRelationship(ent, GAMEMODE.RelationLike, 99)
				else
					entNewMonster:AddEntityRelationship(ent, GAMEMODE.RelationHate, 99)
				end
			end
		end
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
			GAMEMODE.MapEditor.UpatePanel()
		end)
	end
end