include('shared.lua')
include('cl_ghost.lua')
include('cl_placespanel.lua')
include('cl_charactercreation.lua')
GM.HUDNoDraw = {}
GM.HUDNoDraw[1] = "CHudHealth"
GM.HUDNoDraw[2] = "CHudBattery"
GM.HUDNoDraw[3] = "CHudSecondaryAmmo"
GM.HUDNoDraw[4] = "CHudAmmo"

local mk_ItemBoxx = (ScrW() / 2) - 64
local mk_ItemBoxy = -128
local mk_CanItem = true 
local mk_DrawTime = 0

function GM:Initialize()
	RunConsoleCommand("gm_clearfonts")
	surface.CreateFont("coolvetica", ScreenScale(120), ScreenScale(120), true, false, "HudScaled")
	timer.Simple(0.1, function()
		GAMEMODE:DrawPlacesPanel()
		if GetGlobalString("GameModeState") == "PREP" then
			GAMEMODE:DrawCharacterCreation()
		end
	end)
end

function GM:HUDShouldDraw(Name)
	if table.HasValue(GAMEMODE.HUDNoDraw, Name) then return false end	
	return true
end

function GM:HUDPaint()
	local SW = ScrW()
	local SH = ScrH()
	local client = LocalPlayer()
	local strItem = client:GetNWString("Item")
	local entViewEntity = LocalPlayer():GetNWEntity("WatchEntity")
	if !entViewEntity or !entViewEntity:IsValid() then return end
	local entCart = LocalPlayer():GetNWEntity("Cart")
	if !entCart or !entCart:IsValid() then return end
	if entCart == entViewEntity then
		surface.SetFont("HUDNumber")
		surface.SetTextColor(255, 255, 255, 255)
		surface.SetTextPos(SW / 4, 20)
		local strLapText = "Lap: " .. client:GetNWInt("Lap") .. "/" .. GAMEMODE.WinLaps
		if client:GetNWInt("Lap") <= 0 then strLapText = "Lap: Done" end
		surface.DrawText(strLapText)
		
		surface.SetTextPos(SW / 1.5, 20)
		if client:GetNWInt("Lap") > 0 then
			mk_DrawTime = math.Round(GetGlobalInt("GameModeTime") * 10) / 10
		end
		surface.DrawText("Time: " .. string.ToMinutesSecondsMilliseconds(mk_DrawTime))
		if GetGlobalInt("CountDown") <= 3 && GetGlobalInt("CountDown") > 0 then 
			surface.SetFont("HudScaled")
			local x, y = surface.GetTextSize(GetGlobalInt("CountDown"))
			surface.SetTextPos(SW / 2 - x / 2  ,SH / 2 - y / 2)
			surface.DrawText(GetGlobalInt("CountDown"))
		end
		surface.SetFont("HUDNumber")
		--item display
		if strItem != "empty" then
			if mk_ItemBoxy < (20)  then
				mk_ItemBoxy = mk_ItemBoxy + 2
			end
		else
			if mk_ItemBoxy > (-128) then
				mk_ItemBoxy = mk_ItemBoxy - 2
			end
		end
		surface.SetTexture(surface.GetTextureID("gmodcart/items/mk_box"))
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect(mk_ItemBoxx, mk_ItemBoxy, 128, 128)
		if strItem != "empty" && GAMEMODE.mk_Items[strItem] then
			surface.SetTexture(surface.GetTextureID(GAMEMODE.mk_Items[strItem].Material))
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawTexturedRect(mk_ItemBoxx + 14, mk_ItemBoxy + 14, 100, 100)
		end
		surface.SetTextPos(SW / 7, SH / 1.2)
		surface.DrawText(LocalPlayer():GetNWInt("Place"))
	else
		
	end
end

function GM:Think()
	if LocalPlayer():KeyPressed(IN_USE) && mk_CanItem then
		RunConsoleCommand("mk_FireItem")
		mk_CanItem = false
		timer.Simple(0.3, function() mk_CanItem = true end)
	end
end

