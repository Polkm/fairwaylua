
/*---------------------------------------------------------
   Clientside Vehicles Base
---------------------------------------------------------*/

// Note: Vehicles aren't done yet. This is all just a placeholder.


ENT.Type 			= "anim"

function ENT:SetupModel()
	self.Entity:SetModel("models/gmodcart/regular_cart.mdl")
	self.Entity:SetPos(self.Entity:GetPos() *  Vector(0,0,10))
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Axis = ents.Create("player_wheel")
	self.Axis:SetNoDraw(false)
	self.Axis:SetPos(self.Entity:GetPos())
	self.Axis:Spawn()
	self.Axis:SetSolid(NONE)
	constraint.Weld(self.Axis,self.Entity,0,0,0,true)
	self.Axis:SetCollisionGroup(0)
	self.BackWheel1 = ents.Create("player_wheel")
	self.BackWheel1:PhysicsInit(SOLID_VPHYSICS)
	self.BackWheel1:SetMoveType(MOVETYPE_VPHYSICS)
	self.BackWheel1:SetSolid(SOLID_VPHYSICS)
	self.BackWheel1:SetPos(self.Entity:GetPos() + Vector(-13,-21,5))

	//self.BackWheel1:SetParent(self.Entity)
	self.BackWheel1:SetCollisionGroup(11)
	self.BackWheel1:Spawn()
	//constraint.Weld(self.BackWheel1,self.Entity,0,0,0,true)
	constraint.NoCollide(self.BackWheel1,self.Entity,0,0)
	constraint.Axis(self.Axis ,self.BackWheel1,
                0, 0,
               self.Entity:GetPos() + Vector(-13,-30,5), self.BackWheel1:GetPos(),
                0, 0,
                0, 1,
                self.BackWheel1:GetPos())
	self.BackWheel2 = ents.Create("player_wheel")
	self.BackWheel2:PhysicsInit(SOLID_VPHYSICS)
	self.BackWheel2:SetMoveType(MOVETYPE_VPHYSICS)
	self.BackWheel2:SetSolid(SOLID_VPHYSICS)
	self.BackWheel2:SetPos(self.Entity:GetPos() + Vector(-13,21,5))
	//self.BackWheel2:SetParent(self.Entity)
	self.BackWheel2:SetCollisionGroup(11)
	self.BackWheel2:Spawn()
	//constraint.Weld(self.BackWheel2,self.Entity,0,0,0,true)
	constraint.NoCollide(self.BackWheel2,self.Entity,0,0)
		constraint.Axis(self.Entity ,self.BackWheel2,
                0, 0,
               self.Entity:GetPos() + Vector(-13,30,5), self.BackWheel2:GetPos(),
                0, 0,
                0, 1,
                self.BackWheel2:GetPos())
	self.frontWheel1 = ents.Create("player_wheel")
	self.frontWheel1:PhysicsInit(SOLID_VPHYSICS)
	self.frontWheel1:SetMoveType(MOVETYPE_VPHYSICS)
	self.frontWheel1:SetSolid(SOLID_VPHYSICS)
	self.frontWheel1:SetPos(self.Entity:GetPos() + Vector(35,-21,5))
	//self.frontWheel1:SetParent(self.Entity)
	self.frontWheel1:SetCollisionGroup(11)
	self.frontWheel1:Spawn()
	//constraint.Weld(self.frontWheel1,self.Entity,0,0,0,true)
	constraint.NoCollide(self.frontWheel1,self.Entity,0,0)
	constraint.Axis(self.Axis ,self.frontWheel1,
                0, 0,
               self.Entity:GetPos() + Vector(35,-30,5), self.frontWheel1:GetPos(),
                0, 0,
                0, 1,
                self.frontWheel1:GetPos())
				
	self.frontWheel2 = ents.Create("player_wheel")
	self.frontWheel2:PhysicsInit(SOLID_VPHYSICS)
	self.frontWheel2:SetMoveType(MOVETYPE_VPHYSICS)
	self.frontWheel2:SetSolid(SOLID_VPHYSICS)
	self.frontWheel2:SetPos(self.Entity:GetPos() + Vector(35,21,5))
	//self.frontWheel2:SetParent(self.Entity)
	self.frontWheel2:SetCollisionGroup(11)
	self.frontWheel2:Spawn()
	//constraint.Weld(self.frontWheel2,self.Entity,0,0,0,true)
	constraint.NoCollide(self.frontWheel2,self.Entity,0,0)
	constraint.Axis(self.Axis ,self.frontWheel2,
                0, 0,
               self.Entity:GetPos() + Vector(35,30,5), self.frontWheel2:GetPos(),
                0, 0,
                0, 1,
                self.frontWheel2:GetPos())
	self.SteerWheel1 = ents.Create("player_wheel")
	self.SteerWheel1:PhysicsInit(SOLID_VPHYSICS)
	self.SteerWheel1:SetMoveType(MOVETYPE_VPHYSICS)
	self.SteerWheel1:SetSolid(SOLID_VPHYSICS)
	self.SteerWheel1:SetPos(self.Entity:GetPos())
	self.SteerWheel1:SetParent(self.Entity)
	self.SteerWheel1:SetCollisionGroup(11)
	constraint.NoCollide(self.SteerWheel1,self.Entity,0,0)
	self.SteerWheel1:Spawn()
	self.SteerWheel1:SetModel("models/gmodcart/regular_cart_steerwheel.mdl")
end

function ENT:Use( ply )
	if ( SERVER ) then
		self:SetDriver( ply )
	end
