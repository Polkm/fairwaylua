function GM:HUDDrawScoreBoard()
	if !GAMEMODE.ShowScoreboard then return end
	----Player Names----
	local client = LocalPlayer()
	local clrNameText = Color(200, 200, 200, 0)
	local clrPVPText = Color(200, 100, 100, 0)
	local clrLockerText = Color(100, 200, 100, 0)
	for _, player in pairs(player.GetAll()) do
		local vecPlayerPos = player:GetPos():ToScreen()
		local intDrawAlpha = 255 --/ ((client:GetPos():Distance(player:GetPos()) / 500) + 1)
		clrNameText.a = intDrawAlpha
		draw.SimpleText(player:Nick(), "Trebuchet20", vecPlayerPos.x, vecPlayerPos.y - 20, clrNameText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("$"..player:GetNWInt("Cash"), "Trebuchet20", vecPlayerPos.x, vecPlayerPos.y , clrNameText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)		
		if player:GetNWBool("PvpFlag") then
			clrPVPText.a = intDrawAlpha
			draw.SimpleText("PvP", "Trebuchet20", vecPlayerPos.x, vecPlayerPos.y - 35, clrPVPText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		if player:GetNWBool("LockerZone") then
			clrLockerText.a = intDrawAlpha
			if !player:GetNWBool("PvpFlag") then
				draw.SimpleText("Locker Zone", "Trebuchet20", vecPlayerPos.x, vecPlayerPos.y - 35, clrLockerText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				draw.SimpleText("Locker Zone", "Trebuchet20", vecPlayerPos.x, vecPlayerPos.y - 45, clrLockerText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
	end
end
