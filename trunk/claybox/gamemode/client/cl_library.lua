local string 	= string
local table 	= table
local debug 	= debug
local pairs		= pairs
local file		= file
local glon		= glon
local print		= print
local PrintTable = PrintTable

local Library = {}
Library.Tabs = {}
Library.SpawnListSets = {}

--local h_a, h_b, h_c = debug.gethook()
--debug.sethook()

module("library")

function AddTab(strName, strIcon, fncBuildMenu, intOrder, strToolTip)
	local tblNewTab = {}
	tblNewTab.Name = strName
	tblNewTab.Icon = strIcon
	tblNewTab.BuildFunction = fncBuildMenu or function() end
	tblNewTab.Order = intOrder or table.Count(Library.Tabs) + 1
	tblNewTab.ToolTip = strToolTip
	Library.Tabs[strName] = tblNewTab
	return Library.Tabs[strName]
end

function AddSpawnListSet(strName, fncAddFunction)
	local strFolder = "claybox/" .. string.lower(strName)
	local tblNewSpawnListSet = {}
	tblNewSpawnListSet.SpawnLists = {}
	tblNewSpawnListSet.Modified = {}
	tblNewSpawnListSet.ItemInfo = {}
	tblNewSpawnListSet.ItemInfoModified = {}
	
	--Load spawnlists and call the custom add function to complete spawnlists
	local tblFiles = file.Find(strFolder .. "/spawnlists/*")
	for _, strFileName in pairs(tblFiles or {}) do
		local tblReadTable = glon.decode(file.Read((strFolder .. "/spawnlists/" .. strFileName):lower()))
		tblNewSpawnListSet.SpawnLists[tblReadTable.Name] = tblReadTable
		--print("Loading from polkmon " .. tblReadTable.Name)
	end
	if file.Exists(strFolder .. "/iteminfo.txt") then
		local tblReadTable = glon.decode(file.Read((strFolder .. "/iteminfo.txt"):lower()))
		tblNewSpawnListSet.ItemInfo = tblReadTable
	end
	if fncAddFunction then fncAddFunction(tblNewSpawnListSet) end
	
	--Make a save function for use later
	tblNewSpawnListSet.Save = function()
		for strSpawnListName, tblSpawnList in pairs(tblNewSpawnListSet.SpawnLists) do
			if tblNewSpawnListSet.Modified[strSpawnListName] then
				local tblSaveTable = table.Copy(tblSpawnList)
				file.Write(strFolder .. "/spawnlists/" .. string.gsub(string.gsub(string.gsub((strSpawnListName):lower(), "/", "[slash]"), ":", "[collin]"), "-", "[dash]") .. ".txt", glon.encode(tblSaveTable))
			end
		end
		if tblNewSpawnListSet.ItemInfo != {} then
			local tblSaveTable = {}
			for strName, tblInfo in pairs(tblNewSpawnListSet.ItemInfo) do
				if tblNewSpawnListSet.ItemInfoModified[strName] then
					tblSaveTable[strName] = {}
					tblSaveTable[strName].Name = tblInfo.Name
					tblSaveTable[strName].Icon = tblInfo.Icon
					tblSaveTable[strName].Thumbnail = tblInfo.Thumbnail
					tblSaveTable[strName].Access = tblInfo.Access
				end
			end
			file.Write(strFolder .. "/iteminfo.txt", glon.encode(tblSaveTable))
		end
		tblNewSpawnListSet.Modified = {}
		tblNewSpawnListSet.ItemInfoModified = {}
	end
	
	Library.SpawnListSets[strName] = tblNewSpawnListSet
	return Library.SpawnListSets[strName]
end

function GetLibrary(strContent)
	return strContent and Library.Tabs[strContent] or Library.Tabs
end
function GetSpawnListSet(strName)
	return strName and Library.SpawnListSets[strName] or Library.SpawnListSets
end
