include( 'shared.lua' )

function GM:Initialize()
	gui.EnableScreenClicker(true)
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
	for k, weapon in pairs(LocalPlayer():GetWeapons()) do
		if weapon != LocalPlayer():GetActiveWeapon() then
			RunConsoleCommand("FS_SwitchWep", weapon:GetClass())
		end
	end
end
function GM:HUDPaint( ) 
	local SW = ScrW()
	local SH = ScrH()
	local client = LocalPlayer()
	local Money = client:GetNWInt("Cash")
	for k,v in pairs(player.GetAll()) do
		if v != LocalPlayer() then 
			local pos = v:GetPos():ToScreen()
			local DrawColor = Color(200,200,200,255/math.Round( 1 + LocalPlayer():GetPos():Distance(v:GetPos()))*50)
			if LocalPlayer():GetPos():Distance(v:GetPos()) <= 50 then
				DrawColor = Color(200,200,200,255)
			elseif 	LocalPlayer():GetPos():Distance(v:GetPos()) >= 2000 then
				DrawColor = Color(200,200,200,0)
			end
		draw.SimpleText(v:Nick(),"UIBold",pos.x ,pos.y - 70,DrawColor,TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
end

function GM:Think()
	if CammeraPosition then
		local ply = LocalPlayer()
		local tracedata = {}
		tracedata.start = CammeraPosition
		tracedata.endpos = CammeraPosition + (ply:GetCursorAimVector() * 4000)
		tracedata.filter = ply
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