include("shared.lua")

function SWEP:DrawWorldModel()
	if self:GetNWString("item") && self.entWoldModel.Item != self:GetNWString("item") then
		local tblItemTable = GAMEMODE.DataBase.Items[self:GetNWString("item")]
		if tblItemTable then
			if self.entWoldModel then self.entWoldModel:Remove() end
			self.entWoldModel = GAMEMODE:BuildModel(tblItemTable.Model)
			self.entWoldModel.Item = self:GetNWString("item")
			self.WeaponTable = tblItemTable
		end
	end
	
	local intHandBone = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")
	local vecRightHandPos, angRightHandAngle = self.Owner:GetBonePosition(intHandBone)
	local tblItemTable = GAMEMODE.DataBase.Items[self:GetNWString("item")]
	local vecAddativePosition = Vector(0, 0, 0)
	local angAddativeAngle = Angle(0, 0, 0)
	if tblItemTable && tblItemTable.Model && tblItemTable.Model[1] then
		vecAddativePosition = vecAddativePosition + angRightHandAngle:Right() * tblItemTable.Model[1].Position.x
		vecAddativePosition = vecAddativePosition + angRightHandAngle:Forward() * tblItemTable.Model[1].Position.y
		vecAddativePosition = vecAddativePosition + angRightHandAngle:Up() * -tblItemTable.Model[1].Position.z
		angAddativeAngle = tblItemTable.Model[1].Angle
	end
	self.entWoldModel:SetPos(vecRightHandPos + vecAddativePosition)
	angRightHandAngle.r = 0
	angRightHandAngle.p = -angRightHandAngle.p
	self.entWoldModel:SetAngles(angRightHandAngle + angAddativeAngle)
end