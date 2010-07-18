local table 	= table
local ipairs 	= ipairs
local debug 	= debug
local pairs		= pairs
local ipairs	= ipairs
local file		= file
local KeyValuesToTable = KeyValuesToTable

local print = print
local PrintTable = PrintTable
local MsgN = MsgN

module("spawnmenu")

function AddToolCategory(strTab, RealName, PrintName, strIcon)
	local tblTab = GetToolMenu(strTab)
	--Does this category already exist?
	for _, tblCatagory in ipairs(tblTab) do
		if tblCatagory.Text == PrintName then return end
		if tblCatagory.ItemName == RealName then return end
	end
	table.insert(tblTab, {Text = PrintName, ItemName = RealName, Icon = strIcon})
end

function AddToolMenuOption(tab, category, itemname, text, command, controls, cpanelfunction, TheTable)
	local tblMenu = GetToolMenu(tab)
	local tblCategoryTable = nil
	for k, v in ipairs(tblMenu) do
		if ( v.ItemName && v.ItemName == category ) then tblCategoryTable = v break end
	end
	
	--No table found.. lets create one
	if !tblCategoryTable  then
		tblCategoryTable = { Text = "#"..category, ItemName = category }
		table.insert( tblMenu, tblCategoryTable )
	end
	
	TheTable = TheTable or {}
	
	TheTable.ItemName = itemname
	TheTable.Text = text
	TheTable.Command = command
	TheTable.Controls = controls
	TheTable.CPanelFunction = cpanelfunction
	
	table.insert(tblCategoryTable, TheTable)
	
	// Keep the table sorted
	table.SortByMember( tblCategoryTable, "Text", true )
end