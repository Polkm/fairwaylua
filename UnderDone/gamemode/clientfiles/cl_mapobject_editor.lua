GM.MapEditor = {}
GM.MapEditor.Open = false
GM.MapEditor.ObjectsList = nil
GM.MapEditor.CurrentObjectSet = nil
GM.MapEditor.ObjectSets = {}
GM.MapEditor.ObjectSets["NPC_Spawnpoints"] = GM.MapEntities.NPCSpawnPoints
GM.MapEditor.ObjectSets["World_Props"] = GM.MapEntities.WorldProps
GM.MapEditor.CurrentObjectNum = nil
GM.MapEditor.Models = {}
GM.MapEditor.Models["Big Tree"] = "models/props_foliage/oak_tree01.mdl"
GM.MapEditor.Models["Tree"] = "models/props_foliage/tree_deciduous_01a.mdl"
GM.MapEditor.Models["Cattail"] = "models/props_foliage/cattails.mdl"
GM.MapEditor.Models["Shrub"] = "models/props_foliage/shrub_01a.mdl"
GM.MapEditor.Models["Oil Drum"] = "models/props_c17/oildrum001.mdl"
GM.MapEditor.Models["Big Crate"] = "models/props_junk/wood_crate002a.mdl"

if !SinglePlayer() then return end

function GM.MapEditor.OpenMapEditor()
	local frmMapEditorFrame = vgui.Create("DFrame")
	frmMapEditorFrame:SetPos(50, 50)
	frmMapEditorFrame:SetSize(325, 450)
	frmMapEditorFrame:SetTitle("Map Editor")
	frmMapEditorFrame:SetVisible(true)
	frmMapEditorFrame:SetDraggable(true)
	frmMapEditorFrame:ShowCloseButton(true)
	frmMapEditorFrame:MakePopup()
	frmMapEditorFrame.btnClose.DoClick = function(btn)
		frmMapEditorFrame:Close()
		GAMEMODE.MapEditor.Open = false
	end
	
	local pnlControlsList = vgui.Create("DPanelList", frmMapEditorFrame)
	pnlControlsList:SetPos(5, 55)
	pnlControlsList:SetSize(frmMapEditorFrame:GetWide() - 10, frmMapEditorFrame:GetTall() - 60)
	pnlControlsList:EnableHorizontal(false)
	pnlControlsList:EnableVerticalScrollbar(true)
	pnlControlsList:SetSpacing(5)
	pnlControlsList:SetPadding(5)
	
	local mchObjectSetList = vgui.Create("DMultiChoice", frmMapEditorFrame)
	local mchObjects = vgui.Create("DMultiChoice", frmMapEditorFrame)
	GAMEMODE.MapEditor.ObjectsList = mchObjects
	
	mchObjectSetList:SetPos(75, 30)
	mchObjectSetList:SetSize(frmMapEditorFrame:GetWide() - 135, 20)
	for key, sets in pairs(GAMEMODE.MapEditor.ObjectSets) do mchObjectSetList:AddChoice(key) end
	mchObjectSetList.OnSelect = function(index, value, data)
		GAMEMODE.MapEditor.CurrentObjectSet = GAMEMODE.MapEditor.ObjectSets[data]
		GAMEMODE.MapEditor.CurrentObjectNum = 0
		GAMEMODE.MapEditor.UpatePanel()
		pnlControlsList:Clear()
	end
	
	mchObjects:SetPos(frmMapEditorFrame:GetWide() - 55, 30)
	mchObjects:SetSize(50, 20)
	mchObjects.OnSelect = function(index, value, data)
		GAMEMODE.MapEditor.CurrentObjectNum = tonumber(value)
		if GAMEMODE.MapEditor.CurrentObjectSet == GAMEMODE.MapEntities.NPCSpawnPoints then
			GAMEMODE.MapEditor.AddSpawnPointControls(pnlControlsList)
		elseif GAMEMODE.MapEditor.CurrentObjectSet == GAMEMODE.MapEntities.WorldProps then
			GAMEMODE.MapEditor.AddWorldPropControls(pnlControlsList)
		end
		LocalPlayer():SetEyeAngles((GAMEMODE.MapEditor.CurrentObjectSet[tonumber(value)].Postion - LocalPlayer():GetShootPos()):Angle())
	end

	local btnSaveButton = vgui.Create("DImageButton", frmMapEditorFrame)
	btnSaveButton:SetMaterial("vgui/spawnmenu/save")
	btnSaveButton:SetToolTip("Save Map")
	btnSaveButton.DoClick = function(btnSaveButton) RunConsoleCommand("UD_Dev_EditMap_SaveMap") end
	btnSaveButton:SetPos(7, 32)
	btnSaveButton:SetSize(16, 16)
	
	local btnNewSpawnButton = vgui.Create("DImageButton", frmMapEditorFrame)
	btnNewSpawnButton:SetMaterial("gui/silkicons/brick_add")
	btnNewSpawnButton:SetToolTip("New Object")
	btnNewSpawnButton.DoClick = function(btnNewSpawnButton)
		GAMEMODE.MapEditor.CurrentObjectNum = #GAMEMODE.MapEditor.CurrentObjectSet + 1
		if GAMEMODE.MapEditor.CurrentObjectSet == GAMEMODE.MapEntities.NPCSpawnPoints then
			RunConsoleCommand("UD_Dev_EditMap_CreateSpawnPoint")
		elseif GAMEMODE.MapEditor.CurrentObjectSet == GAMEMODE.MapEntities.WorldProps then
			RunConsoleCommand("UD_Dev_EditMap_CreateWorldProp")
		end
	end
	btnNewSpawnButton:SetPos(32, 32)
	btnNewSpawnButton:SetSize(16, 16)
	
	local btnRemoveButton = vgui.Create("DImageButton", frmMapEditorFrame)
	btnRemoveButton:SetMaterial("gui/silkicons/check_off")
	btnRemoveButton:SetToolTip("Remove Object")
	btnRemoveButton.DoClick = function(btnRemoveButton)
		pnlControlsList:Clear()
		if GAMEMODE.MapEditor.CurrentObjectSet == GAMEMODE.MapEntities.NPCSpawnPoints then
			RunConsoleCommand("UD_Dev_EditMap_RemoveSpawnPoint", GAMEMODE.MapEditor.CurrentObjectNum)
		elseif GAMEMODE.MapEditor.CurrentObjectSet == GAMEMODE.MapEntities.WorldProps then
			RunConsoleCommand("UD_Dev_EditMap_RemoveWorldProp", GAMEMODE.MapEditor.CurrentObjectNum)
		end
	end
	btnRemoveButton:SetPos(57, 32)
	btnRemoveButton:SetSize(16, 16)
	
	GAMEMODE.MapEditor.Open = true
