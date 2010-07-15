local PANEL = {}
PANEL.ToolType = "Tools"
PANEL.ViewType = "List"
PANEL.ViewSize = 3
function PANEL:Init()
	self.Topbar = vgui.Create("DPanel", self)
	self.Topbar.Paint = function() draw.RoundedBox(4, 0, 0, self.Topbar:GetWide(), self.Topbar:GetTall(), Color(100, 100, 100, 255)) end
	
	self.ViewOptions = vgui.Create("DImageButton", self.Topbar)
	self.ViewOptions:SetImage("gui/silkicons/application_view_detail")
	self.ViewOptions:SetTooltip("View Type")
	self.ViewOptions.DoClick = function(btn) 	
		local menu = DermaMenu()
			menu:AddOption("Icons", function() self:SetViewType("Icon") end)
			menu:AddOption("List", function() self:SetViewType("List") end)
			menu:AddOption("Detail", function() self:SetViewType("Detail") end)
		menu:Open()
	end
	
	self.ViewSizer = vgui.Create("DImageButton", self.Topbar)
	self.ViewSizer:SetImage("gui/silkicons/application_form_magnify")
	self.ViewSizer:SetTooltip("View Size")
	self.ViewSizer.DoClick = function(btn) 	
		local menu = DermaMenu()
			menu:AddOption("Tiny", function() self:SetViewSize(1) end)
			menu:AddOption("Small", function() self:SetViewSize(2) end)
			menu:AddOption("Normal", function() self:SetViewSize(3) end)
			menu:AddOption("Large", function() self:SetViewSize(4) end)
			menu:AddOption("Too Big", function() self:SetViewSize(5) end)
		menu:Open()
	end
	
	self.CollapseAll = vgui.Create("DImageButton", self.Topbar)
	self.CollapseAll:SetImage("gui/silkicons/application_put")
	self.CollapseAll:SetTooltip("Collapse All")
	self.CollapseAll.DoClick = function(btn)
		for _, pnlCategory in pairs(self.ContentList:GetItems()) do
			if (pnlCategory.SpawnList or pnlCategory.Category) and pnlCategory:GetExpanded() then
				pnlCategory:Toggle()
			end
		end
	end
	
	self.ContentList = vgui.Create("DPanelList", self)	
	self.ContentList:SetPadding(4)
	self.ContentList:SetSpacing(2)
	self.ContentList:EnableVerticalScrollbar(true)
end

function PANEL:SetToolType(strToolType)
	self.ToolType = strToolType or "Tools"
	self:BuildList()
end

function PANEL:SetViewType(strType)
	if self.ViewType != strType then
		self.ViewType = strType
		self:BuildList()
		return true
	end
	return false
end

function PANEL:SetViewSize(intSize)
	if self.ViewSize != intSize then
		self.ViewSize = intSize
		for _, pnlCategory in pairs(self.ContentList:GetItems()) do
			if pnlCategory.SpawnList then
				if self.ViewType == "List" or self.ViewType == "Detail" then
					pnlCategory.Contents:SetPadding(0)
					pnlCategory.Contents:SetSpacing(0)
				else
					pnlCategory.Contents:SetPadding(2)
					pnlCategory.Contents:SetSpacing(2)
				end
				for _, pnlButton in pairs(pnlCategory.Contents:GetItems()) do
					if self.ViewType == "List" then
						pnlButton:SetSize(80 + (self.ViewSize * 30), 14 + (self.ViewSize * 2))
					elseif self.ViewType == "Detail" then
						pnlButton:SetTall(14 + (self.ViewSize * 2))
					else
						pnlButton:SetSize(16 + (self.ViewSize * 16), 16 + (self.ViewSize * 16))
					end
					pnlButton:InvalidateLayout()
				end
				pnlCategory:InvalidateLayout()
			end
		end
		self.ContentList:InvalidateLayout()
		return true
	end
	return false
end

