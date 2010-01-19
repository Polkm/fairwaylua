local function DrawNPCIcon(entNPC, posNPCPos)
	local strIcon = "gui/silkicons/emoticon_smile"
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetTexture(surface.GetTextureID(strIcon))
	surface.DrawTexturedRect(posNPCPos.x, posNPCPos.y - 25, 16, 16)
end

local function DrawNameText(entNPC, posNPCPos, boolFriendly)
	local tblNPCTable = NPCTable(entNPC:GetNWInt("npc"))
	local intLevel = entNPC:GetNWInt("level")
	local plylevel = LocalPlayer():GetLevel()
	local clrDrawColor = clrWhite
	if intLevel < plylevel then clrDrawColor = clrGreen end
	if intLevel > plylevel then clrDrawColor = clrRed end
	if boolFriendly then clrDrawColor = clrWhite end
	draw.SimpleTextOutlined(tblNPCTable.NPCType or "", "UiBold", posNPCPos.x, posNPCPos.y - 20, clrDrawColor, 1, 1, 1, clrDrakGray)
	local strDrawText = tblNPCTable.PrintName
	if !boolFriendly then strDrawText = strDrawText .. " lv. " .. intLevel end
	draw.SimpleTextOutlined(strDrawText, "UiBold", posNPCPos.x, posNPCPos.y - 10, clrDrawColor, 1, 1, 1, clrDrakGray)
	if boolFriendly then
		surface.SetFont("UiBold")
		local wide, high = surface.GetTextSize(strDrawText)
		posNPCPos.x = posNPCPos.x + wide + 20
		DrawNPCIcon(entNPC, posNPCPos)
	end
end

local function DrawNPCHealthBar(entNPC, posNPCPos)
	local clrBarColor = clrGreen
	local intHealth = entNPC:GetNWInt("Health")
	local intMaxHealth = entNPC:GetNWInt("MaxHealth")
	if intHealth <= (intMaxHealth * 0.2) then clrBarColor = clrRed end
	local NpcHealthBar = jdraw.NewProgressBar()
	NpcHealthBar:SetDemensions(posNPCPos.x  - (80 / 2), posNPCPos.y, 80, 11)
	NpcHealthBar:SetStyle(4, clrBarColor)
	NpcHealthBar:SetBoarder(1, clrDrakGray)
	NpcHealthBar:SetText("UiBold", intHealth, clrDrakGray)
	NpcHealthBar:SetValue(intHealth, intMaxHealth)
	jdraw.DrawProgressBar(NpcHealthBar)
end

local function DrawNPCInfo()
	local trcEyeTrace = LocalPlayer():GetEyeTraceNoCursor()
	local entNPC = trcEyeTrace.Entity
	if !entNPC:IsNPC() then return end
	if entNPC:GetNWInt("level") <= 0 then return end
	
	local tblNPCTable = NPCTable(entNPC:GetNWInt("npc"))
	local boolFriendly = tblNPCTable.Race == "human"
	local posNPCPos = (entNPC:GetPos() + Vector(0, 0, 80)):ToScreen()
	
	DrawNameText(entNPC, posNPCPos, boolFriendly)
	if !boolFriendly then DrawNPCHealthBar(entNPC, posNPCPos) end
end
hook.Add("HUDPaint", "DrawNPCInfo", DrawNPCInfo)