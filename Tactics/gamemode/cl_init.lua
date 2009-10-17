require("datastream")
include("shared.lua")
include("cl_menus.lua")
include("cl_shopmenu.lua")
include("cl_hud.lua")
include("cl_scoreboard.lua")
surface.CreateFont("csd", ScreenScale(40), 500, true, true, "CSSelectIcons")
surface.CreateFont("csd", ScreenScale(120), 500, true, true,"CSHugeSelectIcons" )
Locker = {}
Perks = {}

function RecieveDataFromServer(handler, id, encoded, decoded)
	local decod = decoded
	Locker = decod.LockerTable
	Perks = decod.PerkPerkPerk
end  
datastream.Hook("LockerTransfer", RecieveDataFromServer)

function GM:Initialize()
	gui.EnableScreenClicker(true)
	vgui.GetWorldPanel():SetCursor("crosshair")
end

function GM:GUIMousePressed(input)
	if GAMEMODE.ShowScoreboard then return end
	if input == MOUSE_LEFT then LocalPlayer():ConCommand("+attack") end
	if input == MOUSE_RIGHT then LocalPlayer():ConCommand("+attack2") end
end
function GM:GUIMouseReleased(input)
	if GAMEMODE.ShowScoreboard then return end
	if input == MOUSE_LEFT then LocalPlayer():ConCommand("-attack") end
	if input == MOUSE_RIGHT then LocalPlayer():ConCommand("-attack2") end
end
function GM:OnSpawnMenuClose()
	if GAMEMODE.ShowScoreboard then return end
	RunConsoleCommand("tx_switchWeapon")
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
	if GAMEMODE.ShowScoreboard then
		CammeraPosition = CammeraPosition + Vector(-50 / 1.375, -50 / 1.375, 50)
	end
	CammeraAngle = CammeraAngle + ((ply:GetIdealCamAngle() - CammeraAngle) * (1 / CammeraSmoothness))
	
	local view = {}
	view.origin = CammeraPosition
	view.angles = CammeraAngle
	return view
end

function PaintWeaponItem(weaponPanel, intWeapon, boolShowBars)
	draw.RoundedBox(4, 0, 0, weaponPanel:GetWide(), weaponPanel:GetTall(), Color(100, 100, 100, 150))
	if boolShowBars then
		local strWeapon = intWeapon
		if Locker[intWeapon] then strWeapon = Locker[intWeapon].Weapon end
		local intXPosition = 100
		local intBarWidth = weaponPanel:GetWide() - 10 - intXPosition
		local YOffset = 5
		surface.SetTextColor(255, 255, 255, 255)
		-- Power
		surface.SetFont("DefaultSmallDropShadow")
		local x, y = surface.GetTextSize("Power")
		surface.SetTextPos(intXPosition, YOffset)
		surface.DrawText("Power")
		YOffset = YOffset + y
		surface.SetDrawColor(200, 200, 200, 60)
		surface.DrawRect(intXPosition, YOffset, intBarWidth, 5)
		surface.SetDrawColor(255, 55, 55, 100)
		local PowerLevel = 1
		if Locker[intWeapon] then PowerLevel = Locker[intWeapon].pwrlvl end
		surface.DrawRect(intXPosition, YOffset, intBarWidth / (table.Count(Weapons[strWeapon].UpGrades.Power) / PowerLevel), 5)
		YOffset = YOffset + 5
		-- Accuracy
		surface.SetFont("DefaultSmallDropShadow")
		local x, y = surface.GetTextSize("Power")
		surface.SetTextPos(intXPosition, YOffset)
		surface.DrawText("Accuracy")
		YOffset = YOffset + y
		surface.SetDrawColor(200, 200, 200, 60)
		surface.DrawRect(intXPosition, YOffset, intBarWidth, 5)
		surface.SetDrawColor(255, 55, 55, 100)
		local AccuracyLevel = 1
		if Locker[intWeapon] then AccuracyLevel = Locker[intWeapon].acclvl end
		surface.DrawRect(intXPosition, YOffset, intBarWidth / (table.Count(Weapons[strWeapon].UpGrades.Accuracy) / AccuracyLevel), 5)
		YOffset = YOffset + 5
		--Firing Speed
		surface.SetFont("DefaultSmallDropShadow")
		local x, y = surface.GetTextSize("Power")
		surface.SetTextPos(intXPosition, YOffset)
		surface.DrawText("Firing Speed")
		YOffset = YOffset + y
		surface.SetDrawColor(200, 200, 200, 60)
		surface.DrawRect(intXPosition, YOffset, intBarWidth, 5)
		surface.SetDrawColor(255, 55, 55, 100)
		local FiringSpeedLevel = 1
		if Locker[intWeapon] then FiringSpeedLevel = Locker[intWeapon].spdlvl end
		surface.DrawRect(intXPosition, YOffset, intBarWidth / (table.Count(Weapons[strWeapon].UpGrades.FiringSpeed) / FiringSpeedLevel), 5)
		YOffset = YOffset + 5
		-- Clip Size
		surface.SetFont("DefaultSmallDropShadow")
		local x, y = surface.GetTextSize("Power")
		surface.SetTextPos(intXPosition, YOffset)
		surface.DrawText("Clip Size")
		YOffset = YOffset + y
		surface.SetDrawColor(200, 200, 200, 60)
		surface.DrawRect(intXPosition, YOffset, intBarWidth, 5)
		surface.SetDrawColor(255, 55, 55, 100)
		local ClipSizeLevel = 1
		if Locker[intWeapon] then ClipSizeLevel = Locker[intWeapon].clplvl end
		surface.DrawRect(intXPosition, YOffset, intBarWidth / (table.Count(Weapons[strWeapon].UpGrades.ClipSize) / ClipSizeLevel), 5)
		YOffset = YOffset + 5
		-- Reload speed
		surface.SetFont("DefaultSmallDropShadow")
		local x, y = surface.GetTextSize("Power")
		surface.SetTextPos(intXPosition, YOffset)
		surface.DrawText("Reload Speed")
		YOffset = YOffset + y
		surface.SetDrawColor(200, 200, 200, 60)
		surface.DrawRect(intXPosition, YOffset, intBarWidth, 5)
		surface.SetDrawColor(255, 55, 55, 100)
		local ReloadSpeedLevel = 1
		if Locker[intWeapon] then ReloadSpeedLevel = Locker[intWeapon].reslvl end
		surface.DrawRect(intXPosition, YOffset, intBarWidth / (table.Count(Weapons[strWeapon].UpGrades.ReloadSpeed) / ReloadSpeedLevel), 5)
		YOffset = YOffset + 15
		
		-- Max Points
		surface.SetFont("DefaultSmallDropShadow")
		local TotalLevl = PowerLevel + AccuracyLevel + FiringSpeedLevel + ClipSizeLevel + ReloadSpeedLevel
		local MaxLevel = 15
		if Locker[intWeapon] then MaxLevel = Locker[intWeapon].Maxpoints end
		local x, y = surface.GetTextSize("Points " .. TotalLevl .. "/" .. MaxLevel)
		surface.SetTextPos(intXPosition, YOffset)
		surface.DrawText("Points " .. TotalLevl .. "/" .. MaxLevel)
	end
end
