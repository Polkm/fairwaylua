include("shared.lua")

function SWEP:DrawWorldModel()
	if self:GetNWString("worldmodel") && self.entWoldModel:GetModel() != self:GetNWString("worldmodel") then
		self.entWoldModel:SetModel(self:GetNWString("worldmodel"))
	end
	
	local intHandBone = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")
	local vecRightHandPos, angRightHandAngle = self.Owner:GetBonePosition(intHandBone)
	local intGunBone = self.entWoldModel:LookupBone("ValveBiped.Bip01_R_Hand")
	if !intGunBone or intGunBone == 0 then intGunBone = self.entWoldModel:LookupBone("ValveBiped") end
	local vecGunPos, angGunAng = self.entWoldModel:GetBonePosition(intGunBone)
	if !vecGunPos then vecGunPos = self.entWoldModel:GetPos() end
	
	self.entWoldModel:SetPos(vecRightHandPos + ((self.entWoldModel:GetPos() - vecGunPos) / 2))
	angRightHandAngle.r = 0
	self.entWoldModel:SetAngles(angRightHandAngle)
	--[[self.entWoldModel:SetAttachment(self.Owner:LookupAttachment("anim_attachment_RH"))
	self.entWoldModel:SetAngles(self.Owner:GetAttachment(self.Owner:LookupAttachment("anim_attachment_RH")).Ang)
	self:DrawModel(self:GetNWString("worldmodel"))]]
end