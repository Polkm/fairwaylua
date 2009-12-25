-------------------------
--------Includes---------
include('shared.lua')
include('sh_camera.lua')
include('sh_resource.lua')
include('cl_hud.lua')
include('cl_mainmenu.lua')
----------Menus----------
GM.MainMenu = nil
--------Inventory--------
GM.Inventory = {}
GM.Inventory_Temp = {}
GM.Paperdoll = {}
GM.TotalWeight = 0
----------Colors---------
clrGray = Color(97, 95, 90, 255)
clrDrakGray = Color(54, 53, 42, 255)
clrGreen = Color(194, 255, 72, 255)
clrOrange = Color(212, 143, 57, 255)
clrPurple = Color(140, 84, 178, 255)
clrBlue = Color(74, 124, 178, 255)
clrRed = Color(89, 33, 26, 255)
clrTan = Color(178, 161, 126, 255)
clrWhite = Color(242, 242, 242, 255)
-------------------------

function UpdateItemUsrMsg(usrMsg)
	local strItem = usrMsg:ReadString()
	local intAmount = usrMsg:ReadLong()
	local tblItemTable = GAMEMODE.DataBase.Items[strItem]
	if !tblItemTable or intAmount == 0 then return end
	GAMEMODE.Inventory[strItem] = (GAMEMODE.Inventory[strItem] or 0) + intAmount
	GAMEMODE.TotalWeight = GAMEMODE.TotalWeight + ((tblItemTable.Weight or 0) * intAmount)
	if GAMEMODE.MainMenu then
		GAMEMODE.MainMenu.InventoryTab:LoadInventory()
	end
end
usermessage.Hook("UD_UpdateItem", UpdateItemUsrMsg)

function UpdatePapperDollUsrMsg(usrMsg)
	local strSlot = usrMsg:ReadString()
	local strItem = usrMsg:ReadString()
	local tblItemTable = GAMEMODE.DataBase.Items[strItem]
	if !strSlot then return end
	if !tblItemTable then strItem = nil end
	GAMEMODE.Paperdoll[strSlot] = strItem
	if GAMEMODE.MainMenu then
		GAMEMODE.MainMenu.InventoryTab:LoadInventory()
	end
end
usermessage.Hook("UD_UpdatePapperDoll", UpdatePapperDollUsrMsg)

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
end

function GM:OnPlayerChat(plySpeaker, strText, boolTeamOnly, boolPlayerIsDead)
	local tblText = string.ToTable(strText)
	local clrChat = clrWhite
	local boolDisplayName = true
	if plySpeaker == LocalPlayer() then clrChat = clrTan end
	if tblText[1] == "*" and tblText[#tblText] == "*" && #tblText > 2 then clrChat = clrGreen end
	if tblText[#tblText] == "!" && #tblText > 1 then clrChat = clrOrange end
	if boolDisplayName then
		chat.AddText(clrWhite, plySpeaker:Nick(), clrTan, ": ", clrChat,  strText)
	else
		chat.AddText(clrChat, strText)
	end
	return true
end