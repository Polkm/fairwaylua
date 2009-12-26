--[[
	+oooooo+-`    `:oyyys+-`    +oo.       /oo-   .oo+-  ooo+`   `ooo+  
	NMMhyhmMMm-  omMNyosdMMd:   NMM:       hMM+ `oNMd:  `MMMMy`  yMMMN  
	NMM:  .NMMo /MMN:    sMMN`  NMM:       hMMo/dMm/`   `MMMmMs`oMmMMN  
	NMMhyhmMNh. yMMm     -MMM:  NMM:       hMMmNMMo     `MMM:mMhMd/MMN  
	NMMyoo+/.   /MMN:    sMMN`  NMM:       hMMy:dMMh-   `MMM`:NMN.:MMN  
	NMM:         +NMNyosdMMd:   NMMdyyyyy. hMM+ `+NMNo` `MMM` ... :MMN  
	+oo.          `:oyyys+-`    +oooooooo` /oo-   .ooo/  ooo`     .oo+  2009
]]

local PANEL = {}
PANEL.Color = nil
PANEL.Icon = nil
PANEL.NameText = nil
PANEL.DescText = nil
PANEL.CommonButton = nil
PANEL.SecondaryButton = nil
PANEL.ContentList = nil
PANEL.Expanded = false
PANEL.Expandable = false
PANEL.ExpandedSize = nil
PANEL.GradientTexture = nil

function PANEL:Init()
	self.Color = clrGray
	self.Color_hover = clrGray
	self:SetColor(clrGray)
	self.NameText = "Test"
	self.DescText = ""
	self.ExpandedSize = 50
	--RightClick Dectection--
	self:SetMouseInputEnabled(true)
	self.OnMousePressed = function(self,mousecode) self:MouseCapture(true) end
	self.OnMouseReleased = function(self,mousecode) self:MouseCapture(false)
	if mousecode == MOUSE_RIGHT then PCallError(self.DoRightClick,self) end
	if mousecode == MOUSE_LEFT then PCallError(self.DoClick,self) end end
	-------------------------
	self.DoClick = function() self:SetExpanded(!self:GetExpanded()) end
	self.DoRightClick = function() end
	-------------------------
	self.GradientTexture = surface.GetTextureID("VGUI/gradient-d")
end

function PANEL:PerformLayout()
	if self.Expanded then self:SetSize(self:GetParent():GetWide() - 2, self.ExpandedSize) end
	if !self.Expanded then self:SetSize(self:GetParent():GetWide() - 2, 18) end
	if self.CommonButton then
		self.CommonButton:SetPos(self:GetWide() - 17, 1)
		if self.SecondaryButton then self.CommonButton:SetPos(self:GetWide() - 36, 1) end
	end
	if self.SecondaryButton then
		self.SecondaryButton:SetPos(self:GetWide() - 17, 1)
	end
	if self.ContentList then
		self.ContentList:SetSize(self:GetWide() - 2, self:GetTall() - 22)
		self.ContentList:SetPos(1, 21)
	end
	self:GetParent():InvalidateLayout()
end

function PANEL:Paint()
	local x, y = self:CursorPos()
	if x > 0 && x < self:GetWide() && y > 0 && y < self:GetTall() then
		draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall(), self.Color_hover)
	else
		draw.RoundedBox(4, 0, 0, self:GetWide(""), self:GetTall(), self.Color)
	end
	draw.RoundedBox(0, 2, 0, self:GetWide() - 4, 1, Color(200, 200, 200, 100))
	--Div
	draw.RoundedBox(0, 1, 19, self:GetWide() - 2, 1, Color(50, 50, 50, 100))
	--Grdiant
	surface.SetDrawColor(0, 0, 0, 100)
	surface.SetTexture(self.GradientTexture)
	surface.DrawTexturedRect(0, 0, self:GetWide(), self:GetTall())
	--Icon
	if self.Icon then
		local IconTexture = surface.GetTextureID(self.Icon)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetTexture(IconTexture)
		if x > 0 && x < self:GetWide() && y > 0 && y < self:GetTall() then
			surface.DrawTexturedRect(1, 1, 16, 16)
		else
			surface.DrawTexturedRect(3, 3, 12, 12)
		end
	end
	--Text
	if self.Icon then draw.SimpleText(self.NameText, "MenuLarge", 20, 1, clrWhite, 0, 3)
	else draw.SimpleText(self.NameText, "MenuLarge", 1, 1, clrWhite, 0, 3) end
	surface.SetFont("MenuLarge")
	local wide, high = surface.GetTextSize(self.NameText)
	if self.Icon then draw.SimpleText(self.DescText, "DefaultSmall", wide + 25, 4, clrDrakGray, 0, 3)
	else draw.SimpleText(self.DescText, "DefaultSmall", wide + 5, 4, clrDrakGray, 0, 3) end
	return true
end

function PANEL:SetColor(clrColor)
	self.Color = clrColor
	local intHoverChange = 20
	local HoverColor = Color(
		math.Clamp(clrColor.r + intHoverChange, 0, 255),
		math.Clamp(clrColor.g + intHoverChange, 0, 255),
		math.Clamp(clrColor.b + intHoverChange, 0, 255),
		clrColor.a)
	self.Color_hover = HoverColor
end
function PANEL:SetIcon(strIconText)
	self.Icon = strIconText
end
function PANEL:SetNameText(strNameText)
	self.NameText = strNameText
end
function PANEL:SetDescText(strDescText)
	self.DescText = strDescText
end
function PANEL:SetExpandable(boolExpandable)
	self.Expandable = boolExpandable
end
function PANEL:SetExpanded(boolExpanded)
	if self.Expandable then
		self.Expanded = boolExpanded
		if self.Expanded then self:SetTall(self.ExpandedSize) end
		if !self.Expanded then self:SetTall(18) end
		self:GetParent():InvalidateLayout()
	end
end
function PANEL:GetExpanded()
	return self.Expanded
end

function PANEL:SetCommonButton(strTexture, fncPressedFunction, strToolTip)
	if !self.CommonButton then  self.CommonButton = vgui.Create("DImageButton", self) end
	self.CommonButton:SetMaterial(strTexture)
	self.CommonButton:SizeToContents()
	self.CommonButton.DoClick = fncPressedFunction
	self.CommonButton:SetTooltip(strToolTip)
end
function PANEL:SetSecondaryButton(strTexture, fncPressedFunction, strToolTip)
	self.SecondaryButton = vgui.Create("DImageButton", self)
	self.SecondaryButton:SetMaterial(strTexture)
	self.SecondaryButton:SizeToContents()
	self.SecondaryButton.DoClick = fncPressedFunction
	self.SecondaryButton:SetTooltip(strToolTip)
end
function PANEL:AddContent(objItem)
	if !self.ContentList then
		self.ContentList = vgui.Create("DPanelList", self)
		self.ContentList:SetSpacing(1)
		self.ContentList:SetPadding(1)
		self.ContentList:EnableHorizontal(false)
		self.ContentList:EnableVerticalScrollbar(true)
	end
	self.ContentList:AddItem(objItem)
	local ExpandSize = 18 + 5
	for _,ListItem in pairs(self.ContentList:GetItems()) do ExpandSize = ExpandSize + 19 end
	self.ExpandedSize = ExpandSize
	self:PerformLayout()
end
vgui.Register("FListItem", PANEL, "Panel")