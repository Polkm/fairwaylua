local tblSharedFolders = {}
tblSharedFolders[1] = "underdone/gamemode/itemdata/"

local tblClientFolders = {}
tblClientFolders[1] = "underdone/gamemode/menutabs/"
tblClientFolders[2] = "underdone/gamemode/customvgui/"


if SERVER then
	local strPath = "underdone/content/materials/gui/"
	for _, file in pairs(file.FindInLua(strPath .. "*")) do
		if string.find(file, ".vmt") or string.find(file, ".vtf") then
			strPath = string.Replace(strPath, "underdone/content/", "")
			resource.AddFile(strPath ..file)
		end
	end
	local strPath = "underdone/content/materials/icons/"
	for _, file in pairs(file.FindInLua(strPath .. "*")) do
		if string.find(file, ".vmt") or string.find(file, ".vtf") then
			strPath = string.Replace(strPath, "underdone/content/", "")
			resource.AddFile(strPath .. file)
		end
	end
	
	local tblTotalFolder = {}
	table.Add(tblTotalFolder, tblSharedFolders)
	table.Add(tblTotalFolder, tblClientFolders)
	for _, path in pairs(tblTotalFolder) do
		for _, file in pairs(file.FindInLua(path .. "*.lua")) do
			if table.HasValue(tblClientFolders, path) or table.HasValue(tblSharedFolders, path) then
				AddCSLuaFile(path .. file)
			end
			if table.HasValue(tblSharedFolders, path) then
				include(path .. file)
			end
		end
	end
end

if !SERVER then
	local tblTotalFolder = {}
	table.Add(tblTotalFolder, tblSharedFolders)
	table.Add(tblTotalFolder, tblClientFolders)
	for _, path in pairs(tblTotalFolder) do
		for _, file in pairs(file.FindInLua(path .. "*.lua")) do
			include(path .. file)
		end
	end
end

