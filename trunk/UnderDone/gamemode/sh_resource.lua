local function ProcessFolder(strLocation, boolProssesSubFolder, fncCallBack)
	for _, fileName in pairs(file.Find(strLocation .. '*')) do
		if !string.find(strLocation, ".svn") then
		
			if (boolProssesSubFolder or false) && file.IsDir(strLocation .. fileName) then
				ProcessFolder(strLocation .. fileName .. '/', true, fncCallBack)
			else
				if !string.find(strLocation, '.db') then
					fncCallBack(fileName)
				end
			end
			
		end
	end
end

if SERVER then
	ProcessFolder('../gamemodes/underdone/content/materials/', true, function(fileName)
		resource.AddFile("materials/" ..fileName)
	end)
		
	local strPath = "gamemodes/underdone/gamemode/menutabs/"
	for _, v in pairs(file.FindInLua(strPath .. "*.lua")) do
		AddCSLuaFile(strPath .. v)
		print(v)
	end
	local strPath = "gamemodes/underdone/gamemode/customvgui/"
	for _, v in pairs(file.FindInLua(strPath .. "*.lua")) do
		AddCSLuaFile(strPath .. v)
	end
	local strPath = "gamemodes/underdone/gamemode/itemdata/"
	for _, v in pairs(file.FindInLua(strPath .. "*.lua")) do
		AddCSLuaFile(strPath .. v)
		include(strPath .. v)
	end
end

if !SERVER then
	local strPath = "gamemodes/underdone/gamemode/menutabs/"
	for _, v in pairs(file.FindInLua(strPath .. "*.lua")) do
		include(strPath .. v)
	end
	local strPath = "gamemodes/underdone/gamemode/customvgui/"
	for _, v in pairs(file.FindInLua(strPath .. "*.lua")) do
		include(strPath .. v)
	end
	local strPath = "gamemodes/underdone/gamemode/itemdata/"
	for _, v in pairs(file.FindInLua(strPath .. "*.lua")) do
		include(strPath .. v)
	end
end

