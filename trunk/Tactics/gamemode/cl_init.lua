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
	
	--[[
	local tracedata = {}
	tracedata.start = CammeraPosition
	tracedata.endpos = ply:GetPos() + Vector(0, 0, 40)
	tracedata.filter = ply
	local trace = util.TraceLine(tracedata)
	if trace.HitWorld then 
		ply.AddativeCamAngle = math.Clamp(ply.AddativeCamAngle + 1, 0, 45)
		ply.AddativeCamPos.x = math.Clamp(ply.AddativeCamPos.x + 5, 0, 400)
		ply.AddativeCamPos.y = math.Clamp(ply.AddativeCamPos.y + 5, 0, 400)
	else 
		ply.AddativeCamAngle = math.Clamp(ply.AddativeCamAngle - 1, 0, 45) 
		ply.AddativeCamPos.x = math.Clamp(ply.AddativeCamPos.x - 1, 0, 400)
		ply.AddativeCamPos.y = math.Clamp(ply.AddativeCamPos.y - 1, 0, 400)
	end]]
	
	CammeraPosition = CammeraPosition + ((ply:GetIdealCamPos() - CammeraPosition) / CammeraSmoothness)
	CammeraAngle = CammeraAngle + ((ply:GetIdealCamAngle() - CammeraAngle) * (1 / CammeraSmoothness))
	
	local view = {}
	view.origin = CammeraPosition
	view.angles = CammeraAngle
	return view
end