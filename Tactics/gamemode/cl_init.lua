include( 'shared.lua' )
require("datastream")
Locker = {}

function RecieveDataFromServer(handler, id, encoded, decoded)
	Locker = decoded.LockerTable
	PrintTable(Locker)
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

function GM:HUDPaint() 
	local SW = ScrW()
	local SH = ScrH()
	local client = LocalPlayer()
	local Money = client:GetNWInt("cash")
		for k,v in pairs(player.GetAll()) do
			local pos = v:GetPos():ToScreen()
			local DrawColor = Color(200, 200, 200, 255 / math.Round(1 + LocalPlayer():GetPos():Distance(v:GetPos())) * 50)
			if LocalPlayer():GetPos():Distance(v:GetPos()) <= 50 then
				DrawColor = Color(200, 200, 200, 255)
			elseif LocalPlayer():GetPos():Distance(v:GetPos()) >= 2000 then
				DrawColor = Color(200, 200, 200, 0)
			end
			if v:GetNWBool("PvpFlag") then
				local PvPColor = Color(200, 100, 100, 0)
				PvPColor.a = DrawColor.a
				draw.SimpleText("PvP", "UIBold", pos.x, pos.y - 85, PvPColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			if v:GetNWBool("LockerZone") then
				local LockerColor = Color(100, 200, 100, 0)
				LockerColor.a = DrawColor.a
				if !v:GetNWBool("PvpFlag") then
					draw.SimpleText("Locker Zone", "UIBold", pos.x, pos.y - 85, LockerColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				else
					draw.SimpleText("Locker Zone", "UIBold", pos.x, pos.y - 95, LockerColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			end
			draw.SimpleText(v:Nick(), "UIBold", pos.x, pos.y - 70, DrawColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("$" .. v:GetNWInt("cash"), "UIBold", pos.x, pos.y - 55, DrawColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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