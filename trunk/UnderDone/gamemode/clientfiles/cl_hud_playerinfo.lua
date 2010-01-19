local function DrawPlayerInfo()
	local trcEyeTrace = LocalPlayer():GetEyeTraceNoCursor()
	local entPlayer = trcEyeTrace.Entity
	if !entPlayer:IsPlayer() then return end
	local posPlayerPos = (entPlayer:GetPos() + Vector(0, 0, 80)):ToScreen()
	local strPlayerName = entPlayer:Nick()
	surface.SetFont("UiBold")
	local wide, high = surface.GetTextSize(strPlayerName)
	draw.SimpleTextOutlined(strPlayerName, "UiBold", posPlayerPos.x, posPlayerPos.y, clrWhite, 1, 1, 1, clrDrakGray)
	local strIcon = "gui/player"
	if entPlayer:IsAdmin() then strIcon = "gui/admin" end
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetTexture(surface.GetTextureID(strIcon))
	surface.DrawTexturedRect(posPlayerPos.x + wide + 20, posPlayerPos.y - 8, 16, 16)
end
hook.Add("HUDPaint", "DrawPlayerInfo", DrawPlayerInfo)