local matGradiantDown = surface.GetTextureID("gui/gradient_down")
local PANEL = {}

function PANEL:Init()
	self.Wang = vgui.Create ("DNumberWang", self)
	self.Wang.OnValueChanged = function(wang, val) self:ValueChanged(val) end
	
	self.Slider = vgui.Create("DSlider", self)
	self.Slider:SetLockY(0.5)
	self.Slider.TranslateValues = function(slider, x, y) return self:TranslateSliderValues(x, y) end
	self.Slider:SetTrapInside(true)
	self.Slider:SetImage("gui/slidergrabber")
	self.Slider.Paint = function()
		local intScrollWidth, intHieght = self.Slider.Knob:GetPos() + 2
		local intRadius = intScrollWidth < 16 and 2 or 8
		--draw.RoundedBoxEx(intRadius, 0, 0, self.Slider:GetWide(), self.Slider:GetTall(), Color(100, 100, 100, 255), true, false, false, true)
		surface.SetDrawColor(0, 0, 0, 100)
		surface.SetTexture(matGradiantDown)
		surface.DrawTexturedRect(intRadius, 0, self.Slider:GetWide() - intRadius, self.Slider:GetTall())
		
		draw.RoundedBoxEx(intRadius, 0, 0, intScrollWidth, self.Slider:GetTall(), Color(0, 129, 183, 255), false, false, false, false)
		--draw.RoundedBoxEx(intRadius, 1, 1, intScrollWidth - 2, self.Slider:GetTall() - 2, Color(0, 201, 255, 255), true, false, false, true)
		--draw.RoundedBoxEx(intRadius, 2, self.Slider:GetTall() / 2, intScrollWidth - 4, (self.Slider:GetTall() / 2) - 2, Color(0, 169, 255, 255), true, false, false, true)
	end
	--Derma_Hook(self.Slider, "Paint", "Paint", "NumSlider")
	
	self.Label = vgui.Create ("DLabel", self)
	self.Label:SetFont("UiBold")
	self.Label:SetTextColor(Color(50, 50, 50, 255))
	
	self:SetTall(20)
end

function PANEL:SetMinMax(intMin, intMax)
	self.Wang:SetMinMax(intMin, intMax)
end

function PANEL:SetMin(intMin)
	self.Wang:SetMin(intMin)
end

function PANEL:SetMax(intMax)
	self.Wang:SetMax(intMax)
end

function PANEL:SetValue(intValue)
	self.Wang:SetValue(intValue)
end

function PANEL:GetValue()
	return self.Wang:GetValue()
end

function PANEL:SetDecimals(intDecimals)
	return self.Wang:SetDecimals(intDecimals)
end

function PANEL:GetDecimals()
	return self.Wang:GetDecimals()
end

function PANEL:SetConVar(strConvar)
	self.Wang:SetConVar(strConvar)
end

function PANEL:SetText(strText)
	self.Label:SetText(strText)
end

function PANEL:PerformLayout()
	self.Wang:SizeToContents()
	self.Wang:SetPos(self:GetWide() - self.Wang:GetWide(), 0)
	self.Wang:SetTall(20)
	
	self.Slider:SetPos(0, 0)
	self.Slider:SetSize(self:GetWide() - self.Wang:GetWide(), 20)
	
	self.Label:SetPos(5, 0)
	self.Label:SetSize(self:GetWide(), 20)
end

function PANEL:ValueChanged(intValue)
	self.Slider:SetSlideX(self.Wang:GetFraction(intValue))
	self:OnValueChanged(intValue)
end

function PANEL:OnValueChanged(intValue)
	--For override
end

function PANEL:TranslateSliderValues(x, y)
	self.Wang:SetFraction(x)
	return self.Wang:GetFraction(), y
end

function PANEL:GetTextArea()
	return self.Wang:GetTextArea()
end
derma.DefineControl("FSlider", "Number for sliding", PANEL, "Panel")