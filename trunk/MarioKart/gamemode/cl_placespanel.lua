function GM:DrawPlacesPanel()
	local intNumberPlayer = #player.GetAll()
	local intCurrentPlace = 1
	local intMaxPlaces = 5
	local intYOffset = 15
	local intYOffsetEach = 50
	local PlacesPanel = vgui.Create("DPanel")
	PlacesPanel:SetPos(20, 100)
	PlacesPanel:SetSize(300, intMaxPlaces * intYOffsetEach + 20)
	PlacesPanel.Paint = function() end
	for i = 1, intMaxPlaces do
		local plyFoundPlayer = GAMEMODE:FindPlayer(intCurrentPlace)
		local PlaceText = vgui.Create("DLabel", PlacesPanel)
		PlaceText:SetPos(5, intYOffset)
		PlaceText:SetFont("HUDNumber")
		PlaceText:SetColor(Color(255, 255, 255, 255))
		PlaceText:SetText(intCurrentPlace)
		
		local AvitarImage = vgui.Create("AvatarImage", PlacesPanel)
		AvitarImage:SetPos(30, intYOffset - 5)
		AvitarImage:SetSize(32, 32)
		AvitarImage:SetPlayer(plyFoundPlayer)
		
		local NameText = vgui.Create("DLabel", PlacesPanel)
		NameText:SetPos(70, intYOffset)
		NameText:SetSize(300, 20)
		NameText:SetFont("Trebuchet24")
		NameText:SetColor(Color(255, 255, 255, 255))
		NameText:SetText(plyFoundPlayer:Nick())
		
		intYOffset = intYOffset + intYOffsetEach
		intCurrentPlace = intCurrentPlace + 1
		if intNumberPlayer < intCurrentPlace then break end
	end
	timer.Simple(0.5, function() GAMEMODE:UpdatelacesPanel(PlacesPanel) end)
end

function GM:UpdatelacesPanel(PlacesPanel)
	PlacesPanel:Remove()
	GAMEMODE:DrawPlacesPanel()
end

function GM:FindPlayer(intPlace)
	for _, player in pairs(player.GetAll()) do
		if player:GetNWInt("Place") == intPlace then
			return player
		end
	end
end



