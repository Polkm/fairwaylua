local w = ScrW()
local h = ScrH()

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
	if boolShouldDrawAmmo then self:DrawAmmoBar() end
	
	for _, ent in pairs(ents.GetAll()) do 
		if ent && ent:IsValid() && ent:GetNWString("PrintName") then
			if ent:GetPos():Distance(LocalPlayer():GetPos()) < 200 then
				local posENTpos = (ent:GetPos() + Vector(0, 0, 20)):ToScreen()
				draw.SimpleTextOutlined(ent:GetNWString("PrintName"), "UiBold", posENTpos.x, posENTpos.y, clrWhite, 1, 1, 1, clrDrakGray)
			end
		end
		--Polkm: I cut this because we already have the silk icon and we dont need more icons
	end
	
	self:DrawPartyMembers()
	
	local intX = ScrW() / 2.0
	local intY = LocalPlayer():GetEyeTraceNoCursor().HitPos:ToScreen().y
	surface.SetDrawColor(clrGreen)
	surface.DrawLine(intX - 2, intY, intX + 2, intY)
	surface.DrawLine(intX, intY + 2, intX, intY - 2)
end

function GM:DrawPartyMembers()
	for number, ply in pairs(player.GetAll()) do
		if LocalPlayer() != ply then
			if ply:IsValid() && LocalPlayer():IsValid() then
				if LocalPlayer():GetNWString("Party") != "" ||  ply:GetNWString("Party") != "" then
					if LocalPlayer():GetNWString("Party") == ply:GetNWString("Party") then
						draw.SimpleTextOutlined(ply:Nick(), "UiBold", w * 0.1 , h * (0.1 + (1/ 20)), clrWhite, 1, 1, 1, clrDrakGray)
						self.PartyHealthBar = jdraw.NewProgressBar(self.PlayerBox, true)
						self.PartyHealthBar:SetDemensions(3, 3, self.PlayerBox.Size.Width * 0.5, 20)
						self.PartyHealthBar:SetStyle(4, clrWhite)
						self.PartyHealthBar:SetValue(ply:Health(), ply:GetStat("stat_maxhealth"))
						self.PartyHealthBar:SetText("UiBold", "Health " .. ply:Health(), clrDrakGray)
						jdraw.DrawProgressBar(self.PartyHealthBar)
					end
				end
			end
		end
	end
end

function GM:DrawHealthBar()
	local clrBarColor = clrGreen
	if LocalPlayer():GetStat("stat_maxhealth") then
		if LocalPlayer():Health() <= (LocalPlayer():GetStat("stat_maxhealth") * 0.2) then clrBarColor = clrRed end
		self.HealthBar = jdraw.NewProgressBar(self.PlayerBox, true)
		self.HealthBar:SetDemensions(3, 3, self.PlayerBox.Size.Width - 6, 20)
		self.HealthBar:SetStyle(4, clrBarColor)
		self.HealthBar:SetValue(LocalPlayer():Health(), LocalPlayer():GetStat("stat_maxhealth"))
		self.HealthBar:SetText("UiBold", "Health " .. LocalPlayer():Health(), clrDrakGray)
		jdraw.DrawProgressBar(self.HealthBar)
	end
end

function GM:DrawLevelBar()
	local intCurrentLevelExp = toExp(LocalPlayer():GetLevel())
	local intNextLevelExp = toExp(LocalPlayer():GetLevel() + 1)
	local clrBarColor = clrOrange
	self.LevelBar = jdraw.NewProgressBar(self.PlayerBox, true)
	self.LevelBar:SetDemensions(3, self.HealthBar.Size.Height + 6, self.PlayerBox.Size.Width - 6, 15)
	self.LevelBar:SetStyle(4, clrBarColor)
	self.LevelBar:SetValue(LocalPlayer():GetNWInt("exp") - intCurrentLevelExp, intNextLevelExp - intCurrentLevelExp)
	self.LevelBar:SetText("UiBold", "Level " .. LocalPlayer():GetLevel(), clrDrakGray)
	jdraw.DrawProgressBar(self.LevelBar)
end

function GM:DrawAmmoBar()
	local entActiveWeapon = LocalPlayer():GetActiveWeapon()
	local intCurrentClip = entActiveWeapon:Clip1()
	local tblWeaponTable = entActiveWeapon.WeaponTable or {}
	local strAmmoType = tblWeaponTable.AmmoType or "none"
	local clrBarColor = clrBlue
	self.AmmoBar = jdraw.NewProgressBar(self.PlayerBox, true)
	self.AmmoBar:SetDemensions(3, self.HealthBar.Size.Height + self.LevelBar.Size.Height + 9, self.PlayerBox.Size.Width - 6, 15)
	self.AmmoBar:SetStyle(4, clrBarColor)
	self.AmmoBar:SetValue(intCurrentClip, tblWeaponTable.ClipSize or 1)
	self.AmmoBar:SetText("UiBold", "Ammo " .. intCurrentClip .. "  " .. LocalPlayer():GetAmmoCount(strAmmoType), clrDrakGray)
	jdraw.DrawProgressBar(self.AmmoBar)
end

function GM:HUDShouldDraw(name)
	local ply = LocalPlayer()
	if ply && ply:IsValid() then
		local wep = ply:GetActiveWeapon()
		if wep && wep:IsValid() && wep.HUDShouldDraw != nil then
			return wep.HUDShouldDraw(wep, name)
		end
	end
	if name == "CHudHealth" or name == "CHudBattery" or name == "CHudAmmo" or name == "CHudSecondaryAmmo" or name == "CHudWeaponSelection" then
		return false
	end
	return true
end
