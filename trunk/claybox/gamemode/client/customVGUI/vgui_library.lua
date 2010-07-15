local PANEL = {}
PANEL.TabSheets = {}

function PANEL:Init()
end

function PANEL:AddTabSheet(pnlTabSheet)
	pnlTabSheet:SetParent(self)
	table.insert(self.TabSheets, pnlTabSheet)
	--[[if #self.TabSheets > 1 then
		local firstTabSheet = self.TabSheets[1]
		
		local divider = vgui.Create("DHorizontalDivider", self)
		divider:SetLeft(self.TabSheets[#self.TabSheets - 1])
		divider:SetRight(pnlTabSheet)
		divider:SetRightMin(200)
		divider:SetLeftMin(200)
		divider:SetDividerWidth(4)
		divider:SetLeftWidth(self.frame:GetWide() - self.quickList:GetWide() - 4)
	end]]
end

function PANEL:PerformLayout()
	if #self.TabSheets > 0 then
		local intRightSideSpace = 0
		if #self.TabSheets > 1 then
			for i = 2, #self.TabSheets - 1 do
				intRightSideSpace = intRightSideSpace + self.TabSheets[i]:GetWide() + 4
			end
		end
		self.TabSheets[1]:StretchToParent(0, 0, intRightSideSpace, 0)
		self.TabSheets[1]:InvalidateLayout()
	end
	RunConsoleCommand("cb_quickpanel_width", siltBoxMenu.QuickPanel:GetWide())
end
vgui.Register("vgui_library", PANEL)