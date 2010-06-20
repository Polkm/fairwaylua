local Entity = FindMetaTable("Entity")
local Player = FindMetaTable("Player")

function Entity:AddEquiptment(strEquiptment, intAmount)
	--Make sure everything is valid
	if !ValidEntity(self) then return false end
	local tblEquiptmentTable = GAMEMODE.Data.Equiptment[strEquiptment]
	if !tblEquiptmentTable then return false end
	--Declare variables we will need
	intAmount = tonumber(intAmount) or 1
	self.Data = self.Data or {}
	self.Data.Locker = self.Data.Locker or {}
	self.Data.Locker[strEquiptment] = self.Data.Locker[strEquiptment] or 0
	self.Weight = self.Weight or 0
	--Clamp the amount to the weight you can cary or the amount you have
	local intMaxItems = math.Clamp(math.floor((self:GetMaxWeight() - self.Weight) / 1), 0, intAmount)
	intAmount = math.Clamp(intAmount, -self.Data.Locker[strEquiptment], intMaxItems)
	if intAmount == 0 then return false end
	
	--[[
	if SERVER then
		if self.Data.Squads && intAmount < 0 then
			if self.Data.Locker[strEquiptment] == 1 && self.Data.Paperdoll[tblEquiptmentTable.Slot] == strEquiptment then
				self:UseItem(strEquiptment)
			end
		end
	end]]
	
	self.Data.Locker[strEquiptment] = self.Data.Locker[strEquiptment] + intAmount
	self.Weight = self.Weight + (1 * intAmount)
	if SERVER && self:GetClass() == "player" then
		SendUsrMsg("UD_UpdateEquiptment", self, {strEquiptment, intAmount})
		--self:SaveGame()
	end
	return true
end

function Entity:RemoveEquiptment(strEquiptment, intAmount)
	return self:AddEquiptment(strEquiptment, -intAmount)
end

function Player:AddSquad(strClass)
	--Make sure everything is valid
	if !ValidEntity(self) then return false end
	local tblClassTable = GAMEMODE.Data.Classes[strClass]
	if !tblClassTable then return false end
	--Declare variables we will need
	self.Data = self.Data or {}
	self.Data.Squads = self.Data.Squads or {}
	
	local tblNewSquad = {}
	tblNewSquad.Class = strClass
	tblNewSquad.Exp = 0
	tblNewSquad.Equipment = {}
	tblNewSquad.Units = {}
	for i = 1, tblClassTable.SquadLimit do 
		local tblNewUnit = {}
		tblNewUnit.Equipment = tblClassTable.DefaultEquiptment or {}
		table.insert(tblNewSquad.Units, tblNewUnit)
	end
	table.insert(self.Data.Squads, tblNewSquad)
	
	if SERVER then
		SendUsrMsg("UD_AddSquad", self, {strClass})
	end
	
	return true
end

function Entity:EquipEquiptment(strEquiptment, intAmount, intSquad, intUnit)
	if !ValidEntity(self) then return false end
	local tblEquiptmentTable = GAMEMODE.Data.Equiptment[strEquiptment]
	if !tblEquiptmentTable then return false end
	
	
	
end

function Entity:GetAvailableLocker()
	if !ValidEntity(self) then return false end
	self.Data = self.Data or {}
	local tblAvailableLocker = table.Copy(self.Data.Locker or {})
	for _, tblSquad in pairs(self.Data.Squads or {}) do
		local tblClassTable = GAMEMODE.Data.Classes[tblSquad.Class]
		for strEquiptment, intAmount in pairs(tblSquad.Equipment or {}) do
			tblAvailableLocker[strEquiptment] = tblAvailableLocker[strEquiptment] - intAmount
		end
		for _, tblUnit in pairs(tblSquad.Units or {}) do
			for strEquiptment, intAmount in pairs(tblUnit.Equipment or {}) do
				if !table.HasValue(tblClassTable.DefaultEquiptment, strEquiptment) then
					tblAvailableLocker[strEquiptment] = tblAvailableLocker[strEquiptment] - intAmount
				end
			end
		end
	end
end


function Entity:GetItem(strEquiptment)
	if !ValidEntity(self) then return 0 end
	self.Data.Locker = self.Data.Locker or {}
	return self.Data.Locker[strEquiptment] or 0
end

function Entity:TransferItem(objTarget, strItem1, intAmount1, strItem2, intAmount2)
	intAmount1 = tonumber(intAmount1) or 1
	intAmount2 = tonumber(intAmount2) or 0
	if strItem1 then if !objTarget:HasItem(strItem1, intAmount1) then return false end end
	if strItem2 then if !self:HasItem(strItem2, intAmount2) then return false end end
	if strItem1 then if self:AddEquiptment(strItem1, intAmount1) then objTarget:AddEquiptment(strItem1, -intAmount1) end end
	if strItem2 then if objTarget:AddEquiptment(strItem2, intAmount2) then self:AddEquiptment(strItem2, -intAmount2) end end
end

function Entity:HasItem(strEquiptment, intAmount)
	if !self.Data.Locker then return false end
	intAmount = tonumber(intAmount) or 1
	return (self:GetItem(strEquiptment) or 0) - intAmount >= 0 && intAmount > 0
end

function Entity:HasRoomFor(tblEquiptment, intAddtionalConstant)
	local intWeight = self:TotalWeightOf(tblEquiptment)
	if intWeight + (intAddtionalConstant or 0) <= self:GetMaxWeight() then return true end
end

function Entity:TotalWeightOf(tblEquiptment)
	local intWeight = self.Weight or 0
	for strEquiptment, intAmount in pairs(tblEquiptment or {}) do
		local tblItemTable = ItemTable(strEquiptment)
		intWeight = intWeight + (tblItemTable.Weight * intAmount)
	end
	return intWeight
end

function Entity:GiveEquiptment(tblEquiptment)
	for strEquiptment, intAmount in pairs(tblEquiptment or {}) do
		self:AddEquiptment(strEquiptment, intAmount)
	end
end

function Entity:TakeEquiptment(tblEquiptment)
	for strEquiptment, intAmount in pairs(tblEquiptment or {}) do
		if !self:RemoveEquiptment(strEquiptment, intAmount) then return false end
	end
end

function Entity:GetMaxWeight()
	return 15
end

if CLIENT then
	usermessage.Hook("UD_UpdateEquiptment", function(usrMsg)
		LocalPlayer():AddEquiptment(usrMsg:ReadString(), usrMsg:ReadLong())
	end)
	usermessage.Hook("UD_AddSquad", function(usrMsg)
		LocalPlayer():AddSquad(usrMsg:ReadString())
	end)
end