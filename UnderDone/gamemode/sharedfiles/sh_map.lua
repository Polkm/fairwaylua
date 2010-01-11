if SERVER then
	GM.MapEntities = {}
	GM.MapEntities.NPCSpawnPoints = {}
	GM.MapEntities.NPCSpawnPoints[1] = {}
	GM.MapEntities.NPCSpawnPoints[1].NPC = "zombie"
	GM.MapEntities.NPCSpawnPoints[1].SpawnPoint = Vector(819, 61, 141)
	GM.MapEntities.NPCSpawnPoints[1].Level = 5
	GM.MapEntities.NPCSpawnPoints[1].SpawnTime = 10
	GM.MapEntities.NPCSpawnPoints[1].Feel = 3
	GM.MapEntities.NPCSpawnPoints[2] = {}
	GM.MapEntities.NPCSpawnPoints[2].NPC = "zombie"
	GM.MapEntities.NPCSpawnPoints[2].SpawnPoint = Vector(919, 101, 141)
	GM.MapEntities.NPCSpawnPoints[2].Level = 5
	GM.MapEntities.NPCSpawnPoints[2].SpawnTime = 10
	GM.MapEntities.NPCSpawnPoints[2].Feel = 1
	GM.MapEntities.NPCSpawnPoints[3] = {}
	GM.MapEntities.NPCSpawnPoints[3].NPC = "antlionguard"
	GM.MapEntities.NPCSpawnPoints[3].SpawnPoint = Vector(1374, 3917, 110)
	GM.MapEntities.NPCSpawnPoints[3].Level = 5
	GM.MapEntities.NPCSpawnPoints[3].SpawnTime = 10
	
	function GM:LoadMapObjects()
		local strFileName = "UnderDone/Maps/" .. game.GetMap() .. ".txt"
		if file.Exists(strFileName) then
			local tblDecodedTable = glon.decode(file.Read(strFileName))
			for _, SpawnPoint in pairs(tblDecodedTable.NPCSpawnPoints or {}) do
				local tblNewSpawnPoint = {}
				tblNewSpawnPoint.NPC = SpawnPoint.NPC
				tblNewSpawnPoint.SpawnPoint = SpawnPoint.SpawnPoint
				tblNewSpawnPoint.Level = SpawnPoint.Level
				tblNewSpawnPoint.SpawnTime = SpawnPoint.SpawnTime
				table.insert(GAMEMODE.MapEntities.NPCSpawnPoints, tblNewSpawnPoint)
			end
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
	end
	hook.Add("Tick", "SpawnMapEntities", function() GAMEMODE:SpawnMapEntities() end)

	function GM:CreateNPC(strNPC, tblSpawnPoint)
		local tblNPCTable = GAMEMODE.DataBase.NPCs[strNPC]
		local entNewMonster = ents.Create(tblNPCTable.SpawnName)
		entNewMonster:SetPos(tblSpawnPoint.SpawnPoint)
		entNewMonster:Spawn()
		for _, ply in pairs(player.GetAll()) do
			entNewMonster:AddEntityRelationship(ply,tblSpawnPoint.Feel, 99 )
		end
		if tblSpawnPoint.Feel == 1 then
			GAMEMODE.NPCEnemy = entNewMonster
			if GAMEMODE.NPCAlly then
				GAMEMODE.NPCAlly:AddEntityRelationship(entNewMonster,1, 99 )
				entNewMonster:AddEntityRelationship(GAMEMODE.NPCAlly,1, 99 )
			end
		end
		if tblSpawnPoint.Feel == 3 then
			GAMEMODE.NPCAlly = entNewMonster
			if GAMEMODE.NPCEnemy then
				GAMEMODE.NPCEnemy:AddEntityRelationship(entNewMonster,1, 99 )
				entNewMonster:AddEntityRelationship(GAMEMODE.NPCEnemy,1, 99 )
			end
		end
		entNewMonster:SetNWInt("level", tblSpawnPoint.Level)
		local intHealth = tblSpawnPoint.Level * tblNPCTable.HealthPerLevel
		entNewMonster:SetMaxHealth(intHealth)
		entNewMonster:SetHealth(intHealth)
		entNewMonster:SetNWInt("Health", intHealth)
		entNewMonster:SetNWInt("MaxHealth", intHealth)
		return entNewMonster
	end
	
	function GM:AdminPlaceNPCSpawPoint(plyAdmin, strNPCType, intLevel, intSpawnTime)
		local tblNewSpawnPoint = {}
		tblNewSpawnPoint.NPC = strNPCType or "zombie"
		tblNewSpawnPoint.SpawnPoint = plyAdmin:GetPos()
		tblNewSpawnPoint.Level = intLevel or 5
		tblNewSpawnPoint.SpawnTime = intSpawnTime or 10
		table.insert(GAMEMODE.MapEntities.NPCSpawnPoints, tblNewSpawnPoint)
	end
	concommand.Add("UUD_Dev_EditMap_PlaceNPCSpawnPoint", function(ply, command, args)
		if !ply:IsAdmin() or !ply:IsPlayer() then return end
		GAMEMODE:AdminPlaceNPCSpawPoint(ply)
	end)
	concommand.Add("UD_Dev_EditMap_SaveMap", function(ply, command, args)
		if !ply:IsAdmin() or !ply:IsPlayer() then return end
		GAMEMODE:SaveMapObjects()
	end)
end