end
concommand.Add("UD_Dev_EditMap", function() GAMEMODE.MapEditor.OpenMapEditor() end)

function GM.MapEditor.UpatePanel()
	if GAMEMODE.MapEditor.Open then
		GAMEMODE.MapEditor.ObjectsList:Clear()
		for key, spawnpoints in pairs(GAMEMODE.MapEditor.CurrentObjectSet) do
			GAMEMODE.MapEditor.ObjectsList:AddChoice(key)
		end
		if GAMEMODE.MapEditor.CurrentObjectNum > 0 && GAMEMODE.MapEditor.CurrentObjectSet[GAMEMODE.MapEditor.CurrentObjectNum] then
			GAMEMODE.MapEditor.ObjectsList:ChooseOptionID(GAMEMODE.MapEditor.CurrentObjectNum)
		end
	end
end

function GM.MapEditor.AddSpawnPointControls(pnlAddList)
	pnlAddList:Clear()
	local intSpawnKey = GAMEMODE.MapEditor.CurrentObjectNum
	local tblSpawnTable = GAMEMODE.MapEditor.CurrentObjectSet[intSpawnKey]
	local strNPCName = tblSpawnTable.NPC or "zombie"
	local intLevel = tblSpawnTable.Level or 5
	local intSpawnTime = tblSpawnTable.SpawnTime or 0
	
	local mchNPCTypes = vgui.Create("DMultiChoice")
	local intID = 1
	for key, npctable in pairs(GAMEMODE.DataBase.NPCs) do
		mchNPCTypes:AddChoice(key)
		if key == tblSpawnTable.NPC then mchNPCTypes:ChooseOptionID(intID) end
		intID = intID + 1
	end
	mchNPCTypes.OnSelect = function(index, value, data)
		strNPCName = data
	end
	pnlAddList:AddItem(mchNPCTypes)
	
	local nmsLevel = vgui.Create("DNumSlider")
	nmsLevel:SetText("Level")
	nmsLevel:SetMin(0)
	nmsLevel:SetMax(50)
	nmsLevel:SetDecimals(0)
	nmsLevel.ValueChanged = function(self, value) intLevel = value end
	nmsLevel.UpdateSlider = function(intNewValue)
		nmsLevel:SetValue(intNewValue)
		nmsLevel.Slider:SetSlideX(nmsLevel.Wang:GetFraction())
	end
	nmsLevel.UpdateSlider(intLevel)
	pnlAddList:AddItem(nmsLevel)
	
	local nmsSpawnTime = vgui.Create("DNumSlider")
	nmsSpawnTime:SetText("Spawn Time")
	nmsSpawnTime:SetMin(0)
	nmsSpawnTime:SetMax(120)
	nmsSpawnTime:SetDecimals(0)
	nmsSpawnTime.ValueChanged = function(self, value) intSpawnTime = value end
	nmsSpawnTime.UpdateSlider = function(intNewValue)
		nmsSpawnTime:SetValue(intNewValue)
		nmsSpawnTime.Slider:SetSlideX(nmsSpawnTime.Wang:GetFraction())
	end
	nmsSpawnTime.UpdateSlider(intSpawnTime)
	pnlAddList:AddItem(nmsSpawnTime)
	
	local btnUpdateServer = vgui.Create("DButton")
	btnUpdateServer:SetText("Update Server")
	btnUpdateServer.DoClick = function(btnUpdateServer)
		RunConsoleCommand("UD_Dev_EditMap_UpdateSpawnPoint", intSpawnKey, strNPCName, intLevel, intSpawnTime)
	end
	pnlAddList:AddItem(btnUpdateServer)
