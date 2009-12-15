local function ProcessFolder(strLocation, boolProssesSubFolder, fncCallBack)
	for _, fileName in pairs(file.Find(strLocation .. '*')) do
		if !string.find(strLocation, ".svn") then
		
			if (boolProssesSubFolder or false) && file.IsDir(strLocation .. fileName) then
				ProcessFolder(strLocation .. fileName .. '/', true, fncCallBack)
			else
				local strOurLocation = string.gsub(strLocation .. fileName, '../gamemodes/UnderDone/content/', '')
				if !string.find(strLocation, '.db') then
					fncCallBack(fileName)
				end
			end
			
		end
	end
end

if SERVER then
	ProcessFolder('../gamemodes/UnderDone/content/materials/', true, function(fileName)
		resource.AddFile("materials/" ..fileName)
	end)
		
	ProcessFolder('../gamemodes/UnderDone/gamemode/MainMenuTabs/', false, function(fileName)
		AddCSLuaFile("MainMenuTabs/" .. fileName)
	end)
	ProcessFolder('../gamemodes/UnderDone/gamemode/VGUIObjects/', false, function(fileName)
		AddCSLuaFile("VGUIObjects/" .. fileName)
	end)
	ProcessFolder('../gamemodes/UnderDone/gamemode/Items/', false, function(fileName)
		AddCSLuaFile("Items/" .. fileName)
		include("Items/" .. fileName)
	end)
end

if CLIENT then
	ProcessFolder('../gamemodes/UnderDone/gamemode/MainMenuTabs/', false, function(fileName)
		include("MainMenuTabs/" .. fileName)
	end)
	ProcessFolder('../gamemodes/UnderDone/gamemode/VGUIObjects/', false, function(fileName)
		include("VGUIObjects/" .. fileName)
	end)
	ProcessFolder('../gamemodes/UnderDone/gamemode/Items/', false, function(fileName)
		include("Items/" .. fileName)
	end)
end

