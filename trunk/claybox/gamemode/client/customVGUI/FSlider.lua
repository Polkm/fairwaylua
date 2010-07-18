local matGradiant = surface.GetTextureID("VGUI/gradient-u")
local PANEL = {}
PANEL.Diffrence = 25

local function ShadeColor(clrColor, intDifrence)
	return Color(math.Clamp(clrColor.r + intDifrence, 0, 255), math.Clamp(clrColor.g + intDifrence, 0, 255), math.Clamp(clrColor.b + intDifrence, 0, 255), clrColor.a)
end

function PANEL:Init()
	self.BarColor = GAMEMODE.ColorPallet["Blue"]
	self.Wang = vgui.Create ("DNumberWang", self)
	self.Wang.OnValueChanged = function(wang, val) self:ValueChanged(val) end
	
	self.Slider = vgui.Create("DSlider", self)
	self.Slider:SetLockY(0.5)
	self.Slider.TranslateValues = function(slider, x, y) return self:TranslateSliderValues(x, y) end
	self.Slider:SetTrapInside(true)
	self.Slider:SetImage("gui/slidergrabber")
	self.Slider.Paint = function()
		local intScrollWidth, intHieght = self.Slider.Knob:GetPos() + 3
		local intRadius = 2
		draw.RoundedBox(intRadius, 0, 0, self.Slider:GetWide(), self.Slider:GetTall(), Color(100, 100, 100, 255))
		surface.SetDrawColor(0, 0, 0, 50)
		surface.SetTexture(matGradiant)
		surface.DrawTexturedRect(intRadius, 0, self.Slider:GetWide() - intRadius, self.Slider:GetTall())
		
		draw.RoundedBox(intRadius, 0, 0, intScrollWidth, self.Slider:GetTall(), ShadeColor(self.BarColor, -self.Diffrence))
		draw.RoundedBox(intRadius, 1, 1, intScrollWidth - 2, self.Slider:GetTall() - 2, ShadeColor(self.BarColor, self.Diffrence))
		draw.RoundedBox(intRadius, 2, self.Slider:GetTall() / 2, intScrollWidth - 4, (self.Slider:GetTall() / 2) - 2, self.BarColor)
	end
	--Derma_Hook(self.Slider, "Paint", "Paint", "NumSlider")
	
	self.Label = vgui.Create ("DLabel", self)
	self.Label:SetFont("UiBold")
	self.Label:SetTextColor(GAMEMODE.ColorPallet["Shadow"])
	
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

function PANEL:SetBarColor(clrColor)
	self.BarColor = clrColor or GAMEMODE.ColorPallet["Blue"]
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

derma.DefineControl("FSlider", "Number for sliding", table.Copy(PANEL), "Panel")
--Should we realy be this communist?
derma.DefineControl("DNumSlider", "Number for sliding", PANEL, "Panel")