end

function ENT:SetupPhysics()
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:StartMotionController()
	local phys = self.Entity:GetPhysicsObject()
	if (phys) then
		phys:SetMaterial( "Ice" )
	end
end

function ENT:SetupPhysicsShadow()
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:PhysicsInitShadow( true, true )
	local phys = self.Entity:GetPhysicsObject()
	if (phys) then
		phys:SetMaterial( "Ice" )
	end
end

function ENT:SharedInitialize()

	self.DoProcessing = false
	if (CLIENT && !SinglePlayer() || SERVER && SinglePlayer()) then
		self.DoProcessing = true
	end
	self:SetupModel()
	self:ReConfigurePhysics()
end

function ENT:ReConfigurePhysics()
	self.Entity:StopMotionController()
	if ( CLIENT ) then
		if ( self:GetDriver() == LocalPlayer() && !SinglePlayer() ) then
			self:SetupPhysics()
		else
			self:SetupPhysicsShadow()
		end
	else
		if ( SinglePlayer() ) then
			self:SetupPhysics()
		else
			self:SetupPhysicsShadow()
		end
	end
end


function ENT:GetDriver()
	return self.Entity:GetNetworkedEntity( "driver" )
end

function ENT:SetDriver( ply )
	local OldDriver = self:GetDriver()
	if ( OldDriver != NULL ) then
		OldDriver:SetScriptedVehicle( NULL )
		OldDriver:SetParent( NULL )
		OldDriver:Spectate( OBS_MODE_NONE )
		OldDriver:SpectateEntity( NULL )
	end
	self.Entity:SetNetworkedEntity( "driver", ply )
	if ( ply ) then	
		ply:SetScriptedVehicle( self.Entity )		
		ply:SetPos( self.Entity:GetPos() )
		ply:SetParent( self.Entity )		
		ply:Spectate( OBS_MODE_CHASE )
		ply:SpectateEntity( self.Entity )		
		if ( !SinglePlayer() ) then
			ply:SetClientsideVehicle( self.Entity )
		end	
	end	
	self:ReConfigurePhysics()
end

function ENT:CalcView( ply, origin, angles, fov )
	local phys = self.Entity:GetPhysicsObject()
	if ( !phys ) then return end
	self.LastViewYaw = self.LastViewYaw or phys:GetAngle().yaw
	local distance = math.AngleDifference( self.LastViewYaw, phys:GetAngle().yaw )
	self.LastViewYaw = math.ApproachAngle( self.LastViewYaw, phys:GetAngle().yaw, distance * FrameTime() * 2 )
	local view = {}
	view.origin 	= phys:GetPos() + Vector( 0, 0, 64 ) - phys:GetAngle():Forward() * 128
	view.angles		= Angle( 10, self.LastViewYaw - distance * 1.25, distance*0.1 ) 
	view.fov 		= 90
	return view

end

function ENT:Think()
	local phys = self.Entity:GetPhysicsObject()	

	if ( self:GetDriver() && self:GetDriver():IsValid() ) then	
		self:DoInputs( self:GetDriver() )	
	end
end

function ENT:DoInputs( driver )
	if ( CLIENT ) then return end
	if ( driver:KeyDown( IN_USE ) ) then	
		Msg("Exit!!\n")
		self:SetDriver( nil )	
	end	
end

function ENT:GetForwardAcceleration( driver, phys, ForwardVel )
	if (!driver || !driver:IsValid()) then return 0 end
	
	if ( driver:KeyDown( IN_FORWARD ) ) then return 520 end
	if ( driver:KeyDown( IN_BACK ) ) then return -320 end

	return 0
	
end

function ENT:GetTurnYaw( driver, phys, ForwardVel )
	if ( !driver || !driver:IsValid() ) then return 0 end
	if ( driver:KeyDown( IN_MOVELEFT ) ) then  return 150 end
	if ( driver:KeyDown( IN_MOVERIGHT ) ) then return -150 end
	return 0
end


/*---------------------------------------------------------
   Name: Simulate
---------------------------------------------------------*/
function ENT:PhysicsSimulate( phys, deltatime )
	local up = phys:GetAngle():Up()
	if ( up.z < 0.33 ) then
		return SIM_NOTHING
	end
	local driver = self:GetDriver()
	local forward = 0
	local right = 0
	local Velocity = phys:GetVelocity()
	local ForwardVel = phys:GetAngle():Forward():Dot( Velocity )
	local RightVel = phys:GetAngle():Right():Dot( Velocity )
	if ( driver ) then
		forward = self:GetForwardAcceleration( driver, phys, ForwardVel )
		yaw		= self:GetTurnYaw( driver, phys, ForwardVel )

	end
	// Kill any sidewards movement (unless we're skidding)
	right = RightVel * 0.95
	// Apply some ground friction of our own
	forward = forward - ForwardVel * 0.01
	local Linear = ( Vector( forward, right, 0 ) ) * deltatime * 1000;
	// Do angle changing stuff.
	local AngleVel = phys:GetAngleVelocity()
	// This simulates the friction of the tires
	local AngleFriction = AngleVel * -0.1
	local Angular = (AngleFriction + Vector( 0, 0, yaw )) * deltatime * 1000;
	// Note: Local Acceleration means that the values are applied to the object locally
	// ie, forward is whatever firection the entity is facing. This is perfect for a car
	// but if you're making a ball that you're spectating and pushing in the direction
	// that you're facing you'll want to override this whole function and use global
	return  Angular,Linear, SIM_LOCAL_ACCELERATION
	
end
