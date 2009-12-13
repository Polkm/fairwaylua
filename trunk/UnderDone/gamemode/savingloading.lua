local Player = FindMetaTable("Player")

function Player:NewGame()
	AddItemToInv(self, "money", 200)
	AddItemToInv(self, "can", 5)
	AddItemToInv(self, "pistol", 1)
	AddItemToInv(self, "pistolammo", 1)
	AddItemToInv(self, "shotgun", 1)
	self:SaveGame()
end

function Player:LoadGame()
	self.Data = {}
	self.Loadout = {}
	self.Weight = 0
	local strFileName = "UnderDone/" .. self:SteamID() .. ".txt"
	if file.Exists(strFileName) then
		local tblDecodedTable = glon.decode(file.Read(strFileName))
		if tblDecodedTable.Inventory then
			for item, amount in pairs(tblDecodedTable.Inventory) do
				AddItemToInv(self, item, amount)
			end
		end
	else
		self:NewGame()
	end
end

function Player:SaveGame()
	local strFileName = "UnderDone/" .. self:SteamID() .. ".txt"
	local tblSaveTable = {}
	tblSaveTable.Inventory = {}
	--Polkm: Space saver loop
	if self.Data.Inventory then
		for item, amount in pairs(self.Data.Inventory) do
			if amount > 0 then
				tblSaveTable.Inventory[item] = amount
			end
		end
		self.Data.Inventory = tblSaveTable.Inventory
	end
	file.Write(strFileName, glon.encode(self.Data))
end