end

function GM.MapEditor.AddWorldPropControls(pnlAddList)
	pnlAddList:Clear()
	local intSpawnKey = GAMEMODE.MapEditor.CurrentObjectNum
	local tblSpawnTable = GAMEMODE.MapEditor.CurrentObjectSet[intSpawnKey]
	local strModel = tblSpawnTable.Entity:GetModel() or "models/props_junk/garbage_metalcan001a.mdl"
	local intOffset = tblSpawnTable.Entity.Offset or 1
	
	local mchModels = vgui.Create("DMultiChoice")
	local intID = 1
	for key, model in pairs(GAMEMODE.MapEditor.Models) do
		mchModels:AddChoice(key)
		if model == strModel then
			mchModels:ChooseOptionID(intID)
		end
		intID = intID + 1
	end
	mchModels.OnSelect = function(index, value, data)
		strModel = GAMEMODE.MapEditor.Models[data]
	end
	pnlAddList:AddItem(mchModels)
	

	local wppOffset = vgui.Create("DNumSlider")
	wppOffset:SetText("Offset")
	wppOffset:SetMin(-100)
	wppOffset:SetMax(100)
	wppOffset:SetDecimals(0)
	wppOffset.ValueChanged = function(self, value) intOffset = value end
	wppOffset.UpdateSlider = function(intNewValue)
		wppOffset:SetValue(intNewValue)
		wppOffset.Slider:SetSlideX(wppOffset.Wang:GetFraction())
	end
	wppOffset.UpdateSlider(intOffset)
	pnlAddList:AddItem(wppOffset)
	
	local btnUpdateServer = vgui.Create("DButton")
	btnUpdateServer:SetText("Update Server")
	btnUpdateServer.DoClick = function(btnUpdateServer)
		RunConsoleCommand("UD_Dev_EditMap_UpdateWorldProp", intSpawnKey, strModel, intOffset )
	end
	pnlAddList:AddItem(btnUpdateServer)
end

hook.Add("HUDPaint", "DrawMapObjects", function()
	if GAMEMODE.MapEditor.Open then
		for key, object in pairs(GAMEMODE.MapEditor.CurrentObjectSet or {}) do
			local intPosX, intPosY = object.Postion:ToScreen().x, object.Postion:ToScreen().y
			local clrDrawColor = clrWhite
			if GAMEMODE.MapEditor.CurrentObjectNum == key then clrDrawColor = clrBlue end
			draw.SimpleTextOutlined(key, "UiBold", intPosX, intPosY, clrDrawColor, 1, 1, 1, Color(0, 0, 0, 255))
		end
	end
end)

hook.Add("GUIMouseReleased", "TurnEditorCamGUIMouseReleased", function(mousecode)
	if GAMEMODE.MapEditor.Open then
		LocalPlayer():SetEyeAngles((LocalPlayer():GetEyeTrace().HitPos - LocalPlayer():GetShootPos()):Angle())
	end
end)