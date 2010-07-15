PANEL = {}
PANEL.color = Color(50, 50, 50, 255)
local ccQuickPanelWidth = CreateClientConVar("cb_quickpanel_width", 200, true, true)

function PANEL:Init()
	self:SetSize(ScrW() * 0.97, ScrH() * 0.97)
	self:SetPos((ScrW() - self:GetWide()) / 2, (ScrH() - self:GetTall()) / 2)
	local intContextWidth = LocalPlayer():GetInfoNum("cb_quickpanel_width", 200)
	local intLibraryWidth = math.Clamp(self:GetWide() * 0.6, 250, 1000)
	
	self.frame = vgui.Create("DFrame")
	self.frame:SetTitle("")
	self.frame:SetVisible(true)
	self.frame:SetDraggable(false)
	self.frame:ShowCloseButton(false)
	self.frame.Paint = function() end
	self.frame:SetSize(self:GetSize())
	self.frame:MakePopup()
	
	self.LibraryPanel = vgui.Create("vgui_library", self.frame)
	self.LibraryPanel.Paint = function() draw.RoundedBox(4, 0, 0, self.LibraryPanel:GetWide(), self.LibraryPanel:GetTall(), self.color) end
	self.LibraryPanel:StretchToParent(0, 0, intContextWidth + 4, 0)
	
	self.TabSheet = vgui.Create("DPropertySheet")
	local tblLibrary = table.ClearKeys(table.Copy(library.GetLibrary()))
	table.SortByMember(tblLibrary, "Order", true)
	for strTabName, tblTabTable in pairs(tblLibrary) do
		local pnlNewTabPanel = tblTabTable.BuildFunction and tblTabTable.BuildFunction() or vgui.Create("DPanel")
		self.TabSheet:AddSheet(tblTabTable.Name, pnlNewTabPanel, tblTabTable.Icon, false, false, tblTabTable.ToolTip)
	end
	self.LibraryPanel:AddTabSheet(self.TabSheet)
	
	self.QuickPanel = vgui.Create("DPanelList", self.frame)
	self.QuickPanel:SetPadding(5)
	self.QuickPanel:EnableVerticalScrollbar(true)
	self.QuickPanel:SetSize(intContextWidth, self.frame:GetTall())
	self.ControlPanel = GAMEMODE:GetMainControlPanel()
	self.QuickPanel:AddItem(self.ControlPanel)
	
	self.MainDivider = vgui.Create("DHorizontalDivider", self.frame)
	self.MainDivider:SetLeft(self.LibraryPanel)
	self.MainDivider:SetRight(self.QuickPanel)
	self.MainDivider:SetRightMin(math.Clamp(self:GetWide() * 0.2, 50, 200))
	self.MainDivider:SetLeftMin(intLibraryWidth)
	self.MainDivider:SetDividerWidth(4)
	self.MainDivider:SetLeftWidth(self.frame:GetWide() - self.QuickPanel:GetWide() - 4)
end

function PANEL:Think()
	--self:PerformLayout()
end

function PANEL:PerformLayout()
	self.frame:SetPos(self:GetPos())
	self.frame:SetSize(self:GetSize())
	self.ControlPanel:StretchToParent(5, nil, 5, nil)
	--self.QuickPanel:SetPos((self.LibraryPanel:GetWide() + 4), 0)
	
	self.MainDivider:SetSize(self.frame:GetWide(), self.frame:GetTall())
end
vgui.Register("siltboxmenu", PANEL, "Panel")


--concommand.Add("silt_openspawnmenu", function() vgui.Create("siltboxmenu") end)
--self.Library = vgui.Create("vgui_library", self.frame)
--[[
self.contentPanel = vgui.Create("DPanel", self.frame)
self.contentPanel.Paint = function() draw.RoundedBox(2, 0, 0, self.contentPanel:GetWide(), self.contentPanel:GetTall(), self.color) end
self.list = vgui.Create("DListView", self.contentPanel)
self.list:SetDataHeight(13)
self.list:AddColumn("Name")
self.list:AddColumn("Desc")
self.list.currentFolder = PropManafest
self.list.DoDoubleClick = function(list, rowNumber, line)
surface.PlaySound("ui/buttonclickrelease.wav")
if line.listItem.type == "prop" then
RunConsoleCommand("silt_spawnobject", line.listItem.model)
if !table.HasValue(self.quickListObjects, line.listItem.model) then
table.insert(self.quickListObjects, line.listItem.model)
self:AddItem(self.QuickPanel, line.listItem)
end
elseif line.listItem.type == "back" then
self:BackFolder()
else
self:OpenFolder(line.listItem)
end
end
self.searchEntry = vgui.Create("DTextEntry", self.contentPanel)
self.searchEntry:SetText("Search ...")
self.searchEntry.OnTextChanged = function() 
if self.searchEntry:GetValue():len() >= 3 then
self:LoadList(DoModelSearch(self.searchEntry:GetValue()))
end
end]]



