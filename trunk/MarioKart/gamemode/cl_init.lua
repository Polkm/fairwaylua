include('shared.lua')
include('cl_ghost.lua')
include('cl_placespanel.lua')
GM.HUDNoDraw = {}
GM.HUDNoDraw[1] = "CHudHealth"
GM.HUDNoDraw[2] = "CHudBattery"
GM.HUDNoDraw[3] = "CHudSecondaryAmmo"
GM.HUDNoDraw[4] = "CHudAmmo"

local mk_ItemBoxx = (ScrW() / 2) - 64
local mk_ItemBoxy = -128
local mk_CanItem = true 
local mk_Model = nil

function GM:Initialize()
	RunConsoleCommand("gm_clearfonts")
	surface.CreateFont("coolvetica", ScreenScale(120), ScreenScale(120), true, false, "HudScaled")
	ModelIcon = vgui.Create("DModelPanel")
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
	if !mk_Model then 
		mk_Model = ents.Create("prop_physics")
		mk_Model:SetAngles(Angle(0, 0, 0))
		mk_Model:SetPos(Vector(0, 0, 0))
		mk_Model:SetModel("models/gmodcart/items/koopashell.mdl")
		mk_Model:SetNoDraw(true)
		mk_Model:Spawn()
		mk_Model:Activate()
	end
	surface.SetFont("HUDNumber")
	surface.SetTextColor(255, 255, 255, 255)
	surface.SetTextPos(SW / 4, 20)
	surface.DrawText("Lap " .. client:GetNWInt("Lap"))
	surface.SetTextPos(SW / 1.5, 20)
	surface.DrawText("Time: "..string.ToMinutesSecondsMilliseconds(math.Round(GetGlobalInt("GameModeTime") * 10) / 10))
	if GetGlobalInt("CountDown") <= 3 && GetGlobalInt("CountDown") > 0 then 
		surface.SetFont("HudScaled")
		local x,y = surface.GetTextSize(GetGlobalInt("CountDown"))
		surface.SetTextPos(SW/2 - x/2  ,SH/2 - y/2)
		surface.DrawText(GetGlobalInt("CountDown"))
	end
	surface.SetFont("HUDNumber")
	--item display
	if client:GetNWString("Item") != "empty" then
		if mk_ItemBoxy < (20)  then
			mk_ItemBoxy = mk_ItemBoxy + 2
		end
	else
		if mk_ItemBoxy > (-128) then
			mk_ItemBoxy = mk_ItemBoxy - 2
		end
	end
	surface.SetTexture(surface.GetTextureID("gmodcart/items/mk_box"))
	surface.SetDrawColor(255,255,255,255)
	surface.DrawTexturedRect(mk_ItemBoxx, mk_ItemBoxy ,128,128)
	if client:GetNWString("Item") != "empty" then
		if GAMEMODE.mk_Items[client:GetNWString("Item")] && GAMEMODE.mk_Items[client:GetNWString("Item")].Material == nil then
			ModelIcon:SetPos(SW / 2,20)
			ModelIcon:SetSize(100,100)
			mk_Model:SetModel(GAMEMODE.mk_Items[client:GetNWString("Item")].Model)
			mk_Model:SetSkin(GAMEMODE.mk_Items[client:GetNWString("Item")].Skin)
			ModelIcon:SetEntity(mk_Model)
			local center = mk_Model:OBBCenter()
			local dist = mk_Model:BoundingRadius()
			ModelIcon:SetLookAt(center)
			ModelIcon:SetCamPos(center+Vector(dist,dist,0))	
		else
			if GAMEMODE.mk_Items[client:GetNWString("Item")] then
				surface.SetTexture(surface.GetTextureID(GAMEMODE.mk_Items[client:GetNWString("Item")].Material))
				surface.SetDrawColor(255,255,255,255)
				surface.DrawTexturedRect(mk_ItemBoxx + 14, mk_ItemBoxy + 14,100,100)
			end
		end
	end
	surface.SetTextPos(SW / 7, SH / 1.2)
	surface.DrawText(LocalPlayer():GetNWInt("Place"))
end

function GM:Think()
	if LocalPlayer():KeyPressed(IN_USE) && mk_CanItem  then
		RunConsoleCommand("mk_FireItem")
		mk_CanItem = false
		timer.Simple(0.3, function() mk_CanItem = true end)
	end
end

function GM:CalcView(ply, origin, angles, fov)
	local phys = ply:GetNWEntity("WatchEntity") || LocalPlayer():GetNWEntity("Cart")
	if !phys then return end
	
	if  phys:GetNWEntity("Wheel2"):IsValid() then
	LastViewYaw = LastViewYaw or phys:GetAngles().yaw
	

	
		local distance = math.AngleDifference( LastViewYaw, phys:GetAngles().yaw )
		LastViewYaw = math.ApproachAngle( LastViewYaw, phys:GetAngles().yaw, distance * FrameTime() * 2 )
		phys:GetNWEntity("Wheel1"):SetModelScale(Vector(1,2,1))
		phys:GetNWEntity("Wheel2"):SetModelScale(Vector(1,2,1))

	end
		local view = {}
		view.origin 	= phys:GetPos() + Vector( 0, 0, 90 ) - phys:GetAngles():Forward() * 128
		view.angles		= Angle( 10, LastViewYaw - distance * 1.25, distance*0.1 ) 
		view.fov 		= 90
		return view
end