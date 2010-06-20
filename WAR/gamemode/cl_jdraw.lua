jdraw = {}
jdraw.PrimaryColor = Color(140, 140, 140, 100)
jdraw.SecondaryColor = Color(50, 50, 50, 100)
jdraw.Text = {}
jdraw.Text.Font = nil
jdraw.Text.Color = nil
jdraw.Text.String = nil

function jdraw.SetDrawColor(clrColorPrimary, clrSecondary)
	jdraw.PrimaryColor = clrColorPrimary
	jdraw.SecondaryColor = clrSecondary
end

function jdraw.SetText(strFont, clrColor, strString)
	jdraw.Text.Font = strFont
	jdraw.Text.Color = clrColor
	jdraw.Text.String = strString
end

function jdraw.ClearSettings()
	jdraw.PrimaryColor = Color(140, 140, 140, 100)
	jdraw.SecondaryColor = Color(50, 50, 50, 100)
	jdraw.Radius = nil
	jdraw.Text = {}
	jdraw.Text.Font = nil
	jdraw.Text.Color = nil
	jdraw.Text.String = nil
end

function jdraw.DrawPanel(intX, intY, intWidth, intHieght, boolBorder, intRoundOverRide)
	if boolBorder then
		jdraw.DrawRect(intX, intY, intWidth, intHieght, jdraw.SecondaryColor)
		jdraw.DrawRect(intX + 1, intY + 1, intWidth - 2, intHieght - 2, jdraw.PrimaryColor)
	else
		jdraw.DrawRect(intX, intY, intWidth, intHieght, jdraw.PrimaryColor)
	end
	local tblNewPanel = {}
	tblNewPanel.Postion = {x = intX, y = intY}
	tblNewPanel.Size = {width = intWidth, hieght = intHieght}
	return tblNewPanel
end

function jdraw.DrawProgressBar(intX, intY, intWidth, intHieght, intValue, intMaxValue, tblParent)
	local intDrawX = intX
	local intDrawY = intY
	if tblParent then intDrawX = intDrawX + tblParent.Postion.x end
	if tblParent then intDrawY = intDrawY + tblParent.Postion.y end
	local intBarWidth = ((intWidth - 2) / intMaxValue) * intValue
	jdraw.DrawRect(intDrawX, intDrawY, intWidth, intHieght, jdraw.SecondaryColor)
	jdraw.DrawRect(intDrawX + 1, intDrawY + 1,intBarWidth , intHieght - 2, jdraw.PrimaryColor)
	if jdraw.Text.String then
		surface.SimpleText(jdraw.Text.String, jdraw.Text.Font, intDrawX + (intWidth / 2), intDrawY + (intHieght / 2), jdraw.Text.Color, 1, 1)
	end
end

function jdraw.DrawRect(intX, intY, intWidth, intHieght, clrColor)
	surface.SetDrawColor(clrColor)
	surface.DrawRect(intX, intY, intWidth, intHieght)
end