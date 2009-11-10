include( 'shared.lua' )

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
