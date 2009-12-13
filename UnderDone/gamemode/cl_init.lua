include('shared.lua')
include("items.lua")
include('cl_hud.lua')
include('cl_mainmenu.lua')
include('VGUIObjects/FListItem.lua')
include('VGUIObjects/FIconItem.lua')
include('VGUIObjects/FMultiLineLabel.lua')
include('MainMenuTabs/inventory.lua')
include('MainMenuTabs/players.lua')
local MainMenu = nil

clrGray = Color(97, 95, 90, 255)
clrDrakGray = Color(54, 53, 42, 255)
clrGreen = Color(194, 255, 72, 255)
clrOrange = Color(212, 143, 57, 255)
clrPurple = Color(140, 84, 178, 255)
clrBlue = Color(74, 124, 178, 255)
clrRed = Color(89, 33, 26, 255)
clrTan = Color(178, 161, 126, 255)
clrWhite = Color(242, 242, 242, 255)

Inventory = {}
Inventory_Temp = {}
Weight = 0

function UpdateItemUsrMsg(usrMsg)
	local strItem = usrMsg:ReadString()
	local intAmount = usrMsg:ReadLong()
	local tblItemTable = GAMEMODE.DataBase.Items[strItem]
	if !Inventory[strItem] then
		Inventory[strItem] = intAmount
	else
		Inventory[strItem] = Inventory[strItem] + intAmount
	end
	if tblItemTable && tblItemTable.Weight then
		Weight = Weight + (tblItemTable.Weight * intAmount)
	end
	if MainMenu then
		MainMenu.InventoryTab:LoadInventory()
	end
end
usermessage.Hook("UD_UpdateItem", UpdateItemUsrMsg)

function GM:OnSpawnMenuOpen()
	if !MainMenu then
		MainMenu = vgui.Create("mainmenu")
		MainMenu:Center()
	end
	MainMenu:SetVisible(true)
	MainMenu.frame:SetVisible(true)
	gui.EnableScreenClicker(true)
	RestoreCursorPosition()
	MainMenu.PlayersTab:LoadPlayers()
end

function GM:OnSpawnMenuClose()
	MainMenu:SetVisible(false)
	MainMenu.frame:SetVisible(false)
	RememberCursorPosition()
	gui.EnableScreenClicker(false)
end

function GM:OnPlayerChat(plySpeaker, strText, boolTeamOnly, boolPlayerIsDead)
	local tblText = string.ToTable(strText)
	local clrChat = Color(200, 200, 180)
	local boolDisplayName = true
	if plySpeaker == LocalPlayer() then clrChat = Color(150, 150, 150) end
	if tblText[1] == "*" and tblText[#tblText] == "*" && #tblText > 2 then clrChat = Color(150, 255, 150) end
	if tblText[#tblText] == "!" && #tblText > 1 then clrChat = Color(255, 50, 50) end
	if boolDisplayName then
		chat.AddText(clrChat, plySpeaker:Nick(), ": ",  strText)
	else
		chat.AddText(clrChat, strText)
	end
	return true
end