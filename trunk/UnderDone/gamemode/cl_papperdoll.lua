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
			entNewPart.Item = strItem
			entNewPart.Attachment = tblSlotTable.Attachment
			self.PapperDollEnts[strSlot] = entNewPart
		end
	end
end

function DrawPapperDoll()
	for _, player in pairs(player.GetAll()) do
		if player.PapperDollEnts then
			for slot, ent in pairs(player.PapperDollEnts) do
				local tblItemTable = GAMEMODE.DataBase.Items[ent.Item]
				local intAttachment = player:LookupAttachment(ent.Attachment)
				ent:SetPos(player:GetAttachment(intAttachment).Pos)
				ent:SetPos(ent:LocalToWorld(tblItemTable.Model[1].Position))
				ent:SetAngles(player:GetAttachment(intAttachment).Ang)
				ent:SetAngles(ent:LocalToWorldAngles(tblItemTable.Model[1].Angle))
			end
		end
	end
end
hook.Add("PrePlayerDraw", "DrawPapperDoll", function() DrawPapperDoll() end)