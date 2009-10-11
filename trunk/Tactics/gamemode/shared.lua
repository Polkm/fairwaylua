GM.Name 		= "Fiesta"
GM.Author 		= "Shell Shocked"
GM.Email 		= ""
GM.Website 		= ""
GM.TeamBased 	= false

IdealCammeraDistance = 500
IdealCammeraPosition = Vector(-IdealCammeraDistance / 1.375, -IdealCammeraDistance / 1.375, IdealCammeraDistance)
IdealCammeraAngle = Angle(45, 45, 0)
CammeraSmoothness = 15

local Player = FindMetaTable("Player")
function Player:GetIdealCamPos()
	return self:GetPos() + IdealCammeraPosition + self.AddativeCamPos
end
function Player:GetIdealCamAngle()
	return IdealCammeraAngle + Angle(self.AddativeCamAngle, 0, 0)
end