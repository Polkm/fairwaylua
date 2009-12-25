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
		
	ProcessFolder('../gamemodes/UnderDone/gamemode/mainmenutabs/', false, function(fileName)
		AddCSLuaFile("mainmenutabs/" .. fileName)
		
	end)
	ProcessFolder('../gamemodes/UnderDone/gamemode/vguiobjects/', false, function(fileName)
		AddCSLuaFile("vguiobjects/" .. fileName)
	end)
	ProcessFolder('../gamemodes/UnderDone/gamemode/items/', false, function(fileName)
		AddCSLuaFile("items/" .. fileName)
		include("items/" .. fileName)
	end)
end

if !SERVER then
	
	ProcessFolder('../gamemodes/UnderDone/gamemode/mainmenutabs/', false, function(fileName)
		include("mainmenutabs/" .. fileName)
		print("included mainmenutabs/" .. fileName)
	end)
	ProcessFolder('../gamemodes/UnderDone/gamemode/vguiobjects/', false, function(fileName)
		include("vguiobjects/" .. fileName)
	end)
	ProcessFolder('../gamemodes/UnderDone/gamemode/items/', false, function(fileName)
		include("items/" .. fileName)
	end)
end

