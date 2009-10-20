function GM:HUDShouldDraw(Name)
	if Name == "CHudHealth" or Name == "CHudBattery" or Name =="CHudSecondaryAmmo" or Name == "CHudAmmo" or Name == "CHudWeaponSelection" then
		return false
	end	
	return true
end

function GM:HUDPaint() 
	local SW = ScrW()
	local SH = ScrH()
	local client = LocalPlayer()
	local clrHUDBox = Color(140, 140, 140, 100)
	local clrHUDBox_Boarder = Color(50, 50, 50, 100)
	----Health Box----
	local intHealthBoxWidth = 300
	local intHealthBoxHieght = 40
	local clrNameText = Color(200, 200, 200, 0)
	local clrPVPText = Color(200, 100, 100, 0)
	local clrLockerText = Color(100, 200, 100, 0)
	surface.SetDrawColor(clrHUDBox.r, clrHUDBox.g, clrHUDBox.b, clrHUDBox.a)
	surface.DrawRect(0, SH - intHealthBoxHieght, intHealthBoxWidth, intHealthBoxHieght)
	surface.SetDrawColor(clrHUDBox_Boarder.r, clrHUDBox_Boarder.g, clrHUDBox_Boarder.b, clrHUDBox_Boarder.a)
	surface.DrawOutlinedRect(0, SH - intHealthBoxHieght, intHealthBoxWidth, intHealthBoxHieght)
	surface.DrawRect(5, SH - intHealthBoxHieght + 5, intHealthBoxWidth - 10, intHealthBoxHieght - 10)
	surface.SetDrawColor((100 - client:Health()) * 2.55, client:Health() * 2.55, 0, 95)
	surface.DrawRect(5, SH - intHealthBoxHieght + 5, (intHealthBoxWidth - 10) / (100 / client:Health()), intHealthBoxHieght - 10)
	surface.SetFont("Trebuchet20")
	surface.SetTextColor(255, 255, 255, 255)
	local x, y = surface.GetTextSize(client:Health() .. " %")
	surface.SetTextPos((intHealthBoxWidth / 2) - (x / 2), SH - (intHealthBoxHieght / 2) - (y / 2))
	surface.DrawText(client:Health() .. " %")
	----Cash Box----
	local intCash = client:GetNWInt("cash")
	local intCashBoxWidth = 100
	local intCashBoxHieght = 20
	surface.SetDrawColor(clrHUDBox.r, clrHUDBox.g, clrHUDBox.b, clrHUDBox.a)
	surface.DrawRect(0, SH - (intHealthBoxHieght + intCashBoxHieght), intCashBoxWidth, intCashBoxHieght)
	surface.SetDrawColor(clrHUDBox_Boarder.r, clrHUDBox_Boarder.g, clrHUDBox_Boarder.b, clrHUDBox_Boarder.a)
	surface.DrawOutlinedRect(0, SH - (intHealthBoxHieght + intCashBoxHieght), intCashBoxWidth, intCashBoxHieght)
	surface.SetFont("Trebuchet20")
	local x,y = surface.GetTextSize("$" .. intCash)
	surface.SetTextPos(5, SH - (intHealthBoxHieght + (intCashBoxHieght)))
	surface.DrawText("$" .. intCash)
	if client:GetActiveWeapon() && client:GetActiveWeapon():IsValid() && client:GetActiveWeapon():GetClass() != "weapon_crowbar" then
		if Locker then
			----Primary Item Box----
			local intPrimaryItemBoxWidth = 150
			local intPrimaryItemBoxHieght = 90
			surface.SetDrawColor(clrHUDBox.r, clrHUDBox.g, clrHUDBox.b, clrHUDBox.a)
			surface.DrawRect(SW - intPrimaryItemBoxWidth, SH  - intPrimaryItemBoxHieght, intPrimaryItemBoxWidth, intPrimaryItemBoxHieght)
			surface.SetDrawColor(clrHUDBox_Boarder.r, clrHUDBox_Boarder.g, clrHUDBox_Boarder.b, clrHUDBox_Boarder.a)
			surface.DrawOutlinedRect(SW - intPrimaryItemBoxWidth, SH  - intPrimaryItemBoxHieght, intPrimaryItemBoxWidth, intPrimaryItemBoxHieght)
			--Ammo In Mag--
			local intAmmoInMag = 0
			if client:GetActiveWeapon():Clip1() then intAmmoInMag = client:GetActiveWeapon():Clip1() end
			if intAmmoInMag > 0 then
				surface.SetFont("Trebuchet24")
				local x, y = surface.GetTextSize(intAmmoInMag)
				surface.SetTextPos(SW - intPrimaryItemBoxWidth + 5, SH - 15 - (y / 2))
				surface.DrawText(intAmmoInMag)
			end
			--Ammo In Reserve--
			local intAmmoInReserve = client:GetAmmoCount(client:GetActiveWeapon():GetPrimaryAmmoType())
			if intAmmoInReserve > 0 then
				surface.SetFont("Trebuchet22")
				local x, y = surface.GetTextSize(intAmmoInReserve)
				surface.SetTextPos(SW - 25 - (x / 2), SH - 15 - (y / 2))
				surface.DrawText(intAmmoInReserve)
			end
			local clrPrimaryIcon = Color(255, 255, 255, 125)
			local clrSecondaryIcon = Color(155,155,155,155)
			if client:GetNWInt("ActiveWeapon") != 0 && client:GetNWInt("ActiveWeapon") != 1337 then
				--Primary Icon--
				surface.SetTextColor(clrPrimaryIcon.r, clrPrimaryIcon.g, clrPrimaryIcon.b, clrPrimaryIcon.a)
				surface.SetFont("TXWeaponIcons")
				surface.SetTextPos(SW - intPrimaryItemBoxWidth, SH - intPrimaryItemBoxHieght + 5)
				surface.DrawText(Weapons[client:GetActiveWeapon():GetClass()].Icon)
				--Secondary Icon--
				surface.SetTextColor(clrSecondaryIcon.r, clrSecondaryIcon.g, clrSecondaryIcon.b, clrSecondaryIcon.a)
				surface.SetTextPos(SW - 80, SH - 130)
				surface.SetFont("TXSmallWeaponIcons")
				if Locker[client:GetNWInt("Weapon1")] && Locker[client:GetNWInt("Weapon2")] then
					if client:GetNWInt("Weapon1") == client:GetNWInt("ActiveWeapon") && client:GetNWInt("Weapon2") != 0 && client:GetNWInt("Weapon2") != 1337 then
						surface.DrawText(Weapons[Locker[client:GetNWInt("Weapon2")].Weapon].Icon)
					elseif client:GetNWInt("Weapon2") == client:GetNWInt("ActiveWeapon") && client:GetNWInt("Weapon1") != 0 && client:GetNWInt("Weapon1") != 1337 then 
						surface.DrawText(Weapons[Locker[client:GetNWInt("Weapon1")].Weapon].Icon)
					end
				end
			end
		end
	end
	for _, player in pairs(player.GetAll()) do
		if !GAMEMODE.ShowScoreboard && player != client then
			local vecPlayerPos = player:GetPos():ToScreen()
			local intDrawAlpha =  55
			clrNameText.a = intDrawAlpha
			draw.SimpleText(player:Nick(), "Trebuchet20", vecPlayerPos.x, vecPlayerPos.y - 90, clrNameText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			if player:GetNWBool("PvpFlag") then
				clrPVPText.a = intDrawAlpha
				draw.SimpleText("PvP", "Trebuchet20", vecPlayerPos.x, vecPlayerPos.y - 105, clrPVPText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			if player:GetNWBool("LockerZone") then
				clrLockerText.a = intDrawAlpha
				if !player:GetNWBool("PvpFlag") then
					draw.SimpleText("Locker Zone", "Trebuchet20", vecPlayerPos.x, vecPlayerPos.y - 105, clrLockerText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				else
					draw.SimpleText("Locker Zone", "Trebuchet20", vecPlayerPos.x, vecPlayerPos.y - 115, clrLockerText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			end
		end
	end
end