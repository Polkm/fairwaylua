local Player = FindMetaTable("Player")

function Player:GetSlot(strSlot)
	if self.Data && self.Data.Paperdoll && self.Data.Paperdoll[strSlot] then
		return self.Data.Paperdoll[strSlot]
	end
	return
end

function Player:SetPaperDoll(strSlot, strItem)
	if !self or !self:IsValid() then return false end
	local tblItemTable = GAMEMODE.DataBase.Items[strItem] or {}
	self.Data = self.Data or {}
	self.Data.Paperdoll = self.Data.Paperdoll or {}
	if !strItem or self.Data.Paperdoll[strSlot] == strItem then
		self.Data.Paperdoll[strSlot] = nil
	else
		self.Data.Paperdoll[strSlot] = strItem
	end
	if SERVER then
		for name, amount in pairs(tblItemTable.Buffs or {}) do
			if self.Data.Paperdoll[strSlot] then
				self:AddStat(name, amount)
			else
				self:AddStat(name, -amount)
			end
		end
		for slot, item in pairs(self.Data.Paperdoll) do
			if slot != strSlot then
				local tblSlotTable = GAMEMODE.DataBase.Slots[slot]
				if tblSlotTable.ShouldClear && tblSlotTable:ShouldClear(self, tblItemTable) then
					self:UseItem(item)
				end
			end
		end
		umsg.Start("UD_UpdatePapperDoll")
		umsg.Entity(self)
		umsg.String(strSlot)
		if self.Data.Paperdoll[strSlot] then
			umsg.String(self.Data.Paperdoll[strSlot])
		end
		umsg.End()
		self:SaveGame()
	end
end

