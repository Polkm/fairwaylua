include('shared.lua')
include('cl_ghost.lua')

function GM:HUDShouldDraw(Name)
	if Name == "CHudHealth" or Name == "CHudBattery" or Name =="CHudSecondaryAmmo" or Name == "CHudAmmo" then
		return false
	end	
	return true
end

function GM:HUDPaint()
	local SW = ScrW()
	local SH = ScrH()
	local client = LocalPlayer()
	surface.SetFont("HUDNumber")
	surface.SetTextColor(255, 255, 255, 255)
	surface.SetTextPos(SW / 2, 20)
	surface.DrawText("Lap " .. client:GetNWInt("Lap"))
	
	
	surface.SetTextPos(SW / 7, SH / 1.2)
	surface.DrawText(LocalPlayer():GetNWInt("Place"))
end

function GM:Think()
	if LocalPlayer():KeyPressed(IN_USE)  then
		RunConsoleCommand("mk_FireItem")
	end
end

function GM:CalcView( ply, origin, angles, fov )
	local phys = LocalPlayer():GetNWEntity("Cart")
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


