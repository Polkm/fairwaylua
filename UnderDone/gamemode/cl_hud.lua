local boxColor = Color(180, 180, 180, 100)
local textColor = Color(60, 60, 60, 255)
local boaderColor = Color(40, 40, 40, 100)

Notifications = {}
function GM:HUDPaint()
	self.PlayerBox = jdraw.NewPanel()
	self.PlayerBox:SetDemensions(10, ScrH() - 49, 250, 39)
	self.PlayerBox:SetStyle(4, Color(180, 180, 180, 100))
	self.PlayerBox:SetBoarder(1, Color(40, 40, 40, 150))
	jdraw.DrawPanel(self.PlayerBox)
	self:DrawHealthBar()
	self:DrawWeightBar()
	self:Notifications()
end

function GM:DrawHealthBar()
	local clrBarColor = Color(80, 200, 20, 255)
	if LocalPlayer():Health() <= 20 then clrBarColor = Color(200, 50, 10, 255) end
	self.HealthBar = jdraw.NewProgressBar(self.PlayerBox, true)
	self.HealthBar:SetDemensions(3, 3, self.PlayerBox.Size.Width - 6, 15)
	self.HealthBar:SetStyle(4, clrBarColor)
	self.HealthBar:SetValue(LocalPlayer():Health(), 100)
	self.HealthBar:SetText("UiBold", "Health " .. LocalPlayer():Health() .. "/" ..  100, textColor)
	jdraw.DrawProgressBar(self.HealthBar)
end

function GM:DrawWeightBar()
	local intWeight = self.TotalWeight
	local clrBarColor = Color(20, 80, 200, 255)
	self.WeightBar = jdraw.NewProgressBar(self.PlayerBox, true)
	self.WeightBar:SetDemensions(3, self.HealthBar.Size.Hieght + 6, self.PlayerBox.Size.Width - 6, 15)
	self.WeightBar:SetStyle(4, clrBarColor)
	self.WeightBar:SetValue(intWeight, MaxWeight)
	self.WeightBar:SetText("UiBold", "Weight " .. intWeight .. "/" ..  MaxWeight, textColor)
	jdraw.DrawProgressBar(self.WeightBar)
end

function GM:Notifications()
	local yOffset = ScrH() - 35
	for _, strNocification in pairs(Notifications) do
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