function PANEL:BuildSpawnButton(strSpawnItem)
	local tblTools = library.GetSpawnListSet(self.ToolType)
	local tblItemInfo = tblTools.ItemInfo[strSpawnItem]
	local strName = tblItemInfo.Name
	--Most retarded work around EVER
	local lblRetaredeLabel = vgui.Create("DTextEntry")
	lblRetaredeLabel:SetText("#Tool_" .. strSpawnItem .. "_desc")
	local strDesc = lblRetaredeLabel:GetValue()
	lblRetaredeLabel:Remove()
	local spawnlistButton
	if self.ViewType == "List" or self.ViewType == "Detail" then
		spawnlistButton = vgui.Create("DButton")
		if self.ViewType == "List" then
			spawnlistButton:SetText(strName)
			spawnlistButton:SetSize(80 + (self.ViewSize * 30), 14 + (self.ViewSize * 2))
		else
			spawnlistButton:SetText(strName .. " - " .. strDesc)
			spawnlistButton:SetTall(14 + (self.ViewSize * 2))
		end
	else
		spawnlistButton = vgui.Create("DImageButton")
		spawnlistButton:SetMaterial(tblItemInfo.Thumbnail)
		spawnlistButton:SetSize(16 + (self.ViewSize * 16), 16 + (self.ViewSize * 16))
	end
	spawnlistButton:SetToolTip(strName .. "\n" .. strDesc)
	spawnlistButton.SpawnName = strSpawnItem
	spawnlistButton.DoClick = function()
		local pnlControlPanel = GAMEMODE:GetMainControlPanel()
		pnlControlPanel:ClearControls()
		pnlControlPanel:FillViaTable({Text = strName, ControlPanelBuildFunction = tblItemInfo.CPanelFunction, Controls = tblItemInfo.Controls})
		RunConsoleCommand("gmod_tool", strSpawnItem)
	end
	return spawnlistButton
end

function PANEL:BuildList()
	self.ContentList:Clear(true)
	local tblProps = library.GetSpawnListSet(self.ToolType)
	for strSpawnList, tblSpawnListTable in pairs(tblProps.SpawnLists) do
		local pnlSpawnListCategory = vgui.Create("DCollapsibleCategory")
		pnlSpawnListCategory:SetTall(50)
		pnlSpawnListCategory:SetExpanded(1)
		pnlSpawnListCategory:SetPadding(0)
		pnlSpawnListCategory:SetLabel(tblSpawnListTable.Name)
		pnlSpawnListCategory.SpawnList = true
		local lstSpawnList = vgui.Create("DPanelList")
		lstSpawnList:SetAutoSize(true)
		if self.ViewType == "List" or self.ViewType == "Detail" then
			lstSpawnList:SetPadding(0)
			lstSpawnList:SetSpacing(0)
		else
			lstSpawnList:SetPadding(2)
			lstSpawnList:SetSpacing(2)
		end
		if self.ViewType == "Detail" then
			lstSpawnList:EnableHorizontal(false)
		else
			lstSpawnList:EnableHorizontal(true)
		end
		lstSpawnList:EnableVerticalScrollbar(true)
		pnlSpawnListCategory:SetContents(lstSpawnList)
		for intKey, strSpawnItem in pairs(tblSpawnListTable.Content) do
			lstSpawnList:AddItem(self:BuildSpawnButton(strSpawnItem))
		end
		self.ContentList:AddItem(pnlSpawnListCategory)
	end
	self:PerformLayout()
end

function PANEL:PerformLayout()
	self.Topbar:StretchToParent(0, 0, 0, 0)
	self.Topbar:SetTall(20)
	self.ViewOptions:SetPos(5, 2)
	self.ViewOptions:SetSize(16, 16)
	self.ViewSizer:SetPos(10 + self.ViewOptions:GetWide(), 2)
	self.ViewSizer:SetSize(16, 16)
	self.CollapseAll:SetPos(self.Topbar:GetWide() - 21, 2)
	self.CollapseAll:SetSize(16, 16)
	
	self.ContentList:StretchToParent(0, self.Topbar:GetTall() + 4, 0, 0)
	
	for _, pnlCategory in pairs(self.ContentList:GetItems()) do
		pnlCategory.Contents:StretchToParent(0, nil, 0, nil)
		if self.ViewType == "Detail" then
			for _, pnlSpawnItem in pairs(pnlCategory.Contents:GetItems()) do
				pnlSpawnItem:StretchToParent(0, nil, 0, nil)
			end
		end
	end
