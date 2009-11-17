include('shared.lua')
include('cl_ghost.lua')

function GM:Initialize()
	RunConsoleCommand("gm_clearfonts")
	surface.CreateFont("coolvetica", ScreenScale(120), ScreenScale(120), true, false, "HudScaled")
	ModelIcon = vgui.Create("DModelPanel")
	timer.Simple(0.5, function()
		GAMEMODE:DrawPlacesPanel()
	end)
end

function GM:HUDShouldDraw(Name)
	if Name == "CHudHealth" or Name == "CHudBattery" or Name =="CHudSecondaryAmmo" or Name == "CHudAmmo" then
		return false
	end	
	return true
end

local mk_ItemBoxx = ScrW()/2 - 64
local mk_ItemBoxy = -128

mk_CanItem = true 

function GM:HUDPaint()
	local SW = ScrW()
	local SH = ScrH()
	local client = LocalPlayer()
	if !Created then 
		ModelEnt = ents.Create("prop_physics")
		ModelEnt:SetAngles(Angle(0,0,0))
		ModelEnt:SetPos(Vector(0,0,0))
		ModelEnt:SetModel("models/gmodcart/items/koopashell.mdl")
		ModelEnt:SetNoDraw(true)
		ModelEnt:Spawn()
		ModelEnt:Activate()
		Created = true
	end
	surface.SetFont("HUDNumber")
	surface.SetTextColor(255, 255, 255, 255)
	surface.SetTextPos(SW / 4, 20)
	surface.DrawText("Lap " .. client:GetNWInt("Lap"))
	surface.SetTextPos(SW / 1.5, 20)
	surface.DrawText(string.ToMinutesSecondsMilliseconds(math.Round(GetGlobalInt("GameModeTime") * 10) / 10))
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
			ModelEnt:SetModel(GAMEMODE.mk_Items[client:GetNWString("Item")].Model)
			ModelEnt:SetSkin(GAMEMODE.mk_Items[client:GetNWString("Item")].Skin)
			ModelIcon:SetEntity(ModelEnt)
			local center = ModelEnt:OBBCenter()
			local dist = ModelEnt:BoundingRadius()
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
	
	-----------
	-- Position
	
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

function GM:CalcView( ply, origin, angles, fov )
	local phys = LocalPlayer():GetNWEntity("Cart") or ply
	if ( !phys ) then return end
	
	LastViewYaw = LastViewYaw or phys:GetAngles().yaw
	
	local distance = math.AngleDifference( LastViewYaw, phys:GetAngles().yaw )
	LastViewYaw = math.ApproachAngle( LastViewYaw, phys:GetAngles().yaw, distance * FrameTime() * 2 )
	
	phys:GetNWEntity("Wheel1"):SetModelScale(Vector(1,2,1))
	phys:GetNWEntity("Wheel2"):SetModelScale(Vector(1,2,1))
	
	local view = {}
	view.origin 	= phys:GetPos() + Vector( 0, 0, 90 ) - phys:GetAngles():Forward() * 128
	view.angles		= Angle( 10, LastViewYaw - distance * 1.25, distance*0.1 ) 
	view.fov 		= 90
	return view
end

function GM:DrawPlacesPanel()
	local intNumberPlayer = #player.GetAll()
	local intCurrentPlace = 1
	local intMaxPlaces = 5
	local intYOffset = 15
	local intYOffsetEach = 50
	local PlacesPanel = vgui.Create("DPanel")
	PlacesPanel:SetPos(20, 100)
	PlacesPanel:SetSize(300, intMaxPlaces * intYOffsetEach + 20)
	PlacesPanel.Paint = function() end
	for i = 1, intMaxPlaces do
		local plyFoundPlayer = GAMEMODE:FindPlayer(intCurrentPlace)
		local PlaceText = vgui.Create("DLabel", PlacesPanel)
		PlaceText:SetPos(5, intYOffset)
		PlaceText:SetFont("HUDNumber")
		PlaceText:SetColor(Color(255, 255, 255, 255))
		PlaceText:SetText(intCurrentPlace)
		
		local AvitarImage = vgui.Create("AvatarImage", PlacesPanel)
		AvitarImage:SetPos(30, intYOffset - 5)
		AvitarImage:SetSize(32, 32)
		AvitarImage:SetPlayer(plyFoundPlayer)
		
		local NameText = vgui.Create("DLabel", PlacesPanel)
		NameText:SetPos(70, intYOffset)
		NameText:SetSize(300, 20)
		NameText:SetFont("Trebuchet24")
		NameText:SetColor(Color(255, 255, 255, 255))
		NameText:SetText(plyFoundPlayer:Nick())
		
		intYOffset = intYOffset + intYOffsetEach
		intCurrentPlace = intCurrentPlace + 1
		if intNumberPlayer < intCurrentPlace then break end
	end
	timer.Simple(0.5, function() GAMEMODE:UpdatelacesPanel(PlacesPanel) end)
end

function GM:UpdatelacesPanel(PlacesPanel)
	PlacesPanel:Remove()
	GAMEMODE:DrawPlacesPanel()
end

function GM:FindPlayer(intPlace)
	for _, player in pairs(player.GetAll()) do
		if player:GetNWInt("Place") == intPlace then
			return player
		end
	end
end


