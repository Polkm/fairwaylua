mk_convarKartColor = CreateClientConVar("mk_kartColor", "red", true, true)
mk_convarCharacter = CreateClientConVar("mk_Character", "Mario", true, true)
mk_convarMusic = CreateClientConVar("mk_Music", 1, true, true)
mk_CharacterPanel = nil

function GM:DrawCharacterCreation()
	gui.EnableScreenClicker(true)
	mk_CharacterPanel = vgui.Create("DPanel")
	mk_CharacterPanel:SetSize(200, 100)
	mk_CharacterPanel:Center()
	mk_CharacterPanel.Paint = function()
		draw.RoundedBox(4, 0, 0, mk_CharacterPanel:GetWide(), mk_CharacterPanel:GetTall(), Color(100, 100, 100, 255))
	end
	
	local CharacterColorSellection = vgui.Create("DMultiChoice", mk_CharacterPanel)
	CharacterColorSellection:SetSize(190, 20)
	CharacterColorSellection:SetPos(5, 5)
	for color, texture in pairs(GAMEMODE.PosibleColors) do
		CharacterColorSellection:AddChoice(color)
	end
	CharacterColorSellection:ChooseOption(mk_convarKartColor:GetString())
	CharacterColorSellection.OnSelect = function(index, value, data)
		RunConsoleCommand("mk_kartColor", data)
		RunConsoleCommand("MarioKartCRCLR", data)
	end
	
	local CharacterSellection = vgui.Create("DMultiChoice", mk_CharacterPanel)
	CharacterSellection:SetSize(190, 20)
	CharacterSellection:SetPos(5, 30)
	for char, tbl in pairs(GAMEMODE.Characters) do
		CharacterSellection:AddChoice(tbl.Name)
	end
	CharacterSellection:ChooseOption(mk_convarCharacter:GetString())
	CharacterSellection.OnSelect = function(index, value, data)
		RunConsoleCommand("mk_Character", data)
		RunConsoleCommand("MarioKartCHRCTR", data)
	end
	
	local MusicCheckBox = vgui.Create("DCheckBoxLabel", mk_CharacterPanel)
	MusicCheckBox:SetPos(5, 55)
	MusicCheckBox:SetText("Music")
	MusicCheckBox:SetConVar("mk_Music")
	MusicCheckBox:SizeToContents()
	MusicCheckBox.OnChange = function()
		if mk_convarMusic:GetBool() then
			--GAMEMODE:OnAllMusic()
		else
			--GAMEMODE:OffAllMusic()
		end
	end
 
	local DoneButton = vgui.Create( "DButton", mk_CharacterPanel)
	DoneButton:SetSize(190, 20)
	DoneButton:SetPos(5, 75)
	DoneButton:SetText("Done")
	DoneButton.DoClick = function(DoneButton)
		mk_CharacterPanel:Remove()
		gui.EnableScreenClicker(false)
	end
end
concommand.Add("mk_characterCreation", function()
	if !mk_CharacterPanel or !mk_CharacterPanel:IsValid() then
		GAMEMODE:DrawCharacterCreation()
	end
end)

concommand.Add("mk_characterDefault", function()
	RunConsoleCommand("MarioKartCRCLR", mk_convarKartColor:GetString())
	RunConsoleCommand("MarioKartCHRCTR", mk_convarCharacter:GetString())
end)


