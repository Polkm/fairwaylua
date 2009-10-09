include('cl_shop.lua')
include('GUIObjects/FMultiLineLabel.lua')
include('shared.lua')
include('sh_weapons.lua')
--------------------------
OpenMenu = nil

function GM:HUDShouldDraw(name)
	local ply = LocalPlayer()
	if ply && ply:IsValid() then
		local wep = ply:GetActiveWeapon()
		if wep && wep:IsValid() && wep.HUDShouldDraw != nil then
			return wep.HUDShouldDraw(wep, name)
		end
	end
	if name == "CHudHealth" or name == "CHudBattery" then
		return false
	end
	return true
end

function GM:HUDPaint()
	local Client = LocalPlayer()
	local boxX, boxY = 10, ScrH() - 100
	local boxWidth, boxHieght = 250, 80
	local boxColor = Color(180, 180, 180, 100)
	local boaderSize = 1
	local boaderColor = Color(40, 40, 40, 100)
	--HUDBox Outline
	draw.RoundedBox(2, boxX, boxY, boxWidth, boxHieght, boaderColor)
	--HUDBos Innerbox
	draw.RoundedBox(2, boxX + boaderSize, boxY + boaderSize, boxWidth - (boaderSize * 2), boxHieght - (boaderSize * 2), boxColor)
		--NameLabel
		draw.SimpleText(Client:Nick() .. " Level " .. GetLevelValue(Client:GetNWInt("exp")) , "MenuLarge", boxX + 5, boxY + 5, Color(220, 220, 220, 255), 0, 3)
		--HealthBar
		local textColor = Color(60, 60, 60, 255)
		local BarColor = Color(80, 200, 20, 255)
		if Client:Health() <= 20 then BarColor = Color(200, 50, 10, 255) end
		local FullBar = boxWidth - (boaderSize * 2) - 8
		draw.RoundedBox(2, boxX + 3 + boaderSize, boxY + 20, FullBar + (boaderSize * 2) , 15, boaderColor)
		draw.RoundedBox(2, boxX + 4 + boaderSize, boxY + 21, Client:Health() * (FullBar / 100), 13, BarColor) 
		draw.SimpleText("Health " .. Client:Health() .. "/" ..  100, "UiBold", boxX + 7 + boaderSize, boxY + 21, textColor, 0, 3)
		--ExpBar
		BarColor = Color(20, 80, 200, 255)
		draw.RoundedBox(2, boxX + 3 + boaderSize, boxY + 40, FullBar + (boaderSize * 2) , 15, boaderColor)
		local MaxEXP = EXP_LevelThreshholds[GetLevelValue(Client:GetNWInt("exp")) + 1] - EXP_LevelThreshholds[GetLevelValue(Client:GetNWInt("exp"))]
		local CurrentEXP = Client:GetNWInt("exp") - EXP_LevelThreshholds[GetLevelValue(Client:GetNWInt("exp"))]
		draw.RoundedBox(2, boxX + 4 + boaderSize, boxY + 41, CurrentEXP * (FullBar / MaxEXP), 13, BarColor) 
		draw.SimpleText("Exp " .. math.Round(CurrentEXP) .. "/" ..  MaxEXP, "UiBold", boxX + 7 + boaderSize, boxY + 41, textColor, 0, 3)
		--Monehz
		draw.RoundedBox(2, boxX + 3 + boaderSize, boxY + 61, FullBar + (boaderSize * 2) , 15, boaderColor)
		draw.SimpleText("Cash " .. Client:GetNWInt("cash"), "UiBold", boxX + 7 + boaderSize, boxY + 62, textColor, 0, 3)
end