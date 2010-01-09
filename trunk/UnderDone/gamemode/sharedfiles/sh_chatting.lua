if SERVER then
	function GM:CanHearPlayersVoice(plyFirst, plySecond)
		if !IsValid(plySecond) || !IsValid(plyFirst) then return false end --InValid
		local intChatDistance = 3000
		if plyFirst:GetPos():Distance(plySecond:GetPos()) >= intChatDistance then return false end --Too Far
		return true --All good :)
	end

	function GM:PlayerCanSeePlayersChat(strText, bTeamOnly, pListener, pSpeaker)
		if !IsValid(pSpeaker) || !IsValid(pListener) then return false end --InValid
		local tblText = string.ToTable(strText)
		local intChatDistance = 700
		if tblText[#tblText] == "!" && #tblText > 1 then intChatDistance = 7000 end
		if pListener:GetPos():Distance(pSpeaker:GetPos()) >= intChatDistance then return false end --Too Far
		return true --All good :)
	end
end

if CLIENT then
	function GM:OnPlayerChat(plySpeaker, strText, boolTeamOnly, boolPlayerIsDead)
		local tblText = string.ToTable(strText)
		local clrPlayerName = clrWhite
		local clrChat = clrWhite
		local boolDisplayName = true
		if plySpeaker == LocalPlayer() then clrPlayerName = clrGray end
		if tblText[1] == "*" and tblText[#tblText] == "*" && #tblText > 2 then clrChat = clrGreen end
		if tblText[#tblText] == "!" && #tblText > 1 then clrChat = clrOrange end
		if boolDisplayName then
			chat.AddText(clrPlayerName, plySpeaker:Nick(), ": ", clrChat,  strText)
		else
			chat.AddText(clrChat, strText)
		end
		return true
	end
end