jdraw = {}
jdraw.PrimaryColor = Color(140, 140, 140, 100)
jdraw.SecondaryColor = Color(50, 50, 50, 100)
jdraw.Radius = nil
jdraw.Text = {}
jdraw.Text.Font = nil
jdraw.Text.Color = nil
jdraw.Text.String = nil

function jdraw.SetDrawColor(clrColorPrimary, clrSecondary)
	jdraw.PrimaryColor = clrColorPrimary
	jdraw.SecondaryColor = clrSecondary
end

function jdraw.SetRounded(intRadius)
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
	jdraw.Radius = nil
	jdraw.Text = {}
	jdraw.Text.Font = nil
	jdraw.Text.Color = nil
	jdraw.Text.String = nil
end

function jdraw.DrawPanel(intX, intY, intWidth, intHieght, boolBorder, intRoundOverRide)
	local intRadius = intRoundOverRide or jdraw.Radius or 0
	if boolBorder then
		draw.RoundedBox(intRadius, intX, intY, intWidth, intHieght, jdraw.SecondaryColor)
		draw.RoundedBox(intRadius, intX + 1, intY + 1, intWidth - 2, intHieght - 2, jdraw.PrimaryColor)
	else
		draw.RoundedBox(intRadius, intX, intY, intWidth, intHieght, jdraw.PrimaryColor)
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
	local intRadius = jdraw.Radius or 1
	local intBarWidth = ((intWidth - 2) / intMaxValue) * intValue
	if intRadius > intBarWidth then intRadius = 1 end
	draw.RoundedBox(intRadius, intDrawX, intDrawY, intWidth, intHieght, jdraw.SecondaryColor)
	draw.RoundedBox(intRadius, intDrawX + 1, intDrawY + 1,intBarWidth , intHieght - 2, jdraw.PrimaryColor)
	if jdraw.Text.String then
		draw.SimpleText(jdraw.Text.String, jdraw.Text.Font, intDrawX + (intWidth / 2), intDrawY + (intHieght / 2), jdraw.Text.Color, 1, 1)
	end
end