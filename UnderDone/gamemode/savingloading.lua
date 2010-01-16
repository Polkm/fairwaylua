local Player = FindMetaTable("Player")

function Player:NewGame()
	self:SetNWInt("exp", 0)
	self:AddItem("money", 200)
	self:AddItem("can", 3)
	self:AddItem("pistol", 1)
	self:AddItem("small_ammo", 3)
	self:AddItem("shotgun", 1)
	self:AddItem("frying_pan", 1)
	self:AddItem("meat_cleaver", 1)
	self:AddItem("axe", 1)
	self:AddItem("armor_junk_helm", 1)
	self:AddItem("armor_junk_chest", 1)
	self:AddItem("goggles_scanner", 1)
	self:AddItem("sheild", 1)
	self:AddItem("saw_sheild", 1)
	self:SaveGame()
	print("New Game")
end

function Player:LoadGame()
	self.Data = {}
	self.Race = "human"
	for name, stat in pairs(GAMEMODE.DataBase.Stats) do
		self:SetStat(name, stat.Default)
	end
	local strSteamID = string.Replace(self:SteamID(), ":", "!")
	if strSteamID != "STEAM_ID_PENDING" then
		local strFileName = "UnderDone/" .. strSteamID .. ".txt"
		if file.Exists(strFileName) then
			local tblDecodedTable = glon.decode(file.Read(strFileName))
			if tblDecodedTable.Inventory then
				for item, amount in pairs(tblDecodedTable.Inventory) do
					self:AddItem(item, amount)
				end
			end
			if tblDecodedTable.Paperdoll then
				for slot, item in pairs(tblDecodedTable.Paperdoll) do
					self:UseItem(item)
				end
			end
			self:SetNWInt("exp", tblDecodedTable.Exp or 0)
		else
			self:NewGame()
		end
		for _, ply in pairs(player.GetAll()) do
			if ply.Data && ply.Data.Paperdoll then
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
		local tblSaveTable = self.Data
		tblSaveTable.Exp = self:GetNWInt("exp") or 0
		--file.Write(strFileName, glon.encode(tblSaveTable))
	end
end