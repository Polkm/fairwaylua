--Info
GM.Name 		= "WAR"
GM.Author 		= "Shell Shocked Gaming"
GM.Email 		= "polkmpolkmpolkm@gmail.com"
GM.Website 		= "http://shellshocked.net46.net/"
GM.TeamBased 	= false

--Cammera
GM.IdealCammeraDistance = 800
GM.IdealCammeraPosition = Vector(-GM.IdealCammeraDistance / 1.375, -GM.IdealCammeraDistance / 1.375, GM.IdealCammeraDistance)
GM.IdealCammeraAngle = Angle(45, 45, 0)
GM.CammeraSmoothness = 50

--Data Management
GM.Data = {}
GM.Data.Units = {}
function RegisterUnit(tblDataTable)
	GM.Data.Units[tblDataTable.Name] = tblDataTable
end
GM.Data.Equiptment = {}
function RegisterEquiptment(tblDataTable)
	GM.Data.Equiptment[tblDataTable.Name] = tblDataTable
end

local Player = FindMetaTable("Player")
function Player:GetIdealCamPos()
	return self:GetPos() + GAMEMODE.IdealCammeraPosition
end
function Player:GetIdealCamAngle()
	return GAMEMODE.IdealCammeraAngle
end