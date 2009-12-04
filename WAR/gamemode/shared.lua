--Info
GM.Name 		= "WAR"
GM.Author 		= "Shell Shocked Gaming"
GM.Email 		= "polkmpolkmpolkm@gmail.com"
GM.Website 		= "http://shellshocked.net46.net/"
GM.TeamBased 	= false

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

function GM:GetPlacement(intUnits)
	local intSpace = intUnits * 15
	return Vector(math.random(-intSpace, intSpace), math.random(-intSpace, intSpace), 20)
end