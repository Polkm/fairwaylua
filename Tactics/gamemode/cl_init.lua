require("datastream")
include( 'shared.lua' )
include( "cl_menus.lua" )
surface.CreateFont("csd", ScreenScale(40), 500, true, true, "CSSelectIcons")
surface.CreateFont("csd", ScreenScale(120), 500, true, true,"CSHugeSelectIcons" )
Locker = {}

function RecieveDataFromServer(handler, id, encoded, decoded)
	Locker = decoded.LockerTable
	Updated = true
end  
datastream.Hook("LockerTransfer", RecieveDataFromServer)

function GM:Initialize()
	gui.EnableScreenClicker(true)
	vgui.GetWorldPanel():SetCursor( "crosshair" )
end

function GM:GUIMousePressed(input)
	if input == MOUSE_LEFT then LocalPlayer():ConCommand("+attack") end
	if input == MOUSE_RIGHT then LocalPlayer():ConCommand("+attack2") end
end
function GM:GUIMouseReleased(input)
	if input == MOUSE_LEFT then LocalPlayer():ConCommand("-attack") end
	if input == MOUSE_RIGHT then LocalPlayer():ConCommand("-attack2") end
end
function GM:OnSpawnMenuClose()
	RunConsoleCommand("FS_SwitchWep")
end

function GM:HUDShouldDraw(Name)
	if Name == "CHudHealth" or Name == "CHudBattery" or Name =="CHudSecondaryAmmo" or Name == "CHudAmmo" or Name == "CHudWeaponSelection" then
		return false
	end	
	return true
end

