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
	
	local mchSpawnPoints = vgui.Create("DMultiChoice", frmMapEditorFrame)
	mchSpawnPoints:SetPos(5, 30)
	mchSpawnPoints:SetSize(frmMapEditorFrame:GetWide() - 10, 20)
	for key, spawnpoints in pairs(GAMEMODE.MapEntities.NPCSpawnPoints) do
		mchSpawnPoints:AddChoice(key)
	end
	mchSpawnPoints.OnSelect = function(index, value, data)
		GAMEMODE.MapEditor.AddSpawPointControls(pnlControlsList, tonumber(value))
	end
	
	local btnSaveButton = vgui.Create("DButton", frmMapEditorFrame)
	btnSaveButton:SetText("Save Map")
	btnSaveButton.DoClick = function(btnSaveButton) RunConsoleCommand("UD_Dev_EditMap_SaveMap") end
	btnSaveButton:SetPos(5, frmMapEditorFrame:GetTall() - 25)
	btnSaveButton:SetSize(frmMapEditorFrame:GetWide() - 10, 20)
end

function GM.MapEditor.AddSpawPointControls(pnlParent, intSpawnKey)
	pnlParent:Clear()
	local tblSpawnTable = GAMEMODE.MapEntities.NPCSpawnPoints[intSpawnKey]
	local strNPCName = "zombie"
	local mchNPCTypes = vgui.Create("DMultiChoice")
	local intID = 1
	for key, npctable in pairs(GAMEMODE.DataBase.NPCs) do
		mchNPCTypes:AddChoice(key)
		if key == tblSpawnTable.NPC then
			mchNPCTypes:ChooseOptionID(intID)
		end
		intID = intID + 1
	end
	mchNPCTypes.OnSelect = function(index, value, data)
		strNPCName = data
	end
	pnlParent:AddItem(mchNPCTypes)
	
	local btnPlaceZombie = vgui.Create("DButton")
	btnPlaceZombie:SetText("Update Server")
	btnPlaceZombie.DoClick = function(btnPlaceZombie)
		RunConsoleCommand("UD_Dev_EditMap_UpdateSpawnPoint", intSpawnKey, strNPCName)
	end
	pnlParent:AddItem(btnPlaceZombie)
	
	local btnPlaceZombie = vgui.Create("DButton")
	btnPlaceZombie:SetText("Place Zombie")
	btnPlaceZombie.DoClick = function(btnPlaceZombie)
		RunConsoleCommand("UD_Dev_EditMap_CreateSpawnPoint", "zombie")
	end
	pnlParent:AddItem(btnPlaceZombie)
end
concommand.Add("UD_Dev_EditMap", function() GAMEMODE.MapEditor.OpenMapEditor() end)