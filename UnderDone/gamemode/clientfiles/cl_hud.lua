GM.DamageIndacators = {}
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
	self:DrawDamageIndacators()
	local trcEyeTrace = LocalPlayer():GetEyeTraceNoCursor()
	if trcEyeTrace.Entity:GetNWInt("level") > 0 then
		GAMEMODE:DrawNPCInfo(trcEyeTrace.Entity)
	end
	if trcEyeTrace.Entity:IsPlayer() then
		GAMEMODE:DrawPlayerInfo(trcEyeTrace.Entity)
	end
	
	for _, ent in pairs(ents.GetAll()) do 
		if ent && ent:IsValid() && ent:GetNWString("PrintName") then
			if ent:GetPos():Distance(LocalPlayer():GetPos()) < 200 then
				local posENTpos = (trcEyeTrace.Entity:GetPos() + Vector(0, 0, 30)):ToScreen()
				draw.SimpleTextOutlined(trcEyeTrace.Entity:GetNWString("PrintName"), "UiBold", posENTpos.x, posENTpos.y, clrWhite, 1, 1, 1, clrDrakGray)
			end
		end
	end
	
	local intX = ScrW() / 2.0
	local intY = LocalPlayer():GetEyeTraceNoCursor().HitPos:ToScreen().y
	surface.SetDrawColor(clrGreen)
	surface.DrawLine(intX - 2, intY, intX + 2, intY)
	surface.DrawLine(intX, intY + 2, intX, intY - 2)
end

function GM:DrawHealthBar()
	local clrBarColor = clrGreen
	if LocalPlayer():Health() <= (LocalPlayer():GetStat("stat_maxhealth") * 0.2) then clrBarColor = clrRed end
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

function GM:DrawPlayerInfo(entPLY)
local posPLYpos = (entPLY:GetPos() + Vector(0, 0, 80)):ToScreen()
draw.SimpleTextOutlined(entPLY:Nick(), "UiBold", posPLYpos.x, posPLYpos.y - 10, clrWhite, 1, 1, 1, clrDrakGray)
	if entPLY:IsAdmin() || entPLY:IsSuperAdmin() then
		strIcon = "gui/admin"
	else
		strIcon = "gui/player"
	end
	if strIcon then
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetTexture(surface.GetTextureID(strIcon))
		surface.DrawTexturedRect(posPLYpos.x - 20, posPLYpos.y - 30, 16, 16)
	end
end
function GM:DrawNPCInfo(entNPC)
	local tblNPCTable = NPCTable(entNPC:GetNWInt("npc"))
	local intLevel = entNPC:GetNWInt("level")
	local plylevel = LocalPlayer():GetLevel()
	local posNPCpos = (entNPC:GetPos() + Vector(0, 0, 80)):ToScreen()
	local clrBarColor = clrGreen
	local intHealth = entNPC:GetNWInt("Health")
	local intMaxHealth = entNPC:GetNWInt("MaxHealth")
	if intHealth <= (intMaxHealth * 0.2) then clrBarColor = clrRed end
	self.NpcHealthBar = jdraw.NewProgressBar(self.NpcBox, true)
	self.NpcHealthBar:SetDemensions(posNPCpos.x  - (80 / 2), posNPCpos.y - (15 / 2) + 5,  80, 11)
	self.NpcHealthBar:SetStyle(4, clrBarColor)
	self.NpcHealthBar:SetBoarder(1, clrDrakGray)
	self.NpcHealthBar:SetText("UiBold", intHealth, clrDrakGray)
	self.NpcHealthBar:SetValue(intHealth, intMaxHealth)
	jdraw.DrawProgressBar(self.NpcHealthBar)
	local clrLevelColor = clrWhite
	if intLevel < plylevel then clrLevelColor = clrBlue end
	if intLevel > plylevel then clrLevelColor = clrOrange end
	if tblNPCTable.Race == "human" then clrLevelColor = clrWhite end
	draw.SimpleTextOutlined(tblNPCTable.PrintName .. " lv. " .. intLevel, "UiBold", posNPCpos.x, posNPCpos.y - 10, clrLevelColor, 1, 1, 1, clrDrakGray)
	local strIcon = nil
	if tblNPCTable.Race == "human" then strIcon = "gui/silkicons/emoticon_smile" end
	if strIcon then
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetTexture(surface.GetTextureID(strIcon))
		surface.DrawTexturedRect(posNPCpos.x + 30, posNPCpos.y + 2, 16, 16)
	end
end

function GM:Notifications()
	local yOffset = ScrH() - 30
	for _, strNocification in pairs(Notifications) do
		surface.SetFont("MenuLarge")
		local wide, high = surface.GetTextSize(strNocification)
		local pnlNotification = jdraw.NewPanel()
		pnlNotification:SetDemensions(ScrW() - (wide + 40), yOffset, wide + 30, 20)
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

function GM:DrawDamageIndacators()
	if GAMEMODE.DamageIndacators[1] then
		for _, tblInfo in pairs(GAMEMODE.DamageIndacators) do
			local posIndicatorPos = tblInfo.Position:ToScreen()
			local clrDrawColor = tblInfo.Color
			local clrDrawColorBoarder = Color(clrDrakGray.r, clrDrakGray.g, clrDrakGray.b, clrDrawColor.a)
			draw.SimpleTextOutlined(tblInfo.String, "Trebuchet24", posIndicatorPos.x, posIndicatorPos.y, clrDrawColor, 1, 1, 1, clrDrawColorBoarder)
			tblInfo.Color.a = math.Clamp(tblInfo.Color.a - 0.5, 0, 255)
			tblInfo.Velocity.z = tblInfo.Velocity.z  - 0.02
			tblInfo.Velocity = tblInfo.Velocity / 1.1
			tblInfo.Position = tblInfo.Position + tblInfo.Velocity
		end
	end
end

function GM:AddDamageIndacator(tblInfo)
	table.insert(GAMEMODE.DamageIndacators, 1, tblInfo)
	timer.Simple(7, function() table.remove(GAMEMODE.DamageIndacators, #GAMEMODE.DamageIndacators) end)
end
concommand.Add("UD_AddDamageIndacator", function(ply, command, args)
	local tblRecevedTable = string.Explode("!", args[2])
	local vecPosition = Vector(tblRecevedTable[1], tblRecevedTable[2], tblRecevedTable[3])
	local clrColor = clrWhite
	local tblInfo = {}
	tblInfo.String = string.gsub(args[1], "_", " ")
	if args[3] then clrColor = GAMEMODE:GetColor(args[3]) end
	tblInfo.Color = Color(clrColor.r, clrColor.g, clrColor.b, 255)
	tblInfo.Velocity = Vector(math.random(-3, 3), math.random(-3, 3), 3)
	tblInfo.Position = vecPosition + Vector(math.random(-10, 10), math.random(-10, 10), math.random(0, 20))
	GAMEMODE:AddDamageIndacator(tblInfo)
end)


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
