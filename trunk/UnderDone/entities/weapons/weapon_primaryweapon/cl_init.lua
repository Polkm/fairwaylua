include("shared.lua")

function SWEP:DrawWorldModel()
	if self:GetNWString("item") && self.entWoldModel.Item != self:GetNWString("item") then
		local tblItemTable = GAMEMODE.DataBase.Items[self:GetNWString("item")]
		if tblItemTable then
			if self.entWoldModel then self.entWoldModel:Remove() end
			self.entWoldModel = GAMEMODE:BuildModel(tblItemTable.Model)
			self.entWoldModel.Item = self:GetNWString("item")
		end
	end
	
	local intHandBone = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")
	local vecRightHandPos, angRightHandAngle = self.Owner:GetBonePosition(intHandBone)
	
	self.entWoldModel:SetPos(vecRightHandPos)
	self.entWoldModel:SetAngles(self.entWoldModel:GetAngles() + (angRightHandAngle - self.entWoldModel:GetAngles()))
end