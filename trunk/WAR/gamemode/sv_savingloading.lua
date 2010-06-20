local Player = FindMetaTable("Player")

function Player:NewGame()
	self:AddEquiptment("shotgun", 2)
	self:AddSquad("melontrooper")
	self:SaveGame()
	print("New Game")
end

function Player:LoadGame()
	self.Data = {}
	local tblDecodedTable = {}
	local strSteamID = string.Replace(self:SteamID(), ":", "!")
	if strSteamID != "STEAM_ID_PENDING" then
		local strFileName = "WAR/" .. strSteamID .. ".txt"
		if file.Exists(strFileName) then
			tblDecodedTable = glon.decode(file.Read(strFileName))
		else
			self:NewGame()
		end
	end
	if tblDecodedTable != {} then
		self:GiveEquiptment(tblDecodedTable.Locker)
		--NOTE TO SELF
		--[[
		you were thinking about how to load the save file
		you need to also wright up the save code
		you need to think more about the equiping things
		and you need to figure a way to make the squad tables trun into actual entities
		get back to work you have a long way to go
		]]
		--[[
		self:GiveItems(tblDecodedTable.Inventory)
		for strItem, intAmount in pairs(tblDecodedTable.Bank or {}) do self:AddItemToBank(strItem, intAmount) end
		for slot, item in pairs(tblDecodedTable.Paperdoll or {}) do self:UseItem(item) end
		for strQuest, tblInfo in pairs(tblDecodedTable.Quests or {}) do self:UpdateQuest(strQuest, tblInfo) end
		for strFriends, tblInfo in pairs(tblDecodedTable.Friends or {}) do self:AddFriend(strFriends, tblInfo.Blocked) end
		for strBook, boolRead in pairs(tblDecodedTable.Library or {}) do self:AddBookToLibrary(strBook) end
		for strMaster, intExp in pairs(tblDecodedTable.Masters or {}) do self:SetMaster(strMaster, intExp) end
		]]
	end
	self.Loaded = true
	self:SetNWBool("Loaded", true)
	hook.Call("WAR_Hook_PlayerLoad", GAMEMODE, self)
end

function Player:SaveGame()
	if !self.Loaded then return end
	if GAMEMODE.StopSaving then return end
	if !self.Data then return end
	local tblSaveTable = table.Copy(self.Data)
	tblSaveTable.Inventory = {}
	--Polkm: Space saver loop
	for strItem, intAmount in pairs(self.Data.Inventory or {}) do
		if intAmount > 0 then tblSaveTable.Inventory[strItem] = intAmount end
	end
	tblSaveTable.Bank = {}
	for strItem, intAmount in pairs(self.Data.Bank or {}) do
		if intAmount > 0 then tblSaveTable.Bank[strItem] = intAmount end
	end
	tblSaveTable.Quests = {}
	for strQuest, tblInfo in pairs(self.Data.Quests or {}) do
		if tblInfo.Done then
			tblSaveTable.Quests[strQuest] = {Done = true}
		else
			tblSaveTable.Quests[strQuest] = tblInfo
		end
	end	
	tblSaveTable.Friends = {}
	for strFriends, tblInfo in pairs(self.Data.Friends or {}) do
		if tblInfo.Blocked then
			tblSaveTable.Friends[strFriends] = {Blocked = true}
		else
			tblSaveTable.Friends[strFriends] = {}
		end
	end	
	local strSteamID = string.Replace(self:SteamID(), ":", "!")
	if strSteamID != "STEAM_ID_PENDING" then
		local strFileName = "WAR/" .. strSteamID .. ".txt"
		tblSaveTable.Exp = self:GetNWInt("exp")
		file.Write(strFileName, glon.encode(tblSaveTable))
	end
end

local function PlayerSave(ply) ply:SaveGame() end
hook.Add("PlayerDisconnected", "PlayerSavePlayerDisconnected", PlayerSave)
hook.Add("UD_Hook_PlayerLevelUp", "PlayerSaveUD_Hook_PlayerLevelUp", PlayerSave)
hook.Add("ShutDown", "PlayerSaveShutDown", function() for _, ply in pairs(player.GetAll()) do PlayerSave(ply) end end)