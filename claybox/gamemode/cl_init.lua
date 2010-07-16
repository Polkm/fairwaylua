require("datastream")
---------------------
include('shared.lua')
---------------------
siltBoxMenu = nil
local pnlControlPanel = nil
---------------------
GM.ColorPallet = {}
GM.ColorPallet["Light Blue"] = Color(195, 217, 255, 255)
GM.ColorPallet["Blue"] = Color(0, 169, 255, 255)
GM.ColorPallet["Green"] = Color(86, 239, 35, 255)
GM.ColorPallet["Mint"] = Color(205, 235, 139, 255)
GM.ColorPallet["Red"] = Color(176, 43, 44, 255)
GM.ColorPallet["Orange"] = Color(255, 116, 0, 255)
GM.ColorPallet["Yellow"] = Color(240, 240, 121, 255)
GM.ColorPallet["Light Tan"] = Color(249, 247, 237, 255)
GM.ColorPallet["Shadow"] = Color(54, 57, 61, 255)
---------------------

function GM:Initialize()
	spawnmenu.PopulateFromEngineTextFiles()
	hook.Call("AddSpawnListContentNodes", GAMEMODE)
	--PrintTable(spawnmenu.GetTools())
	
	--PrintTable(library.GetLibrary())
	--PrintTable(library.GetSpawnListSet())
	
	for strName, tblContent in pairs(library.GetSpawnListSet()) do
		if strName == "Tools" then
			--PrintTable(tblContent)
			--[[
			print(tblContent.Name)
			for strName, tblSpawnLsit in pairs(tblContent.SpawnLists) do
				print(" " .. tblSpawnLsit.Name)
				print("    " .. tblSpawnLsit.Icon)
				print("    " .. tblSpawnLsit.Order)
				print("    Amount " .. table.Count(tblSpawnLsit.Content))
			end]]
		end
		tblContent.Save()
	end
	
	--PrintTable(GAMEMODE.Library)
	--Sneeky Garry trying to keep props all for him self
	--PrintTable(spawnmenu.GetCreationTabs())
	
	
	--[[if !file.Exists("siltbox/propmanafest.txt") then
		PropManafestTimer = CurTime()
		BuildPropManafest(PropManafest, "models/", "models")
		timer.Simple(5, function() 
			local h_a, h_b, h_c = debug.gethook()
			debug.sethook()
				file.Write("siltbox/propmanafest.txt", glon.encode(PropManafest)) 
			--debug.sethook(h_a, h_b, h_c)
		end)
	else
		local h_d, h_e, h_f = debug.gethook()
		debug.sethook()
			PropManafest = glon.decode(file.Read("siltbox/propmanafest.txt"))
		--debug.sethook(h_d, h_e, h_f)
		--PropManafestTimer = CurTime()
		--BuildPropManafest(curTable, dir)
	end]]
end

function GM:OnSpawnMenuOpen()
	if !siltBoxMenu then
		siltBoxMenu = vgui.Create("siltboxmenu")
		siltBoxMenu:SetSize(ScrW() * 0.97, ScrH() * 0.97)
		siltBoxMenu:Center()
	end
	siltBoxMenu:SetVisible(true)
	siltBoxMenu.frame:SetVisible(true)
	RestoreCursorPosition()
end

function GM:OnSpawnMenuClose()
	RememberCursorPosition()
	siltBoxMenu:SetVisible(false)
	siltBoxMenu.frame:SetVisible(false)
	
	--gui.EnableScreenClicker(false)
end

function GM:GetMainControlPanel()
	pnlControlPanel = pnlControlPanel or vgui.Create("ControlPanel")
	return pnlControlPanel
end

function GetControlPanel(strName)
	return GAMEMODE:GetMainControlPanel()
end

function GM:OnUndo(strName, strCustomString)
	Msg(strCustomString or strName .." undone\n")

	--Fuck notifies they are fucking anoying
	--if !strCustomString then
		--self:AddNotify("#Undone_"..strName, NOTIFY_UNDO, 2)
	--else	
		--self:AddNotify(strCustomString, NOTIFY_UNDO, 2)
	--end
	
	surface.PlaySound( "buttons/button15.wav" )
end


--[[
function BuildPropManafest(curTable, dir, dirName)
	local files = file.Find("../" .. dir .. "*")
	--curTable = {}
	curTable.name = dirName
	curTable.type = "folder"
	curTable.content = {}
	for k, v in pairs(files) do
		if v:sub(-4, -1) == ".mdl" then
			if (!v:lower():find("_gestures") && 
				!v:lower():find("_anim") && 
				!v:lower():find("_postures") && 
				!v:lower():find("_intro") && 
				!v:lower():find("_gst") && 
				!v:lower():find("_pst") && 
				!v:lower():find("_shd") && 
				!v:lower():find("_ss") && 
				!v:lower():find("cs_fix") &&
				!v:lower():find("_anm")) then
				local newPropTable = {}
				newPropTable.name = v:sub(0, -5)
				newPropTable.create = (dir .. v):lower()
				newPropTable.type = "prop"
				table.insert(curTable.content, 0, newPropTable)
			end
		elseif v:sub(-4, -4) != '.' then
			PropManafestTimer = PropManafestTimer + 0.01
			local newFolderTable = {}
			newFolderTable.name = v
			newFolderTable.type = "folder"
			newFolderTable.content = {}
			newFolderTable.parentFolder = curTable
			table.insert(curTable.content, 0, newFolderTable)
			timer.Simple(PropManafestTimer - CurTime(), BuildPropManafest, newFolderTable, (dir..v.."/"), newFolderTable.name)
		end
	end
end

function DoModelSearch(str)
	str = str:lower()
	local ret = SearchFolder(PropManafest, str)
	return ret
end
function SearchFolder(tblSearchFolder, strSearchString)
	local ret = {}
	for k, v in pairs(tblSearchFolder.content) do
		if v.type != "folder" then
			if v.name:find(strSearchString) or
			v.create:find(strSearchString)
			then
				table.insert(ret, v)
			end
		elseif v.type == "folder" then
			table.Add(ret, SearchFolder(v, strSearchString))
		end
	end
	return ret
end

]]