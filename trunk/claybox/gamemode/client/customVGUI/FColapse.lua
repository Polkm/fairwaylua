local matGradiant = surface.GetTextureID("gui/gradient")
local PANEL = {}
function PANEL:Init()
	self.Label = vgui.Create("DLabel", self)
	self.Label:SetFont("UiBold")
	self:SetContentAlignment(4)
	self:SetTall(20)
end
function PANEL:Paint()
	if self:GetParent():GetExpanded() then
		self.Label:SetTextColor(Color(240, 240, 240, 255))
		surface.SetDrawColor(240, 240, 240, 200)
		surface.SetTexture(matGradiant)
		surface.DrawTexturedRect(4, 18, self:GetWide() * 0.50, 2)
	else
		self.Label:SetTextColor(Color(200, 200, 200, 255))
	end
	if self.Icon then
		self.Label:SetPos(25, -2)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetTexture(surface.GetTextureID(self.Icon))
		surface.DrawTexturedRect(4, 0, 16, 16)
	else
		self.Label:SetPos(4, -2)
	end
	self.Label:SetText(self.Text or "")
	self.Label:SetWide(self:GetWide())
	return true
end
function PANEL:OnMousePressed(intMouseCode)
	if intMouseCode == MOUSE_LEFT then
		self:GetParent():Toggle()
		return
	end
	return self:GetParent():OnMousePressed(intMouseCode)
end
derma.DefineControl("FCategoryHeader", "Category Header", PANEL, "DButton")


local PANEL = {}
AccessorFunc(PANEL, "m_bSizeExpanded", "Expanded", FORCE_BOOL)
AccessorFunc(PANEL, "m_iContentHeight", "StartHeight")
AccessorFunc(PANEL, "m_fAnimTime", "AnimTime")
AccessorFunc(PANEL, "m_bDrawBackground", "DrawBackground", FORCE_BOOL)
AccessorFunc(PANEL, "m_iPadding", "Padding")
function PANEL:Init()
	self.Header = vgui.Create("FCategoryHeader", self)
	self.Contents = vgui.Create("DPanelList", self)
	self.Contents:SetAutoSize(true)
	self.Contents:SetPadding(0)
	self.Contents:SetSpacing(0)
	self.Contents:EnableVerticalScrollbar(true)
	self:SetExpanded(true)
	self:SetMouseInputEnabled(true)
	self:SetAnimTime(0.2)
	self.animSlide = Derma_Anim("Anim", self, self.AnimSlide)
	self:SetDrawBackground(true)
end

function PANEL:Think()
	self.animSlide:Run()
end

function PANEL:SetLabel(strLabel)
	self.Header.Text = strLabel
end

function PANEL:AddContents(pnlItem)
	self.Contents:AddItem(pnlItem)
	--self:InvalidateLayout()
end

function PANEL:SetIcon(strIcon)
	self.Header.Icon = strIcon
end

function PANEL:Paint()
	return false
end

function PANEL:Toggle()
	self:SetExpanded(!self:GetExpanded())

	self.animSlide:Start(self:GetAnimTime(), {From = self:GetTall()})
	
	self:InvalidateLayout(true)
	self:GetParent():InvalidateLayout()
	self:GetParent():GetParent():InvalidateLayout()
	self:OnToggle()
end

function PANEL:OnToggle()
	--Hook me!
end

function PANEL:PerformLayout()
	local intPadding = 4
	self.Header:SetPos(0, 0)
	self.Header:SetWide(self:GetWide())
	if self.Contents then
		if self:GetExpanded() then
			self.Contents:SetPos(intPadding, self.Header:GetTall() + intPadding)
			self.Contents:SetWide(self:GetWide() - intPadding * 2)	
			self.Contents:InvalidateLayout(true)
			self.Contents:SetVisible(true)
			self:SetTall(self.Contents:GetTall() + self.Header:GetTall() + intPadding * 2)
		else
			self.Contents:SetVisible(false)
			self:SetTall(self.Header:GetTall())
		end
	end
	self.animSlide:Run()
end

function PANEL:OnMousePressed(mcode)
	if !self:GetParent().OnMousePressed then return end
	return self:GetParent():OnMousePressed(mcode)
end

function PANEL:AnimSlide(anim, delta, data)
	if anim.Started then
		data.To = self:GetTall()	
	end
	if anim.Finished then
		self:InvalidateLayout()
		return
	end

	if self.Contents then self.Contents:SetVisible(true) end
	
	self:SetTall(Lerp(delta, data.From, data.To))
	self:GetParent():InvalidateLayout()
	self:GetParent():GetParent():InvalidateLayout()
	self:GetParent():GetParent():GetParent():InvalidateLayout()
	self:GetParent():GetParent():GetParent():GetParent():InvalidateLayout()
end
derma.DefineControl("FColapse", "Collapsable Panel List", PANEL, "Panel")