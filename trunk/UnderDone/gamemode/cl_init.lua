--------Includes---------
include('shared.lua')
include('itemdata/sh_items_base.lua')
include('sh_resource.lua')
----------Menus----------
GM.MainMenu = nil
----------Colors---------
clrGray = Color(97, 95, 90, 255)
clrDrakGray = Color(54, 53, 42, 255)
clrGreen = Color(194, 255, 72, 255)
clrOrange = Color(255, 137, 44, 255)
clrPurple = Color(87, 76, 135, 255)
clrBlue = Color(59, 142, 209, 255)
clrRed = Color(191, 75, 37, 255)
clrTan = Color(178, 161, 126, 255)
clrCream = Color(245, 255, 154, 255)
clrWhite = Color(242, 242, 242, 255)
GM.TranslateColor = {}
GM.TranslateColor["green"] = clrGreen
GM.TranslateColor["orange"] = clrOrange
GM.TranslateColor["purple"] = clrPurple
GM.TranslateColor["blue"] = clrBlue
GM.TranslateColor["red"] = clrRed
GM.TranslateColor["tan"] = clrTan
GM.TranslateColor["white"] = clrWhite
-------------------------
function GM:GetColor(strColorName)
	local clrTranslated = GAMEMODE.TranslateColor[strColorName]
	if clrTranslated then return clrTranslated end
	return clrWhite
end

function GM:OnSpawnMenuOpen()
	GAMEMODE.MainMenu = (GAMEMODE.MainMenu or vgui.Create("mainmenu"))
	GAMEMODE.MainMenu:Center()
	GAMEMODE.MainMenu:SetTargetAlpha(255)
	GAMEMODE.MainMenu.Frame:SetVisible(true)
	gui.EnableScreenClicker(true)
	RestoreCursorPosition()
	GAMEMODE.MainMenu.PlayersTab:LoadPlayers()
end

function GM:OnSpawnMenuClose()
	GAMEMODE.MainMenu:SetTargetAlpha(0)
	if GAMEMODE.DraggingGhost then
		GAMEMODE.DraggingPanel = nil
	end
end
