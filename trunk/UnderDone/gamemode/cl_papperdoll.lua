local Player = FindMetaTable("Player")

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