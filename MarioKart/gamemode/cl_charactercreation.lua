local mk_convarKartColor = CreateClientConVar("mk_kartColor", "red", true, true)
local mk_convarCharacter = CreateClientConVar("mk_Character", "Mario", true, true)
local mk_CharacterPanel = nil

function GM:DrawCharacterCreation()
	gui.EnableScreenClicker(true)
	mk_CharacterPanel = vgui.Create("DPanel")
	mk_CharacterPanel:SetSize(150, 100)
	mk_CharacterPanel:Center()
	
	local CharacterColorSellection = vgui.Create("DMultiChoice", mk_CharacterPanel)
	CharacterColorSellection:SetSize(140, 20)
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
	CharacterSellection:SetSize(140, 20)
	CharacterSellection:SetPos(5, 30)
	for char, tbl in pairs(GAMEMODE.Characters) do
		CharacterSellection:AddChoice(tbl.Name)
	end
	CharacterSellection:ChooseOption(mk_convarCharacter:GetString())
	CharacterSellection.OnSelect = function(index, value, data)
		RunConsoleCommand("mk_Character", data)
		RunConsoleCommand("MarioKartCHRCTR", data)
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
	if !mk_CharacterPanel or !mk_CharacterPanel:IsValid() then
		GAMEMODE:DrawCharacterCreation()
	end
end)

concommand.Add("mk_characterDefault", function()
	RunConsoleCommand("MarioKartCRCLR", mk_convarKartColor:GetString())
	RunConsoleCommand("MarioKartCHRCTR", mk_convarCharacter:GetString())
end)


