local PANEL = {}
PANEL.ViewType = "Icon"
PANEL.ViewSize = 1
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
				for _, pnlButton in pairs(pnlCategory.Contents:GetItems()) do
					if self.ViewType == "List" then
						pnlButton:SetSize(50 + (self.ViewSize * 20), 14 + (self.ViewSize * 2))
					elseif self.ViewType == "Detail" then
						pnlButton:SetTall(14 + (self.ViewSize * 2))
					else
						pnlButton:SetIconSize(16 + (self.ViewSize * 16))
					end
					pnlButton:InvalidateLayout()
				end
				if pnlCategory:GetExpanded() then
					pnlCategory.animSlide:Start(pnlCategory:GetAnimTime(), {From = pnlCategory:GetTall()})
					pnlCategory.animSlide:Start(pnlCategory:GetAnimTime(), {From = pnlCategory:GetTall()})
				end
			end
		end
		--self:PerformLayout()
		return true
	end
	return false
end

function PANEL:BuildSpawnButton(strSpawnItem)
	local tblSplitName = string.Explode("/", strSpawnItem)
	local strName = tblSplitName[#tblSplitName]
	strName = string.sub(strName, 1, string.len(strName) - 4)
	local spawnlistButton
	if self.ViewType == "List" or self.ViewType == "Detail" then
		spawnlistButton = vgui.Create("DButton")
		if self.ViewType == "List" then
			spawnlistButton:SetText(strName)
			spawnlistButton:SetSize(50 + (self.ViewSize * 20), 14 + (self.ViewSize * 2))
		else
			spawnlistButton:SetText(strName .. "    " .. strSpawnItem)
			spawnlistButton:SetTall(14 + (self.ViewSize * 2))
		end
	else
		spawnlistButton = vgui.Create("SpawnIcon")
		spawnlistButton:SetModel(strSpawnItem)
		spawnlistButton:SetIconSize(16 + (self.ViewSize * 16))
	end
	spawnlistButton.SpawnName = strSpawnItem
	spawnlistButton.DoClick = function()
		RunConsoleCommand("silt_spawnobject", strSpawnItem)
	end
	return spawnlistButton
end

function PANEL:BuildList()
	self.ContentList:Clear(true)
	local tblProps = library.GetSpawnListSet("Props")
	for strSpawnList, tblSpawnListTable in pairs(tblProps.SpawnLists) do
		local pnlSpawnListCategory = vgui.Create("DCollapsibleCategory")
		pnlSpawnListCategory:SetTall(50)
		pnlSpawnListCategory:SetExpanded(0)
		pnlSpawnListCategory:SetPadding(0)
		pnlSpawnListCategory:SetLabel(tblSpawnListTable.Name)
		pnlSpawnListCategory.SpawnList = true
		local lstSpawnList = vgui.Create("DPanelList")
		lstSpawnList:SetAutoSize(true)
		lstSpawnList:SetPadding(0)
		lstSpawnList:SetSpacing(0)
		if self.ViewType == "Detail" then
			lstSpawnList:EnableHorizontal(false)
		else
			lstSpawnList:EnableHorizontal(true)
		end
		lstSpawnList:EnableVerticalScrollbar(true)
		pnlSpawnListCategory:SetContents(lstSpawnList)
		pnlSpawnListCategory.LoadedSpawnShit = false
		pnlSpawnListCategory.Toggle = function(mcode)
			if !pnlSpawnListCategory.LoadedSpawnShit then
				for intKey, strSpawnItem in pairs(tblSpawnListTable.Content) do
					lstSpawnList:AddItem(self:BuildSpawnButton(strSpawnItem))
				end
				pnlSpawnListCategory.LoadedSpawnShit = true
			end
			pnlSpawnListCategory:SetExpanded(!pnlSpawnListCategory:GetExpanded())
			pnlSpawnListCategory.animSlide:Start(pnlSpawnListCategory:GetAnimTime(), {From = pnlSpawnListCategory:GetTall()})
			pnlSpawnListCategory:InvalidateLayout(true)
			pnlSpawnListCategory:GetParent():InvalidateLayout()
			pnlSpawnListCategory:GetParent():GetParent():InvalidateLayout()
			local cookie = '1'
			if !pnlSpawnListCategory:GetExpanded() then cookie = '0' end
			pnlSpawnListCategory:SetCookie("Open", cookie)
		end
		self.ContentList:AddItem(pnlSpawnListCategory)
	end
	self.ContentList:InvalidateLayout()
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
local function fncCreateContentPanel()
	local ctrl = vgui.CreateFromTable(pnlCreationSheet)
	return ctrl
end

local function fncAddToSpawnLists(tblContentNode)
	for strSpawnListName, tblModels in pairs(spawnmenu.GetPropTable()) do
		if !tblContentNode.SpawnLists[strSpawnListName] then
			tblContentNode.SpawnLists[strSpawnListName] = {}
			tblContentNode.SpawnLists[strSpawnListName].Name = strSpawnListName
			tblContentNode.SpawnLists[strSpawnListName].Icon = "DefaultIcon"
			tblContentNode.SpawnLists[strSpawnListName].Order = table.Count(tblContentNode.SpawnLists)
			tblContentNode.SpawnLists[strSpawnListName].Content = tblModels
			tblContentNode.Modified[strSpawnListName] = true
		end
	end
end

hook.Add("AddSpawnListContentNodes", "AddPropContent", function()
	library.AddTab("Props", "gui/silkicons/application_view_tile", fncCreateContentPanel, -10, nil)
	library.AddSpawnListSet("Props", fncAddToSpawnLists)
end)