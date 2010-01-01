local Player = FindMetaTable("Player")

function Player:NewGame()
	AddItemToInv(self, "money", 200)
	AddItemToInv(self, "can", 5)
	AddItemToInv(self, "pistol", 2)
	AddItemToInv(self, "pistolammo", 1)
	AddItemToInv(self, "shotgun", 1)
	AddItemToInv(self, "frying_pan", 1)
	AddItemToInv(self, "meat_cleaver", 1)
	AddItemToInv(self, "helm", 1)
	AddItemToInv(self, "armor_junk_chest", 1)
	print("NEW GAME BITCHES")
	--self:SaveGame()
end

function Player:LoadGame()
	self.Data = {}
	self.Loadout = {}
	self.Weight = 0
	local strSteamID = string.Replace(self:SteamID(), ":", "!")
	if strSteamID != "STEAM_ID_PENDING" then
		local strFileName = "UnderDone/" .. strSteamID .. ".txt"
		if file.Exists(strFileName) && 1 == 2 then
			local tblDecodedTable = glon.decode(file.Read(strFileName))
			if tblDecodedTable.Inventory then
				for item, amount in pairs(tblDecodedTable.Inventory) do
					AddItemToInv(self, item, amount)
				end
			end
		else
			self:NewGame()
		end
		for _, ply in pairs(player.GetAll()) do
			if ply.Data.Paperdoll then
				for slot, item in pairs(ply.Data.Paperdoll) do
					local tblItemTable = GAMEMODE.DataBase.Items[item]
					umsg.Start("UD_UpdatePapperDoll", self)
					umsg.Entity(ply)
					umsg.String(tblItemTable.Slot)
					if ply.Data.Paperdoll[tblItemTable.Slot] then
						umsg.String(tblItemTable.Name)
					end
					umsg.End()
				end
			end
		end
	end
end

function Player:SaveGame()
	local strSteamID = string.Replace(self:SteamID(), ":", "!")
	if strSteamID != "STEAM_ID_PENDING" then
		local strFileName = "UnderDone/" .. strSteamID .. ".txt"
		local tblNewDataTable = {}
		tblNewDataTable.Inventory = {}
		--Polkm: Space saver loop
		if self.Data.Inventory then
			for item, amount in pairs(self.Data.Inventory) do
				if amount > 0 then
					tblNewDataTable.Inventory[item] = amount
				end
			end
			self.Data.Inventory = tblNewDataTable.Inventory
		end
		print(strFileName)
		file.Write(strFileName, glon.encode(self.Data))
	end
end