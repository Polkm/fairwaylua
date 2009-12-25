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
		
	ProcessFolder('../gamemodes/UnderDone/gamemode/menutabs/', false, function(fileName)
		AddCSLuaFile("menutabs/" .. fileName)
		
	end)
	ProcessFolder('../gamemodes/UnderDone/gamemode/customvgui/', false, function(fileName)
		AddCSLuaFile("customvgui/" .. fileName)
	end)
	ProcessFolder('../gamemodes/UnderDone/gamemode/itemdata/', false, function(fileName)
		AddCSLuaFile("itemdata/" .. fileName)
		include("itemdata/" .. fileName)
	end)
end

if !SERVER then
	
	ProcessFolder('../gamemodes/UnderDone/gamemode/menutabs/', false, function(fileName)
		include("menutabs/" .. fileName)
		print("included menutabs/" .. fileName)
	end)
	ProcessFolder('../gamemodes/UnderDone/gamemode/customvgui/', false, function(fileName)
		include("customvgui/" .. fileName)
	end)
	ProcessFolder('../gamemodes/UnderDone/gamemode/itemdata/', false, function(fileName)
		include("itemdata/" .. fileName)
	end)
end