end
local pnlCreationSheet = vgui.RegisterTable(PANEL, "Panel")


local function fncAddSpawnListContentToolsTab(strName, strIcon, intOrder, strToolTip, tblTools)
	if strName == "Main" then strName = "Tools" end
	local tblCatagories = {}
	local tblCatagoriesInfo = {}
	local fncAddFunction = function(tblContentNode)
		for _, tblCatigory in pairs(tblTools) do
			local strCatagoryName = tblCatigory.ItemName
			local strCatagoryPrintName = tblCatigory.Text
			tblCatigory.ItemName = nil
			tblCatigory.Text = nil
			for _, tblTool in pairs(tblCatigory) do
				local strItemName = tblTool.ItemName
				--tblTool.ItemName = nil
				if string.find(tblTool.Command, "gmod_tool") then
					local boolAlreadyPlaced = false
					for strListName, tblContent in pairs(tblContentNode.SpawnLists) do
						if table.HasValue(tblContent.Content, strItemName) then boolAlreadyPlaced = true break end
					end
					if !boolAlreadyPlaced then
						if !tblContentNode.SpawnLists[strCatagoryName] then
							tblContentNode.SpawnLists[strCatagoryName] = {}
							tblContentNode.SpawnLists[strCatagoryName].Name = strCatagoryName
							tblContentNode.SpawnLists[strCatagoryName].Icon = "DefaultIcon"
							tblContentNode.SpawnLists[strCatagoryName].Order = table.Count(tblContentNode.SpawnLists)
							tblContentNode.SpawnLists[strCatagoryName].Content = {}
							tblContentNode.Modified[strCatagoryName] = true
						end
						table.insert(tblContentNode.SpawnLists[strCatagoryName].Content, strItemName)
					end
					tblTool.Name = tblTool.Text
					tblTool.Icon = tblTool.Icon or "VGUI/swepicon"
					tblTool.Thumbnail = tblTool.Thumbnail or "VGUI/swepicon"
					tblTool.Access = tblTool.Access or "Public"
					tblTool.Text = nil
					tblContentNode.ItemInfo[strItemName] = tblTool
				else
					if !tblCatagories[strCatagoryName] then
						tblCatagories[strCatagoryName] = {}
						tblCatagories[strCatagoryName].Name = strCatagoryName
						tblCatagories[strCatagoryName].Icon = "DefaultIcon"
						tblCatagories[strCatagoryName].Order = table.Count(tblCatagories)
						tblCatagories[strCatagoryName].Content = {}
					end
					table.insert(tblCatagories[strCatagoryName].Content, strItemName)
					tblTool.Name = tblTool.Text
					tblTool.Icon = tblTool.Icon or "VGUI/swepicon"
					tblTool.Thumbnail = tblTool.Thumbnail or "VGUI/swepicon"
					tblTool.Access = tblTool.Access or "Public"
					tblTool.Text = nil
					tblCatagoriesInfo[strItemName] = tblTool
				end
			end
		end
	end
	library.AddTab(strName, strIcon, function()
		local ctrl = vgui.CreateFromTable(pnlCreationSheet)
		ctrl:SetToolType(strName)
		return ctrl
	end, intOrder, strToolTip)
	library.AddSpawnListSet(strName, fncAddFunction)
end

hook.Add("AddSpawnListContentNodes", "AddToolTabs", function()
	hook.Call("AddToolMenuTabs", GAMEMODE)
	hook.Call("PopulateToolMenu", GAMEMODE)
	--Add all the custom tool tabs
	for _, tblToolTab in pairs(spawnmenu.GetTools()) do
		if tblToolTab.Name != "Utilities" and tblToolTab.Name != "Options" and tblToolTab.Name != "PostProcessing" then
			fncAddSpawnListContentToolsTab(tblToolTab.Name, tblToolTab.Icon, 0, nil, tblToolTab.Items)
		end
	end
end)