-------------------------
--------Includes---------
include('shared.lua')
include('itemdata/sh_items_base.lua')
include('sh_resource.lua')
include('cl_hud.lua')
include('cl_mainmenu.lua')
include('cl_jdraw.lua')
include('cl_papperdoll.lua')
include('cl_papperdoll_editor.lua')
----------Menus----------
GM.MainMenu = nil
GM.HoveredIcon = nil
GM.DraggingPanel = nil
GM.DraggingGhost = nil
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
GM.TranslateColor = {}
GM.TranslateColor["green"] = clrGreen
GM.TranslateColor["orange"] = clrOrange
GM.TranslateColor["purple"] = clrPurple
GM.TranslateColor["blue"] = clrBlue
GM.TranslateColor["red"] = clrRed
GM.TranslateColor["tan"] = clrTan
GM.TranslateColor["white"] = clrWhite
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
	local plyActivePlayer = usrMsg:ReadEntity()
	local strSlot = usrMsg:ReadString()
	local strItem = usrMsg:ReadString()
	local tblItemTable = GAMEMODE.DataBase.Items[strItem]
	if !strSlot then return end
	if !tblItemTable then strItem = nil end
	plyActivePlayer:PapperDollBuildSlot(strSlot, strItem)
	if plyActivePlayer == LocalPlayer() then
		GAMEMODE.Paperdoll[strSlot] = strItem
		if GAMEMODE.MainMenu then
			GAMEMODE.MainMenu.InventoryTab:LoadInventory()
		end
	end
end
usermessage.Hook("UD_UpdatePapperDoll", UpdatePapperDollUsrMsg)

function UpdateStatUsrMsg(usrMsg)
	local strStat = usrMsg:ReadString()
	local intAmount = usrMsg:ReadLong()
	LocalPlayer():SetStat(strStat, intAmount)
end
usermessage.Hook("UD_UpdateStats", UpdateStatUsrMsg)

function GM:GetColor(strColorName)
	local clrTranslated = GAMEMODE.TranslateColor[strColorName]
	if clrTranslated then return clrTranslated end
	return clrWhite
end

function GM:Think()
	if GAMEMODE.DraggingPanel then
		if !GAMEMODE.DraggingGhost then
			GAMEMODE.DraggingGhost = vgui.Create("FIconItem")
			GAMEMODE.DraggingGhost:SetSize(GAMEMODE.DraggingPanel:GetWide(), GAMEMODE.DraggingPanel:GetTall())
			GAMEMODE.DraggingGhost.Icon = GAMEMODE.DraggingPanel.Icon
			GAMEMODE.DraggingGhost.Amount = GAMEMODE.DraggingPanel.Amount
			GAMEMODE.DraggingGhost:SetAlpha(255)
			GAMEMODE.DraggingGhost:MakePopup()
			GAMEMODE.DraggingGhost.IsGhost = true
		end
		GAMEMODE.DraggingGhost:SetPos(gui.MouseX() + 1, gui.MouseY() + 1)
		if !input.IsMouseDown(MOUSE_LEFT) then
			if GAMEMODE.HoveredIcon then
				GAMEMODE.HoveredIcon.DoDropedOn()
			end
			GAMEMODE.DraggingPanel = nil
		end
	else
		if GAMEMODE.DraggingGhost then
			GAMEMODE.DraggingGhost:Remove()
			GAMEMODE.DraggingGhost = nil
		end
	end
end

function GM:GUIMouseReleased(mousecode)
	if GAMEMODE.DraggingPanel then
		if GAMEMODE.DraggingPanel.DoDropItem then
			GAMEMODE.DraggingPanel.DoDropItem()
		end
		GAMEMODE.DraggingPanel = nil
	end
end

function GM:AddHoverObject(pnlNewHoverObject, pnlParentObject)
	if !pnlNewHoverObject.IsGhost then
		pnlNewHoverObject.OnCursorEntered = function()
			GAMEMODE.HoveredIcon = pnlParentObject or pnlNewHoverObject
		end
		pnlNewHoverObject.OnCursorExited = function()
			GAMEMODE.HoveredIcon = nil
		end
	end
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