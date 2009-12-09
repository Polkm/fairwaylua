include('shared.lua')

function GM:PositionScoreboard(ScoreBoard)
	ScoreBoard:SetSize(700, ScrH() - 100)
	ScoreBoard:SetPos((ScrW() - ScoreBoard:GetWide()) / 2, 50)
end

function GM:ShowClassChooser(TEAMID)
	if !GAMEMODE.SelectClass then return end
	print(GetGlobalEntity("TERRORISTbomber"))
	if LocalPlayer() then return end
	if ClassChooser then ClassChooser:Remove() end

	ClassChooser = vgui.CreateFromTable(vgui_Splash)
	ClassChooser:SetHeaderText("Choose Class")
	ClassChooser:SetHoverText("What class do you want to be?")
	Classes = team.GetClass(TEAMID)
	
	for _, name in SortedPairs(Classes) do
		local displayname = name
		local Class = player_class.Get(name)
		if Class && Class.DisplayName then
			displayname = Class.DisplayName
		end

		local description = "Click to spawn as " .. displayname
		if Class and Class.Description then
			description = Class.Description
		end
		
		local func = function()
			if cl_classsuicide:GetBool() then
				RunConsoleCommand("kill")
			end
			RunConsoleCommand("changeclass", k)
		end
		local btn = ClassChooser:AddSelectButton(displayname, func, description)
		btn.m_colBackground = team.GetColor(TEAMID)
	end
	
	ClassChooser:AddCancelButton()
	ClassChooser:MakePopup()
	ClassChooser:NoFadeIn()
end

function GM:PlayAlert(type)
	local client = LocalPlayer()
	client:EmitSound(GAMEMODE.Alerts[type].sound, 100,100)
end
