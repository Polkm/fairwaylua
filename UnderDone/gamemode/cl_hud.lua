local boxX, boxY = 10, ScrH() - 80
local boxWidth, boxHieght = 250, 60
local boxColor = Color(180, 180, 180, 100)
local boaderSize = 1
local boaderColor = Color(40, 40, 40, 100)
local FullBar = boxWidth - (boaderSize * 2) - 8
	
Notifications = {}
function GM:HUDPaint()
	--HUDBox Outline
	draw.RoundedBox(2, boxX, boxY, boxWidth, boxHieght, boaderColor)
	--HUDBos Innerbox
	draw.RoundedBox(2, boxX + boaderSize, boxY + boaderSize, boxWidth - (boaderSize * 2), boxHieght - (boaderSize * 2), boxColor)
	--NameLabel
	draw.SimpleText(LocalPlayer():Nick() , "MenuLarge", boxX + 5, boxY + 5, Color(220, 220, 220, 255), 0, 3)
	self:HealthBar()
	self:WeightBar()
	self:Notifications()
end

function GM:HealthBar()
	local textColor = Color(60, 60, 60, 255)
	local BarColor = Color(80, 200, 20, 255)
	if LocalPlayer():Health() <= 20 then BarColor = Color(200, 50, 10, 255) end
	draw.RoundedBox(2, boxX + 3 + boaderSize, boxY + 20, FullBar + (boaderSize * 2) , 15, boaderColor)
	draw.RoundedBox(2, boxX + 4 + boaderSize, boxY + 21, LocalPlayer():Health() * (FullBar / 100), 13, BarColor) 
	draw.SimpleText("Health " .. LocalPlayer():Health() .. "/" ..  100, "UiBold", boxX + 7 + boaderSize, boxY + 21, textColor, 0, 3)
end

function GM:WeightBar()
	local intWeight = GAMEMODE.TotalWeight
	BarColor = Color(20, 80, 200, 255)
	draw.RoundedBox(2, boxX + 3 + boaderSize, boxY + 40, FullBar + (boaderSize * 2) , 15, boaderColor)
	draw.RoundedBox(2, boxX + 4 + boaderSize, boxY + 41, intWeight * (FullBar / MaxWeight), 13, BarColor) 
	draw.SimpleText("Weight " .. intWeight .. "/" ..  MaxWeight, "UiBold", boxX + 7 + boaderSize, boxY + 41, textColor, 0, 3)
end

function GM:Notifications()
	local yOffset = ScrH() - 35
	for k, strNocification in pairs(Notifications) do
		surface.SetFont("MenuLarge")
		local wide, high = surface.GetTextSize(strNocification)
		draw.RoundedBox(2, ScrW() - math.Clamp(wide + 20, 220, 5000), yOffset, math.Clamp(wide + 10, 200, 5000), 20, boaderColor)
		draw.RoundedBox(2, ScrW() - math.Clamp(wide + 19, 219, 5000), yOffset + 1, math.Clamp(wide + 8, 198, 5000), 18, boxColor)
		draw.SimpleText(strNocification, "MenuLarge", ScrW() - math.Clamp(wide + 15, 215, 5000), yOffset + 3, textColor, 0, 3)
		yOffset = yOffset - 25
	end
end

function AddNotification(strNotification)
	table.insert(Notifications, 1, strNotification)
	timer.Simple(10, function() table.remove(Notifications, #Notifications) end)
end
concommand.Add("UD_AddNotification", function(ply, command, args) AddNotification(table.concat(args," ")) end)


function GM:HUDShouldDraw(name)
	local ply = LocalPlayer()
	if ply && ply:IsValid() then
		local wep = ply:GetActiveWeapon()
		if wep && wep:IsValid() && wep.HUDShouldDraw != nil then
			return wep.HUDShouldDraw(wep, name)
		end
	end
	if name == "CHudHealth" or name == "CHudBattery" or name == "CHudAmmo" then
		return false
	end
	return true
end
