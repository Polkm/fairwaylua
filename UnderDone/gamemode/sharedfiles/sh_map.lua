local Hate = 1
local Fear = 2
local Like = 3
local Neutral = 4

if SERVER then
	GM.MapEntities = {}
	GM.MapEntities.NPCSpawnPoints = {}
	--[[GM.MapEntities.NPCSpawnPoints[1] = {}
	GM.MapEntities.NPCSpawnPoints[1].NPC = "zombie"
	GM.MapEntities.NPCSpawnPoints[1].Postion = Vector(819, 61, 141)
	GM.MapEntities.NPCSpawnPoints[1].Level = 5
	GM.MapEntities.NPCSpawnPoints[1].SpawnTime = 10
	GM.MapEntities.NPCSpawnPoints[2] = {}
	GM.MapEntities.NPCSpawnPoints[2].NPC = "zombie"
	GM.MapEntities.NPCSpawnPoints[2].Postion = Vector(919, 101, 141)
	GM.MapEntities.NPCSpawnPoints[2].Level = 5
	GM.MapEntities.NPCSpawnPoints[2].SpawnTime = 10
	GM.MapEntities.NPCSpawnPoints[3] = {}
	GM.MapEntities.NPCSpawnPoints[3].NPC = "antlionguard"
	GM.MapEntities.NPCSpawnPoints[3].Postion = Vector(1374, 3917, 110)
	GM.MapEntities.NPCSpawnPoints[3].Level = 5
	GM.MapEntities.NPCSpawnPoints[3].SpawnTime = 10]]
	
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
	end
	hook.Add("Tick", "SpawnMapEntities", function() GAMEMODE:SpawnMapEntities() end)

	function GM:CreateNPC(strNPC, tblSpawnPoint)
		local tblNPCTable = NPCTable(strNPC)
		local entNewMonster = ents.Create(tblNPCTable.SpawnName)
		entNewMonster:SetPos(tblSpawnPoint.Postion)
		entNewMonster:Spawn()
		for _, ply in pairs(player.GetAll()) do
			entNewMonster:AddEntityRelationship(ply, tblNPCTable.Relation, 99)
		end
		if tblNPCTable.Relation == Hate then
			GAMEMODE.NPCEnemy = entNewMonster
			if GAMEMODE.NPCAlly then
				GAMEMODE.NPCAlly:AddEntityRelationship(entNewMonster, Hate, 99)
				entNewMonster:AddEntityRelationship(GAMEMODE.NPCAlly, Hate, 99)

			end
		end
		if tblNPCTable.Relation == Like then
			GAMEMODE.NPCAlly = entNewMonster
			if GAMEMODE.NPCEnemy then
				GAMEMODE.NPCEnemy:AddEntityRelationship(entNewMonster, Hate, 99)
				entNewMonster:AddEntityRelationship(GAMEMODE.NPCEnemy, Hate, 99)
			end
		end
		if tblNPCTable.Race == "combine" then
			entNewMonster:Give("weapon_ar2")
		end
		if tblNPCTable.Race == tblNPCTable.Race then
			entNewMonster:AddEntityRelationship(entNewMonster, Like, 99)	
		end
		entNewMonster:SetNWInt("level", tblSpawnPoint.Level)
		local intHealth = tblSpawnPoint.Level * tblNPCTable.HealthPerLevel
		entNewMonster:SetMaxHealth(intHealth)
		entNewMonster:SetHealth(intHealth)
		entNewMonster:SetNWInt("Health", intHealth)
		entNewMonster:SetNWInt("MaxHealth", intHealth)
		return entNewMonster
	end
	
	function GM:CreateSpawnPoint(vecPosition, MonsterType)
		if MonsterType == "zombie" then
			local tblNewSpawnPoint = {}
			tblNewSpawnPoint.NPC = "zombie"
			tblNewSpawnPoint.Postion = vecPosition or Vector(0, 0, 0)
			tblNewSpawnPoint.Level = 5
			tblNewSpawnPoint.SpawnTime = 10
			table.insert(GAMEMODE.MapEntities.NPCSpawnPoints, tblNewSpawnPoint)
		end
		if MonsterType == "antlion" then
			local tblNewSpawnPoint = {}
			tblNewSpawnPoint.NPC = "antlion"
			tblNewSpawnPoint.Postion = vecPosition or Vector(0, 0, 0)
			tblNewSpawnPoint.Level = 7
			tblNewSpawnPoint.SpawnTime = 15
			table.insert(GAMEMODE.MapEntities.NPCSpawnPoints, tblNewSpawnPoint)
		end
		if MonsterType == "antlionguard" then
			local tblNewSpawnPoint = {}
			tblNewSpawnPoint.NPC = "antlionguard"
			tblNewSpawnPoint.Postion = vecPosition or Vector(0, 0, 0)
			tblNewSpawnPoint.Level = 10
			tblNewSpawnPoint.SpawnTime = 30
			table.insert(GAMEMODE.MapEntities.NPCSpawnPoints, tblNewSpawnPoint)
		end
		if MonsterType == "combine" then
			local tblNewSpawnPoint = {}
			tblNewSpawnPoint.NPC = "combine"
			tblNewSpawnPoint.Postion = vecPosition or Vector(0, 0, 0)
			tblNewSpawnPoint.Level = 300
			tblNewSpawnPoint.SpawnTime = 20
			table.insert(GAMEMODE.MapEntities.NPCSpawnPoints, tblNewSpawnPoint)
		end
	end
	
	concommand.Add("UD_Dev_EditMap_CreateSpawnPoint", function(ply, command, args)
		if !ply:IsAdmin() or !ply:IsPlayer() then return end
		if !args then return end
		GAMEMODE:CreateSpawnPoint(ply:GetEyeTraceNoCursor().HitPos, zombie or args[1])
	end)
	concommand.Add("UD_Dev_EditMap_SaveMap", function(ply, command, args)
		if !ply:IsAdmin() or !ply:IsPlayer() then return end
		GAMEMODE:SaveMapObjects()
	end)
end