function GM:HUDPaint() 
	if !Updated then return end
	local SW = ScrW()
	local SH = ScrH()
	local client = LocalPlayer()
	local Money = client:GetNWInt("cash")
	local PvPColor = Color(200, 100, 100, 0)
	local LockerColor = Color(100, 200, 100, 0)

	if client:Health() > 0 && client:Alive() then
	
		local Mag_In = client:GetActiveWeapon():Clip1()
		local Mag_Out = client:GetAmmoCount(client:GetActiveWeapon():GetPrimaryAmmoType())
		-- Health Box
		surface.SetDrawColor(140,140,140,100)
		surface.DrawRect(SW - SW  , SH - 50, 300 ,50)
		surface.SetDrawColor(50,50,50,100)
		surface.DrawOutlinedRect(SW - SW - 1 , SH - 51, 301 ,51)
		surface.SetDrawColor(80,80,80,100)
		surface.DrawRect(SW - SW + 10 , SH- 37.5, 280 ,25)
		surface.SetDrawColor(50,50,50,50)
		surface.DrawOutlinedRect(SW - SW + 10 , SH- 38.5, 281 ,26)
		surface.SetTextColor(255,255,255,255)
		surface.SetFont("UIBold")
		surface.SetDrawColor((100-client:Health())*2.55, client:Health()*2.55, 0, 95)
		surface.DrawRect(SW - SW + 10 , SH- 37.5, 280/(100/client:Health()) ,25)
		local x,y = surface.GetTextSize(client:Health().." %")
		surface.SetTextPos(SW - SW + 130 +x/2,SH  - 25  - y/2)
		surface.DrawText(client:Health().." %")
		-- Cash Box
		surface.SetDrawColor(120,120,120,100)
		surface.DrawRect(SW - SW  , SH - 90, 50 ,40)
		surface.SetDrawColor(30,30,30,100)
		surface.DrawOutlinedRect(SW - SW - 1 , SH - 91, 51 ,41)
		surface.SetFont("UIBold")
		local x,y = surface.GetTextSize("$ "..Money)
		surface.SetTextPos(SW - SW + 0 +x/2,SH  - 72.5  - y/2)
		surface.DrawText("$ "..Money)
		-- Bullet mag out
		surface.SetTextColor(255,255,255,255)
		surface.SetFont("Trebuchet22")
		local x,y = surface.GetTextSize(Mag_Out)
		surface.SetTextPos(SW - 25 - x/2 ,SH - 15 - y/2)
		surface.DrawText(Mag_Out)
		--Mag in
		surface.SetFont("Trebuchet24")
		local x,y = surface.GetTextSize(Mag_In)
		surface.SetTextPos(SW - 130 - x/2 ,SH - 15 - y/2)
		surface.DrawText(Mag_In)
		-- Primary Item
		surface.SetDrawColor(120,120,120,100)
		surface.DrawRect(SW - 150 , SH  - 90, 200 ,90)
		surface.SetDrawColor(70,70,70,100)
		surface.DrawOutlinedRect(SW - 150 - 1 , SH- 91, 201 ,91)
		if client:GetNWInt("ActiveWeapon") != 0 && client:GetNWInt("ActiveWeapon") != -1 then
			surface.SetTextColor(255,255,255,125)
			surface.SetFont("CSHugeSelectIcons")
			surface.SetTextPos(SW - 150,SH - 85)
			surface.DrawText(Weapons[client:GetActiveWeapon():GetClass()].Icon)--Pistol
			surface.SetTextColor(155,155,155,155)
			surface.SetTextPos(SW - 80,SH - 130)
			surface.SetFont("CSSelectIcons")
			if client:GetNWInt("Weapon1") == client:GetNWInt("ActiveWeapon")  && client:GetNWInt("Weapon2") != 0 && client:GetNWInt("Weapon2") != -1 then 
				surface.DrawText(Weapons[Locker[client:GetNWInt("Weapon2")].Weapon].Icon)--Pistol
			elseif client:GetNWInt("Weapon2") == client:GetNWInt("ActiveWeapon") && client:GetNWInt("Weapon1") != 0 && client:GetNWInt("Weapon1") != -1 then 
				surface.DrawText(Weapons[Locker[client:GetNWInt("Weapon1")].Weapon].Icon)--Pistol
			end
			surface.SetDrawColor(55,55,55,130)
		end
	end
		for k,v in pairs(player.GetAll()) do
			local pos = v:GetPos():ToScreen()
			local DrawColor = Color(200, 200, 200, (255 / math.Round(1 + LocalPlayer():GetPos():Distance(v:GetPos())) * 50))
			if LocalPlayer():GetPos():Distance(v:GetPos()) <= 50 then
				DrawColor = Color(200, 200, 200, 255)
			elseif LocalPlayer():GetPos():Distance(v:GetPos()) >= 2000 then
				DrawColor = Color(200, 200, 200, 0)
			end
			if v:GetNWBool("PvpFlag") then
				PvPColor.a = DrawColor.a
				draw.SimpleText("PvP", "Trebuchet20", pos.x, pos.y - 115, PvPColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			if v:GetNWBool("LockerZone") then
				local LockerColor = Color(100, 200, 100, 0)
				LockerColor.a = DrawColor.a
				if !v:GetNWBool("PvpFlag") then
					draw.SimpleText("Locker Zone", "Trebuchet20", pos.x, pos.y - 115, LockerColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				else
					draw.SimpleText("Locker Zone", "Trebuchet20", pos.x, pos.y - 125, LockerColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			end
			draw.SimpleText(v:Nick(), "Trebuchet20", pos.x, pos.y - 100, DrawColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			//draw.SimpleText("$" .. v:GetNWInt("cash"), "Trebuchet20", pos.x, pos.y - 85, DrawColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
end

function GM:Tick()
	local ply = LocalPlayer()
	if CammeraPosition && ply:Alive() then
		local tracedata = {}
		tracedata.start = CammeraPosition
		tracedata.endpos = CammeraPosition + (ply:GetCursorAimVector() * 4000)
		local filterTable = ents.FindByClass("func_brush")
		table.insert(filterTable, ply)
		tracedata.filter = filterTable
		local trace = util.TraceLine(tracedata)
		local Ang = (trace.HitPos - ply:EyePos()):Angle() -- Gets the angle between the two points
		ply:SetEyeAngles(Ang) -- Sets the angle
	end
end

function GM:CalcView(ply,origin,angles,fov)

	if !CammeraPosition then CammeraPosition = ply:GetPos() end
	if !CammeraAngle then CammeraAngle = Angle(0, 0, 0) end
	if !ply.AddativeCamAngle then ply.AddativeCamAngle = 0 end
	if !ply.AddativeCamPos then ply.AddativeCamPos = Vector(0, 0, 0) end
	
	CammeraPosition = CammeraPosition + ((ply:GetIdealCamPos() - CammeraPosition) / CammeraSmoothness)
	CammeraAngle = CammeraAngle + ((ply:GetIdealCamAngle() - CammeraAngle) * (1 / CammeraSmoothness))
	
	local view = {}
	view.origin = CammeraPosition
	view.angles = CammeraAngle
	return view
end