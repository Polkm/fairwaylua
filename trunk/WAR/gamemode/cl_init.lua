include('shared.lua')
include('units.lua')
SelectionNode1, SelectionNode2 = Vector(0, 0, 0), Vector(0, 0, 0)
BoxSellecting = false

function GM:Initialize()
	--Polkm: Need this for click'n
	gui.EnableScreenClicker(true)
end

function GM:GUIMousePressed(input)
	local ply = LocalPlayer()
	if input == MOUSE_LEFT then
		local x, y = gui.MousePos()
		SelectionNode1 = Vector(x, y, 0)
		BoxSellecting = true
	end
end

function GM:GUIMouseReleased(input)
	local ply = LocalPlayer()
	local tracedata = {}
	tracedata.start = CammeraPosition
	tracedata.endpos = CammeraPosition + (ply:GetCursorAimVector() * 10000)
	tracedata.filter = ply
	local trace = util.TraceLine(tracedata)
	if input == MOUSE_LEFT then
		local x, y = gui.MousePos()
		SelectionNode2 = Vector(x, y, 0)
		RunConsoleCommand("WAR_UnSellect")
		if SelectionNode1.x + 3 < SelectionNode2.x && SelectionNode1.y + 3 < SelectionNode2.y then
			--Polkm: This is the box sellect
			for k, entity in pairs(ents.FindByClass("ent_plrunit")) do
				if entity:GetPos():ToScreen().x >= SelectionNode1.x && entity:GetPos():ToScreen().x <= SelectionNode2.x &&
					entity:GetPos():ToScreen().y >= SelectionNode1.y && entity:GetPos():ToScreen().y <= SelectionNode2.y then
					RunConsoleCommand("WAR_Sellect", entity:EntIndex())
				end
			end
		else
			--Polkm: This is the click sellect
			print(trace.Entity:GetClass())
			if trace.Entity then
				if trace.Entity:GetClass() == "ent_plrunit" && trace.Entity:GetOwner() == ply then
					RunConsoleCommand("WAR_Sellect", trace.Entity:EntIndex())
				end
			end
		end
		BoxSellecting = false
	end
	if input == MOUSE_RIGHT then
		if trace.HitWorld then
			RunConsoleCommand("WAR_MoveUnits", trace.HitPos.x, trace.HitPos.y, trace.HitPos.z)
		elseif trace.Entity then
			if trace.Entity:GetClass() == "ent_plrunit" then
				RunConsoleCommand("WAR_Sellect", trace.Entity:EntIndex())
			end
		end
	end
end

function GM:HUDPaint()
	local x, y = gui.MousePos()
	local MousePos = Vector(x, y, 0)
	if BoxSellecting && MousePos.x - SelectionNode1.x > 3 && MousePos.y - SelectionNode1.y > 3 then
		surface.SetDrawColor(50, 50, 50, 200)
		surface.DrawOutlinedRect(SelectionNode1.x, SelectionNode1.y, MousePos.x - SelectionNode1.x, MousePos.y - SelectionNode1.y)
		surface.SetDrawColor(20, 150, 20, 50)
		surface.DrawRect(SelectionNode1.x + 1, SelectionNode1.y + 1, MousePos.x - SelectionNode1.x - 2, MousePos.y - SelectionNode1.y - 2)
	end
end

function GM:CalcView(ply, origin, angles, fov)
	--Polkm: If it doesn't exist, make it
	if !CammeraPosition then CammeraPosition = ply:GetPos() end
	if !CammeraAngle then CammeraAngle = Angle(0, 0, 0) end
	--Polkm: Smoothing out the cam positon and angles
	CammeraPosition = CammeraPosition + ((ply:GetIdealCamPos() - CammeraPosition) / GAMEMODE.CammeraSmoothness)
	CammeraAngle = CammeraAngle + ((ply:GetIdealCamAngle() - CammeraAngle) * (1 / GAMEMODE.CammeraSmoothness))
	--Polkm: Set the postion and angles
	local view = {}
	view.origin = CammeraPosition
	view.angles = CammeraAngle
	ply:SetEyeAngles(Angle(0, GAMEMODE.IdealCammeraAngle.y, 0))
	return view
end