function GM:CalcView(ply, origin, angles, fov)
	local entViewEntity = LocalPlayer():GetNWEntity("WatchEntity") 
	if !entViewEntity:IsValid() then
		entViewEntity = LocalPlayer():GetNWEntity("Cart") 
	end
	if !entViewEntity or !entViewEntity:IsValid() then return end
	LastViewYaw = LastViewYaw or entViewEntity:GetAngles().yaw
	local Distance = math.AngleDifference(LastViewYaw, entViewEntity:GetAngles().yaw)
	LastViewYaw = math.ApproachAngle(LastViewYaw, entViewEntity:GetAngles().yaw, Distance * FrameTime() * 2)
	if entViewEntity:GetNWEntity("Wheel1") then entViewEntity:GetNWEntity("Wheel1"):SetModelScale(Vector(1,2,1)) end
	if entViewEntity:GetNWEntity("Wheel2") then entViewEntity:GetNWEntity("Wheel2"):SetModelScale(Vector(1,2,1)) end
	local view = {}
	view.origin = entViewEntity:GetPos() + Vector(0, 0, 90) - entViewEntity:GetAngles():Forward() * 128
	view.angles	= Angle(10, LastViewYaw - Distance * 1.25, Distance * 0.1)
	view.fov = 90
	return view
end

local tblSoundTable = {}
tblSoundTable["BackGround"] = {}
tblSoundTable["BackGround"].Default = "gmodcart/music/mk_circuit.mp3"
tblSoundTable["BackGround"]["mk_snow_a3"] = "gmodcart/music/mk_snow.mp3"
--Effects
tblSoundTable["FinalLap"] = "gmodcart/music/mk_finallap.mp3"
tblSoundTable["StartLineUp"] = "gmodcart/music/mk_startlineup.mp3"
tblSoundTable["End"] = "gmodcart/music/mk_end.mp3"
tblSoundTable["Star"] = "gmodcart/items/mk_star.mp3"

local mk_intMasterVolume = 0.6
local mk_sndCurentSound = nil
local mk_sndCurentSound_Volume = 0.0
local mk_sndBackGroundSound = nil
local mk_sndBackGroundSound_Volume = 0.0
local mk_entBackGroundCart = nil
function GM:PlaySound(strSound)
	if mk_convarMusic:GetInt() == 1 then
		if tblSoundTable[strSound] then
			local entCart = LocalPlayer():GetNWEntity("Cart")
			if !entCart or !entCart:IsValid() then return end
			if mk_sndCurentSound then
				mk_sndCurentSound:FadeOut(0.5)
				mk_sndCurentSound_Volume = 0.0
			end
			if strSound == "BackGround" then
				if !mk_sndBackGroundSound or mk_entBackGroundCart != entCart then
					mk_entBackGroundCart = entCart
					local strSound = tblSoundTable["BackGround"].Default
					if tblSoundTable["BackGround"][tostring(game.GetMap())] then strSound = tblSoundTable["BackGround"][game.GetMap()] end
					mk_sndBackGroundSound = CreateSound(entCart, Sound(strSound))
					mk_sndBackGroundSound:PlayEx(mk_intMasterVolume, 100)
					mk_sndBackGroundSound_Volume = mk_intMasterVolume
				else
					mk_sndBackGroundSound:ChangeVolume(mk_intMasterVolume)
					mk_sndBackGroundSound_Volume = mk_intMasterVolume
				end
			else
				if mk_sndBackGroundSound then
					mk_sndBackGroundSound:ChangeVolume(0.1)
					mk_sndBackGroundSound_Volume = 0.1
				end
				mk_sndCurentSound = CreateSound(entCart, Sound(tblSoundTable[strSound]))
				mk_sndCurentSound:PlayEx(mk_intMasterVolume, 100)
				mk_sndCurentSound_Volume = mk_intMasterVolume
			end
		end
	end
end
function GM:OffAllMusic()
	if mk_sndCurentSound then mk_sndCurentSound:ChangeVolume(0.0) end
	if mk_sndBackGroundSound then mk_sndBackGroundSound:ChangeVolume(0.0) end
end
function GM:OnAllMusic()
	if mk_sndCurentSound then mk_sndCurentSound:ChangeVolume(mk_sndCurentSound_Volume) end
	if mk_sndBackGroundSound then mk_sndBackGroundSound:ChangeVolume(mk_sndBackGroundSound_Volume) end
end
concommand.Add("mk_Sound", function(ply, command, args)
	GAMEMODE:PlaySound(args[1])
end)


