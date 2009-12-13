ENT.Base = "base_ai" 
ENT.Type = "ai"
 
ENT.PrintName		= ""
ENT.Author			= ""
ENT.Contact			= ""  //fill in these if you want it to be in the spawn menu
ENT.Purpose			= ""
ENT.Instructions	= ""
 
ENT.AutomaticFrameAdvance = true
 
 
/*---------------------------------------------------------
   Name: OnRemove
   Desc: Called just before entity is deleted
---------------------------------------------------------*/
function ENT:OnRemove()
end
 
 
/*---------------------------------------------------------
   Name: PhysicsCollide
   Desc: Called when physics collides. The table contains 
			data on the collision
---------------------------------------------------------*/
function ENT:PhysicsCollide( data, physobj )
end
 
function ENT:Ragdoll(dmgforce)
	if CLIENT then return false; end
	local ragdoll = ents.Create("prop_ragdoll")
	ragdoll:SetModel(self:GetModel())
	ragdoll:SetPos(self:GetPos())
	ragdoll:SetAngles(self:GetAngles());
	ragdoll:Spawn()
	ragdoll:Activate()
	ragdoll:SetCollisionGroup( 1 )
	ragdoll:GetPhysicsObject():ApplyForceCenter(dmgforce);
	timer.Simple(3, function() ragdoll:Remove() end)
	local Steps = 10;
	local PerStep = 255 / Steps;
	local TimePerStep = 1 / Steps;
	for i = 1, Steps do
		timer.Simple(1 - TimePerStep + (TimePerStep * i), ragdoll.SetColor, ragdoll, 255, 255, 255, math.Clamp(255 - (PerStep * i), 0, 255));
	end
end
/*---------------------------------------------------------
   Name: PhysicsUpdate
   Desc: Called to update the physics .. or something.
---------------------------------------------------------*/
function ENT:PhysicsUpdate( physobj )
end
 
/*---------------------------------------------------------
   Name: SetAutomaticFrameAdvance
   Desc: If you're not using animation you should turn this 
	off - it will save lots of bandwidth.
---------------------------------------------------------*/
function ENT:SetAutomaticFrameAdvance( bUsingAnim )
 
	self.AutomaticFrameAdvance = bUsingAnim
 
end
 