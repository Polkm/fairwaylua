PANEL = {}
PANEL.SkillsList = nil
PANEL.ItemIconPadding = 1
PANEL.ItemIconSize = 39

function PANEL:Init()
	self.SkillsList = vgui.Create("DPanelList", self)
	self.SkillsList:SetSpacing(self.ItemIconPadding)
	self.SkillsList:SetPadding(self.ItemIconPadding)
	self.SkillsList:EnableHorizontal(true)
	self.SkillsList:EnableVerticalScrollbar(true)
	self.SkillsList.Paint = function()
		local tblPaintPanle = jdraw.NewPanel()
		tblPaintPanle:SetDemensions(0, 0, self.SkillsList:GetWide(), self.SkillsList:GetTall())
		tblPaintPanle:SetStyle(4, clrGray)
		tblPaintPanle:SetBoarder(1, clrDrakGray)
		jdraw.DrawPanel(tblPaintPanle)
	end
	self:LoadSkills()
end

function PANEL:PerformLayout()
	self.SkillsList:SetPos(0, 20)
	self.SkillsList:SetSize(self:GetWide(), self:GetTall() - 20)
end

function PANEL:LoadSkills()
	self.SkillsList:Clear()
	for strSkill, tblSkillTable in pairs(GAMEMODE.DataBase.Skills) do
		local intSkillAmount = LocalPlayer():GetSkill(strSkill)
		local icnSkill = vgui.Create("FIconItem")
		icnSkill:SetSize(self.ItemIconSize, self.ItemIconSize)
		icnSkill:SetSkill(tblSkillTable, intSkillAmount)
		self.SkillsList:AddItem(icnSkill)
	end
end

vgui.Register("charactertab", PANEL, "Panel")