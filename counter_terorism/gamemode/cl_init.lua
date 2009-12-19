include('shared.lua')

function GM:PositionScoreboard(ScoreBoard)
	ScoreBoard:SetSize(700, ScrH() - 100)
	ScoreBoard:SetPos((ScrW() - ScoreBoard:GetWide()) / 2, 50)
end

function GM:HUDDrawTargetID()
     return false
end

function GM:HUDPaint()

	self.BaseClass:HUDPaint()
	
	GAMEMODE:OnHUDPaint()
	GAMEMODE:RefreshHUD()
	local ply =  LocalPlayer()
	local SW,SH = ScrW(), ScrH()
	if ply:Team() == TEAM_COUNTERTERRORIST then 
		if ply:GetNWBool("isdf") == true then
			draw.RoundedBox(0,(SW-1000),(SH-500),200,40,Color(0,0,0,120)) 
			draw.RoundedBox(0,(SW-1000),(SH-500),ply:GetNWInt("dftime")*3.125,40,Color(0,0,155,120))
			draw.SimpleTextOutlined("Defusing","ScoreboardSub",(SW-1000),(SH-500),Color(255,255,255,255),0,0,1,Color(55,55,55,255))
		end
	elseif ply:Team() == TEAM_TERRORIST then 
		if ply:GetNWBool("CanPlant") == true && ply:GetActiveWeapon():IsValid() then
			local drawcolor = Color(255,255,255,255)
			if ply:GetActiveWeapon():GetClass() == "weapon_bombpack" then
				drawcolor = Color(255,0,0,255)
			end
			draw.SimpleTextOutlined("YOU CAN PLANT HERE","ScoreboardHead",(SW/25),(SH/25),drawcolor,0,0,1,Color(55,55,55,255))
		end
	end
	if GetGlobalBool("Bombplanted") && GetGlobalEntity("TheBomb"):IsValid() && GetGlobalInt("BombTime") >= 15 then
		--BombDetection
		local min,max,cen = GetGlobalEntity("TheBomb"):LocalToWorld(GetGlobalEntity("TheBomb"):OBBMins()), GetGlobalEntity("TheBomb"):LocalToWorld(GetGlobalEntity("TheBomb"):OBBMaxs()), GetGlobalEntity("TheBomb"):LocalToWorld(GetGlobalEntity("TheBomb"):OBBCenter())
		local minl,maxl,cenp = min:Distance(cen), max:Distance(cen), cen:ToScreen()
		local minp = (cen + (LocalPlayer():GetRight() * (-1 * minl)) + (LocalPlayer():GetUp() * (-1 * minl))):ToScreen()
		local maxp = (cen + (LocalPlayer():GetRight() * maxl) + (LocalPlayer():GetUp() * maxl)):ToScreen()
		if not cenp.visible then 
			DrawTime = nil 
		return end
		local Color = Color(255,255 - math.Round((255/45) * GetGlobalInt("BombTime")),255 - math.Round((255/45) * GetGlobalInt("BombTime")))
		surface.SetDrawColor(Color,175)
		surface.DrawLine(minp.x,maxp.y,maxp.x,maxp.y)
		surface.DrawLine(minp.x,maxp.y,minp.x,minp.y)
		surface.DrawLine(minp.x,minp.y,maxp.x,minp.y)
		surface.DrawLine(maxp.x,maxp.y,maxp.x,minp.y)
		local text = string.ToMinutesSeconds(45 - GetGlobalInt("BombTime"))
		surface.SetTextColor(Color,255)
		surface.SetTextPos(minp.x+2,maxp.y-15)
		surface.SetFont("DefaultSmallDropShadow")
		surface.DrawText(text)
	end
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
	client:EmitSound(GAMEMODE.Alerts[type].Sound, 100,100)
end

concommand.Add("PlayAlert",function(ply,cmd,args) GAMEMODE:PlayAlert(tostring(args[1])) end)