if CLIENT then
	function UpdatePapperDollUsrMsg(usrMsg)
		local plyPlayer = usrMsg:ReadEntity()
		local strSlot = usrMsg:ReadString()
		local strItem = usrMsg:ReadString()
		if strItem == "" then strItem = nil end
		plyPlayer:SetPaperDoll(strSlot, strItem)
		plyPlayer:PapperDollBuildSlot(strSlot, strItem)
		if plyPlayer == LocalPlayer() && GAMEMODE.MainMenu then
			GAMEMODE.MainMenu.InventoryTab:LoadInventory()
		end
	end
	usermessage.Hook("UD_UpdatePapperDoll", UpdatePapperDollUsrMsg)
	
	function Player:PapperDollBuildSlot(strSlot, strItem)
		if !self.PapperDollEnts then self.PapperDollEnts = {} end
		if self.PapperDollEnts[strSlot] && self.PapperDollEnts[strSlot]:IsValid() then
			for _, ent in pairs(self.PapperDollEnts[strSlot].Children or {}) do
				if ent && ent:IsValid() then ent:Remove() end
			end
			self.PapperDollEnts[strSlot]:Remove()
			self.PapperDollEnts[strSlot] = nil
		end
		if strItem then
			local tblItemTable = GAMEMODE.DataBase.Items[strItem]
			local tblSlotTable = GAMEMODE.DataBase.Slots[strSlot]
			if tblItemTable && tblSlotTable then
				local entNewPart = GAMEMODE:BuildModel(tblItemTable.Model)
				entNewPart:SetParent(self)
				entNewPart.Item = strItem
				entNewPart.Attachment = tblSlotTable.Attachment
				self.PapperDollEnts[strSlot] = entNewPart
			end
		end
	end
	
	function DrawPapperDoll()
		if !LocalPlayer().Data then LocalPlayer().Data = {} end
		if !LocalPlayer().Data.Paperdoll then LocalPlayer().Data.Paperdoll = {} end
		if !SinglePlayer() then
			for _, player in pairs(player.GetAll()) do
				for slot, ent in pairs(player.PapperDollEnts or {}) do
					local tblItemTable = GAMEMODE.DataBase.Items[ent.Item]
					local tblAttachment = player:GetAttachment(player:LookupAttachment(ent.Attachment))
					ent:SetAngles(tblAttachment.Ang)
					ent:SetAngles(ent:LocalToWorldAngles(tblItemTable.Model[1].Angle))
					ent:SetPos(tblAttachment.Pos)
					ent:SetPos(ent:LocalToWorld(tblItemTable.Model[1].Position))
				end
			end
			return
		end
		local player = LocalPlayer()
		for slot, ent in pairs(player.PapperDollEnts or {}) do
			local tblItemTable = GAMEMODE.DataBase.Items[ent.Item]
			local tblAttachment = player:GetAttachment(player:LookupAttachment(ent.Attachment))
			local boolIsBeingEdited = player == LocalPlayer() && GAMEMODE.PapperDollEditor.CurrentSlot && GAMEMODE.PapperDollEditor.CurrentSlot == slot
			local angAddAngle = tblItemTable.Model[1].Angle
			if boolIsBeingEdited && GAMEMODE.PapperDollEditor.CurrentObject == 1 then angAddAngle = GAMEMODE.PapperDollEditor.CurrentAddedAngle end
			ent:SetAngles(tblAttachment.Ang)
			ent:SetAngles(ent:LocalToWorldAngles(angAddAngle))
			local vecAddVector = tblItemTable.Model[1].Position
			if boolIsBeingEdited && GAMEMODE.PapperDollEditor.CurrentObject == 1 then vecAddVector = GAMEMODE.PapperDollEditor.CurrentAddedVector end
			ent:SetPos(tblAttachment.Pos)
			ent:SetPos(ent:LocalToWorld(vecAddVector))
			for k, kid in pairs(ent.Children or {}) do
				if boolIsBeingEdited && GAMEMODE.PapperDollEditor.CurrentObject == k + 1 then
					local vecAddVector = GAMEMODE.PapperDollEditor.CurrentAddedVector
					local angAddAngle = GAMEMODE.PapperDollEditor.CurrentAddedAngle
					kid:SetAngles(ent:GetAngles())
					kid:SetAngles(kid:LocalToWorldAngles(angAddAngle))
					kid:SetPos(ent:GetPos())
					kid:SetPos(kid:LocalToWorld(vecAddVector))
				end
			end
		end
	end
	hook.Add("PrePlayerDraw", "DrawPapperDoll", function() DrawPapperDoll() end)
end

function GM:BuildModel(tblModelTable)
	local tblLoopTable = tblModelTable
	if type(tblModelTable) == "string" then
		tblLoopTable = {}
		tblLoopTable[1] = {Model = tblModelTable, Position = Vector(0, 0, 0), Angle = Angle(0, 0, 0)}
	end
	local entReturnEnt = nil
	local entNewPart = nil
	for key, modelinfo in pairs(tblLoopTable) do
		entNewPart = ents.Create("prop_physics")
		entNewPart:SetModel(modelinfo.Model)
		if entReturnEnt then entNewPart:SetAngles(entReturnEnt:GetAngles()) end
		if entReturnEnt then entNewPart:SetAngles(entNewPart:LocalToWorldAngles(modelinfo.Angle)) end
		if !entReturnEnt then entNewPart:SetAngles(modelinfo.Angle) end
		if entReturnEnt then entNewPart:SetPos(entReturnEnt:GetPos()) end
		if entReturnEnt then entNewPart:SetPos(entNewPart:LocalToWorld(modelinfo.Position)) end
		if !entReturnEnt then entNewPart:SetPos(modelinfo.Position) end
		entNewPart:SetParent(entReturnEnt)
		if SERVER then
			entNewPart:SetCollisionGroup(COLLISION_GROUP_WORLD)
		end
		entNewPart:Spawn()
		if entReturnEnt then
			entReturnEnt.Children = entReturnEnt.Children or {}
			table.insert(entReturnEnt.Children, entNewPart)
		end
		if !entReturnEnt then entReturnEnt = entNewPart end
	end
	return entReturnEnt
end