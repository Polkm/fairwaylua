PANEL = {}
PANEL.HeaderList = nil
PANEL.HeaderHieght = 15
PANEL.SkillsList = nil
PANEL.ItemIconPadding = 1
PANEL.ItemIconSize = 39

function PANEL:Init()
	self.HeaderList = CreateGenericList(self, 1, true, false)
	self.SkillsList = CreateGenericList(self, self.ItemIconPadding, true, true)
	
	self:LoadSkills()
end

function PANEL:PerformLayout()
	self.HeaderList:SetPos(0, 0)
	self.HeaderList:SetSize(self:GetWide(), self.HeaderHieght)
	self.SkillsList:SetPos(0, self.HeaderHieght + 5)
	self.SkillsList:SetSize(self.HeaderList:GetWide(), self:GetTall() - self.HeaderHieght - 5)
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
	--Since when did NWvars get slow :/
	timer.Simple(0.2, function()
		self:LoadHeader()
	end)
end

function PANEL:LoadHeader()
	self.HeaderList:Clear()
	local lblSkillPoints = vgui.Create("DLabel")
	lblSkillPoints:SetFont("UiBold")
	lblSkillPoints:SetColor(clrDrakGray)
	lblSkillPoints:SetText("  Skill Points " .. LocalPlayer():GetNWInt("SkillPoints"))
	lblSkillPoints:SizeToContents()
	self.HeaderList:AddItem(lblSkillPoints)
end
vgui.Register("charactertab", PANEL, "Panel")