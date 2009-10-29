jdraw = {}
jdraw.PrimaryColor = Color(140, 140, 140, 100)
jdraw.SecondaryColor = Color(50, 50, 50, 100)
jdraw.Rounded = false
jdraw.Radius = nil
jdraw.Text = {}
jdraw.Text.Font = nil
jdraw.Text.Color = nil
jdraw.Text.String = nil

function jdraw.SetDrawColor(clrColorPrimary, clrSecondary)
	jdraw.PrimaryColor = clrColorPrimary
	jdraw.SecondaryColor = clrSecondary
end

function jdraw.SetRounded(boolEnabled, intRadius)
	jdraw.Rounded = boolEnabled
	if intRadius then
		jdraw.Radius = math.Clamp(intRadius, 1, intRadius)
	end
end

function jdraw.SetText(strFont, clrColor, strString)
	jdraw.Text.Font = strFont
	jdraw.Text.Color = clrColor
	jdraw.Text.String = strString
end

function jdraw.ClearSettings()
	jdraw.PrimaryColor = Color(140, 140, 140, 100)
	jdraw.SecondaryColor = Color(50, 50, 50, 100)
	jdraw.Rounded = false
	jdraw.Radius = nil
	jdraw.Text = {}
	jdraw.Text.Font = nil
	jdraw.Text.Color = nil
	jdraw.Text.String = nil
end

function jdraw.DrawPanel(intX, intY, intWidth, intHieght, boolBorder)
	if !jdraw.Rounded then
		surface.SetDrawColor(jdraw.PrimaryColor.r, jdraw.PrimaryColor.g, jdraw.PrimaryColor.b, jdraw.PrimaryColor.a)
		surface.DrawRect(intX, intY, intWidth, intHieght)
		if boolBorder then
			surface.SetDrawColor(jdraw.SecondaryColor.r, jdraw.SecondaryColor.g, jdraw.SecondaryColor.b, jdraw.SecondaryColor.a)
			surface.DrawOutlinedRect(intX, intY, intWidth, intHieght)
		end
	else
		if jdraw.Radius then
			if boolBorder then
				draw.RoundedBox(jdraw.Radius, intX, intY, intWidth, intHieght, jdraw.SecondaryColor)
			end
			draw.RoundedBox(jdraw.Radius, intX + 1, intY + 1, intWidth - 2, intHieght - 2, jdraw.PrimaryColor)
		end
	end
end

function jdraw.DrawProgressBar(intX, intY, intWidth, intHieght, intValue, intMaxValue)
	if !jdraw.Rounded then
		surface.SetDrawColor(jdraw.SecondaryColor.r, jdraw.SecondaryColor.g, jdraw.SecondaryColor.b, jdraw.SecondaryColor.a)
		surface.DrawRect(intX, intY, intWidth, intHieght)
		surface.SetDrawColor(jdraw.PrimaryColor.r, jdraw.PrimaryColor.g, jdraw.PrimaryColor.b, jdraw.PrimaryColor.a)
		surface.DrawRect(intX + 1, intY + 1, ((intWidth - 2) / intMaxValue) * intValue, intHieght - 2)
	else
		if jdraw.Radius then
			draw.RoundedBox(jdraw.Radius, intX, intY, intWidth, intHieght, jdraw.SecondaryColor)
			draw.RoundedBox(jdraw.Radius, intX + 1, intY + 1, ((intWidth - 2) / intMaxValue) * intValue, intHieght - 2, jdraw.PrimaryColor)
		end
	end
	if jdraw.Text.String then
		draw.SimpleText(jdraw.Text.String, jdraw.Text.Font, intX + (intWidth / 2), intY + (intHieght / 2), jdraw.Text.Color, 1, 1)
	end
end