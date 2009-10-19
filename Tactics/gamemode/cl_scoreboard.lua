function GM:HUDDrawScoreBoard()
	if !GAMEMODE.ShowScoreboard then return end
	----Player Names----
	local client = LocalPlayer()
	local clrNameText = Color(200, 200, 200, 0)
	local clrPVPText = Color(200, 100, 100, 0)
	local clrLockerText = Color(100, 200, 100, 0)
	for _, player in pairs(player.GetAll()) do
		local vecPlayerPos = player:GetPos():ToScreen()
		local intDrawAlpha = 255
		clrNameText.a = intDrawAlpha
		local intYOffset = vecPlayerPos.y
		draw.SimpleText("$" .. player:GetNWInt("Cash"), "Trebuchet20", vecPlayerPos.x, intYOffset , clrNameText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)		
		intYOffset = intYOffset - 20
		draw.SimpleText(player:Nick(), "Trebuchet20", vecPlayerPos.x, intYOffset, clrNameText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		intYOffset = intYOffset - 20
		if player:GetNWBool("PvpFlag") then
			clrPVPText.a = intDrawAlpha
			draw.SimpleText("PvP", "Trebuchet20", vecPlayerPos.x, intYOffset, clrPVPText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			intYOffset = intYOffset - 20
		end
		if player:GetNWBool("LockerZone") then
			clrLockerText.a = intDrawAlpha
			draw.SimpleText("Locker Zone", "Trebuchet20", vecPlayerPos.x, intYOffset, clrLockerText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			intYOffset = intYOffset - 20
		end
		if player:GetActiveWeapon() && Weapons[player:GetActiveWeapon():GetClass()] then
			draw.SimpleText(Weapons[player:GetActiveWeapon():GetClass()].Icon, "TXSmallWeaponIcons", vecPlayerPos.x, intYOffset, clrNameText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
end
