local mk_convarKartColor = CreateClientConVar("mk_kartColor", "red", true, true)
local mk_convarCharacter = CreateClientConVar("mk_Character", "Mario", true, true)
local mk_CharacterPanel = nil
local mk_PlacesPanel = nil

function GM:DrawPlacesPanel()
	local intNumberPlayer = #player.GetAll()
	local intCurrentPlace = 1
	local intMaxPlaces = 5
	local intYOffset = 15
	local intYOffsetEach = 50
	mk_PlacesPanel = vgui.Create("DPanel")
	mk_PlacesPanel:SetPos(20, 100)
	mk_PlacesPanel:SetSize(300, intMaxPlaces * intYOffsetEach + 20)
	mk_PlacesPanel.Paint = function() end
	for i = 1, intMaxPlaces do
		local plyFoundPlayer = GAMEMODE:FindPlayer(intCurrentPlace)
		local PlaceText = vgui.Create("DLabel", mk_PlacesPanel)
		PlaceText:SetPos(5, intYOffset)
		PlaceText:SetFont("HUDNumber")
		PlaceText:SetColor(Color(255, 255, 255, 255))
		PlaceText:SetText(intCurrentPlace)
		
		local AvitarImage = vgui.Create("AvatarImage", mk_PlacesPanel)
		AvitarImage:SetPos(30, intYOffset - 5)
		AvitarImage:SetSize(32, 32)
		AvitarImage:SetPlayer(plyFoundPlayer)
		
		local NameText = vgui.Create("DLabel", mk_PlacesPanel)
		NameText:SetPos(70, intYOffset)
		NameText:SetSize(300, 20)
		NameText:SetFont("Trebuchet24")
		NameText:SetColor(Color(255, 255, 255, 255))
		NameText:SetText(plyFoundPlayer:Nick())
		
		intYOffset = intYOffset + intYOffsetEach
		intCurrentPlace = intCurrentPlace + 1
		if intNumberPlayer < intCurrentPlace then break end
	end
	timer.Simple(0.5, function() GAMEMODE:UpdatelacesPanel() end)
end

function GM:UpdatelacesPanel()
	if mk_PlacesPanel then
		mk_PlacesPanel:Remove()
		GAMEMODE:DrawPlacesPanel()
	end
end

function GM:FindPlayer(intPlace)
	for _, player in pairs(player.GetAll()) do
		if player:GetNWInt("Place") == intPlace then
			return player
		end
	end
end

function GM:DrawCharacterCreation()
	gui.EnableScreenClicker(true)
	mk_CharacterPanel = vgui.Create("DPanel")
	mk_CharacterPanel:SetSize(150, 100)
	mk_CharacterPanel:Center()
	
	local CharakterColor = vgui.Create("DMultiChoice", mk_CharacterPanel)
	CharakterColor:SetSize(140, 20)
	CharakterColor:SetPos(5, 5)
	for color, texture in pairs(GAMEMODE.PosibleColors) do
		CharakterColor:AddChoice(color)
	end
	CharakterColor:ChooseOption(mk_convarKartColor:GetString())
	CharakterColor.OnSelect = function(index, value, data)
		RunConsoleCommand("mk_kartColor", data)
		RunConsoleCommand("mk_changeCarColor", data)
	end
	
	local Charakter = vgui.Create("DMultiChoice", mk_CharacterPanel)
	Charakter:SetSize(140, 20)
	Charakter:SetPos(5, 30)
	for char, tbl in pairs(GAMEMODE.Characters) do
		Charakter:AddChoice(tbl.Name)
	end
	Charakter:ChooseOption(mk_convarCharacter:GetString())
	Charakter.OnSelect = function(index, value, data)
		RunConsoleCommand("mk_Character", data)
		RunConsoleCommand("mk_changeCharacter", data)
	end
	
	local DoneButton = vgui.Create( "DButton", mk_CharacterPanel)
	DoneButton:SetSize(140, 20)
	DoneButton:SetPos(5, 75)
	DoneButton:SetText("Done")
	DoneButton.DoClick = function(DoneButton)
		mk_CharacterPanel:Remove()
		gui.EnableScreenClicker(false)
	end
end
concommand.Add("mk_characterCreation", function()
	if !mk_CharacterPanel:IsValid() then
		GAMEMODE:DrawCharacterCreation()
	end
end)
concommand.Add("mk_characterDefault", function()
	RunConsoleCommand("mk_changeCarColor", mk_convarKartColor:GetString())
	RunConsoleCommand("mk_changeCharacter", mk_convarCharacter:GetString())
end)


