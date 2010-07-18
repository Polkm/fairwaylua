local PANEL = {}
PANEL.Catagories = nil
function PANEL:Init()
	self.Topbar = vgui.Create("DPanel", self)
	self.Topbar.Paint = function() draw.RoundedBox(4, 0, 0, self.Topbar:GetWide(), self.Topbar:GetTall(), Color(100, 100, 100, 255)) end
	
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
	self.ContentList:SetSpacing(4)
	self.ContentList:EnableVerticalScrollbar(true)
end

function PANEL:BuildList(tblCatagories)
	self.Catagories = self.Catagories or tblCatagories
	self.ContentList:Clear(true)
	for strCatagoryName, tblCatagoryAreas in pairs(self.Catagories) do
		
		local pnlSpawnListCategory = vgui.Create("FColapse")
		pnlSpawnListCategory:SetTall(50)
		pnlSpawnListCategory:SetExpanded(1)
		pnlSpawnListCategory:SetLabel(strCatagoryName)
		pnlSpawnListCategory.Contents:SetPadding(2)
		pnlSpawnListCategory.Contents:SetSpacing(2)
		pnlSpawnListCategory.Contents:EnableHorizontal(false)
		pnlSpawnListCategory:SetIcon(tblCatagoryAreas.Icon)
		
		for _, tblCatagoryItems in pairs(tblCatagoryAreas.Items) do
			local strAreaName = tblCatagoryItems.ItemName
			local strAreaPrintName = tblCatagoryItems.Text
			local strIcon = tblCatagoryItems.Icon
			if strAreaName == "Player" then strIcon = strIcon or "gui/silkicons/user" end
			if strAreaName == "User" then strIcon = strIcon or "gui/silkicons/user" end
			if strAreaName == "Admin" then strIcon = strIcon or "gui/silkicons/shield" end
			if strAreaName == "Performance" then strIcon = strIcon or "gui/silkicons/box" end
			if strAreaName == "Visuals" then strIcon = strIcon or "gui/silkicons/palette" end
			tblCatagoryItems.ItemName = nil
			tblCatagoryItems.Text = nil
			tblCatagoryItems.Icon = nil
			
			local pnlArea = vgui.Create("FColapse")
			pnlArea:SetTall(50)
			pnlArea:SetExpanded(0)
			pnlArea:SetPadding(0)
			pnlArea:SetLabel(strAreaPrintName)
			pnlArea.Contents:SetPadding(2)
			pnlArea.Contents:SetSpacing(2)
			pnlArea.Contents:EnableHorizontal(false)
			pnlArea:SetIcon(strIcon)
			pnlSpawnListCategory:AddContents(pnlArea)
			
			for _, tblItem in pairs(tblCatagoryItems) do
				local pnlControlPanel = vgui.Create("ControlPanel")
				pnlControlPanel:FillViaTable({Text = tblItem.Text, ControlPanelBuildFunction = tblItem.CPanelFunction, Controls = tblItem.Controls})
				pnlArea:AddContents(pnlControlPanel)
			end
		end
		self.ContentList:AddItem(pnlSpawnListCategory)
	end
	self:PerformLayout()
end

function PANEL:PerformLayout()
	self.Topbar:StretchToParent(0, 0, 0, 0)
	self.Topbar:SetTall(20)
	
	self.CollapseAll:SetPos(self.Topbar:GetWide() - 21, 2)
	self.CollapseAll:SetSize(16, 16)
	
	self.ContentList:StretchToParent(0, self.Topbar:GetTall() + 4, 0, 0)
	
	for _, pnlCategory in pairs(self.ContentList:GetItems()) do
		pnlCategory.Contents:StretchToParent(0, nil, 0, nil)
		pnlCategory:PerformLayout()
	end
end
local pnlCreationSheet = vgui.RegisterTable(PANEL, "Panel")

hook.Add("AddToolOptionCatagories", "AddToolOptionCatagoriesMain", function(tblOptions)
	library.AddTab("Options", "gui/silkicons/page_white_wrench", function()
		local ctrl = vgui.CreateFromTable(pnlCreationSheet)
		--ctrl:SetToolType(strName)
		PrintTable(tblOptions)
		ctrl:BuildList(tblOptions)
		return ctrl
	end, 100, "Options and Utilities")
end)