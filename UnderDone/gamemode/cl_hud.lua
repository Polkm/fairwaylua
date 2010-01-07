local boxColor = Color(100, 100, 100, 255)
local textColor = Color(255, 255, 255, 200)
local boaderColor = Color(40, 40, 40, 100)
clrGray = Color(97, 95, 77, 255)
clrDrakGray = Color(54, 53, 42, 255)
clrGreen = Color(194, 255, 72, 255)
clrOrange = Color(212, 143, 57, 255)
clrPurple = Color(140, 84, 178, 255)
clrBlue = Color(74, 124, 178, 255)
clrRed = Color(89, 33, 26, 255)
clrTan = Color(178, 161, 126, 255)
clrWhite = Color(255, 242, 200, 255)

Notifications = {}
function GM:HUDPaint()
	local boolShouldDrawAmmo = true
	if !LocalPlayer():GetActiveWeapon() or !LocalPlayer():GetActiveWeapon():IsValid() then boolShouldDrawAmmo = false end
	if !LocalPlayer():GetActiveWeapon().WeaponTable or LocalPlayer():GetActiveWeapon().WeaponTable.AmmoType == "none" then boolShouldDrawAmmo = false end
	self.PlayerBox = jdraw.NewPanel()
	if !boolShouldDrawAmmo then
		self.PlayerBox:SetDemensions(10, ScrH() - 55, 300, 45)
	else
		self.PlayerBox:SetDemensions(10, ScrH() - 73, 300, 63)
	end
	self.PlayerBox:SetStyle(4, clrTan)
	self.PlayerBox:SetBoarder(1, clrDrakGray)
	jdraw.DrawPanel(self.PlayerBox)
	self:DrawHealthBar()
	self:DrawLevelBar()
	if boolShouldDrawAmmo then
		self:DrawAmmoThingy()
	end
	self:Notifications()
end

function GM:DrawHealthBar()
	local clrBarColor = clrGreen
	if LocalPlayer():Health() <= 20 then clrBarColor = clrRed end
	self.HealthBar = jdraw.NewProgressBar(self.PlayerBox, true)
	self.HealthBar:SetDemensions(3, 3, self.PlayerBox.Size.Width - 6, 20)
	self.HealthBar:SetStyle(4, clrBarColor)
	self.HealthBar:SetValue(LocalPlayer():Health(), LocalPlayer():GetStat("stat_maxhealth"))
	self.HealthBar:SetText("UiBold", "Health " .. LocalPlayer():Health(), clrDrakGray)
	jdraw.DrawProgressBar(self.HealthBar)
end

function GM:DrawLevelBar()
	local intCurrentLevelExp = toExp(LocalPlayer():GetLevel())
	local intNextLevelExp = toExp(LocalPlayer():GetLevel() + 1)
	local clrBarColor = clrOrange
	self.LevelBar = jdraw.NewProgressBar(self.PlayerBox, true)
	self.LevelBar:SetDemensions(3, self.HealthBar.Size.Hieght + 6, self.PlayerBox.Size.Width - 6, 15)
	self.LevelBar:SetStyle(4, clrBarColor)
	self.LevelBar:SetValue(LocalPlayer():GetNWInt("exp") - intCurrentLevelExp, intNextLevelExp - intCurrentLevelExp)
	self.LevelBar:SetText("UiBold", "Level " .. LocalPlayer():GetLevel(), clrDrakGray)
	jdraw.DrawProgressBar(self.LevelBar)
end

function GM:DrawAmmoThingy()
	local entActiveWeapon = LocalPlayer():GetActiveWeapon()
	local intCurrentClip = entActiveWeapon:Clip1()
	local tblWeaponTable = entActiveWeapon.WeaponTable or {}
	local strAmmoType = tblWeaponTable.AmmoType or "none"
	local clrBarColor = clrBlue
	self.AmmoBar = jdraw.NewProgressBar(self.PlayerBox, true)
	self.AmmoBar:SetDemensions(3, self.HealthBar.Size.Hieght + self.LevelBar.Size.Hieght + 9, self.PlayerBox.Size.Width - 6, 15)
	self.AmmoBar:SetStyle(4, clrBarColor)
	self.AmmoBar:SetValue(intCurrentClip, tblWeaponTable.ClipSize or 1)
	self.AmmoBar:SetText("UiBold", "Ammo " .. intCurrentClip .. "  " .. LocalPlayer():GetAmmoCount(strAmmoType), clrDrakGray)
	jdraw.DrawProgressBar(self.AmmoBar)
end

function GM:Notifications()
	local yOffset = ScrH() - 30
	for _, strNocification in pairs(Notifications) do
		surface.SetFont("MenuLarge")
		local wide, high = surface.GetTextSize(strNocification)
		local pnlNotification = jdraw.NewPanel()
		pnlNotification:SetDemensions(ScrW() - math.Clamp(wide + 40, 215, wide + 40), yOffset, wide + 30, 20)
		pnlNotification:SetStyle(4, clrTan)
		pnlNotification:SetBoarder(1, clrDrakGray)
		jdraw.DrawPanel(pnlNotification)
		draw.SimpleText(strNocification, "MenuLarge", pnlNotification.Position.X + 20, pnlNotification.Position.Y + 3, clrDrakGray, 0, 3)
		yOffset = yOffset - 25
	end
end

function AddNotification(strNotification)
	table.insert(Notifications, 1, strNotification)
	timer.Simple(15, function() table.remove(Notifications, #Notifications) end)
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
	if name == "CHudHealth" or name == "CHudBattery" or name == "CHudAmmo" or name == "CHudSecondaryAmmo" then
		return false
	end
	return true
end
