GM.MapEditor = {}

if !SinglePlayer() then return end

function GM.MapEditor.OpenMapEditor()
	local frmMapEditorFrame = vgui.Create("DFrame")
	frmMapEditorFrame:SetPos(50, 50)
	frmMapEditorFrame:SetSize(325, 450)
	frmMapEditorFrame:SetTitle("Papper Doll Editor")
	frmMapEditorFrame:SetVisible(true)
	frmMapEditorFrame:SetDraggable(true)
	frmMapEditorFrame:ShowCloseButton(true)
	frmMapEditorFrame:MakePopup()
	frmMapEditorFrame.btnClose.DoClick = function(btn)
		frmMapEditorFrame:Close()
	end
	local pnlControlsList = vgui.Create("DPanelList", frmMapEditorFrame)
	pnlControlsList:SetPos(5, 60)
	pnlControlsList:SetSize(frmMapEditorFrame:GetWide() - 10, frmMapEditorFrame:GetTall() - 90)
	pnlControlsList:EnableHorizontal(false)
	pnlControlsList:EnableVerticalScrollbar(true)
	pnlControlsList:SetSpacing(5)
	pnlControlsList:SetPadding(5)
	
	local btnPlaceZombie = vgui.Create("DButton")
	btnPlaceZombie:SetText("Place Zombie")
	btnPlaceZombie.DoClick = function(btnPlaceZombie) RunConsoleCommand("UD_Dev_EditMap_CreateSpawnPoint") end
	pnlControlsList:AddItem(btnPlaceZombie)
	
	local btnSaveButton = vgui.Create("DButton", frmMapEditorFrame)
	btnSaveButton:SetText("Save Map")
	btnSaveButton.DoClick = function(btnSaveButton) RunConsoleCommand("UD_Dev_EditMap_SaveMap") end
	btnSaveButton:SetPos(5, frmMapEditorFrame:GetTall() - 25)
	btnSaveButton:SetSize(frmMapEditorFrame:GetWide() - 10, 20)
end
concommand.Add("UD_Dev_EditMap", function() GAMEMODE.MapEditor.OpenMapEditor() end)