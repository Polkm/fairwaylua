--Variables that are used on both client and server
SWEP.Author	= ""
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.ViewModel = "models/weapons/v_toolgun.mdl"
SWEP.WorldModel	= "models/weapons/w_toolgun.mdl"
SWEP.AnimPrefix	= "python"

--Be nice, precache the models
util.PrecacheModel(SWEP.ViewModel)
util.PrecacheModel(SWEP.WorldModel)

--Todo: make/find a better sound.
SWEP.ShootSound	= Sound("Airboat.FireGunRevDown")
SWEP.Tool = {}

SWEP.Primary = 
{
	ClipSize = -1,
	DefaultClip = -1,
	Automatic = false,
	Ammo = "none"
}
SWEP.Secondary = 
{
	ClipSize = -1,
	DefaultClip = -1,
	Automatic = false,
	Ammo = "none"
}

SWEP.CanHolster	= true
SWEP.CanDeploy = true

--[[-------------------------------------------------------
	Initialize
---------------------------------------------------------]]
function SWEP:Initialize()
	self:InitializeTools()
	--We create these here. The problem is that these are meant to be constant values.
	--in the toolmode they're not because some tools can be automatic while some tools aren't.
	--Since this is a global table it's shared between all instances of the gun.
	--By creating new tables here we're making it so each tool has its own instance of the table
	--So changing it won't affect the other tools.
	self.Primary = 
	{
		--Note: Switched this back to -1 ... lets not try to hack our way around shit that needs fixing. -gn
		ClipSize = -1,
		DefaultClip = -1,
		Automatic = false,
		Ammo = "none"
	}
	self.Secondary = 
	{
		ClipSize = -1,
		DefaultClip = -1,
		Automatic = false,
		Ammo = "none"
	}
end

function SWEP:InitializeTools()
	local tblTemp = {}
	for intkey, tblTool in pairs(self.Tool) do
		tblTemp[intkey] = table.Copy(tblTool)
		tblTemp[intkey].SWEP = self
		tblTemp[intkey].Owner = self.Owner
		tblTemp[intkey].Weapon = self.Weapon
	end
	self.Tool = tblTemp
end


--[[-------------------------------------------------------
	OnRestore
---------------------------------------------------------]]
function SWEP:OnRestore()
	self:InitializeTools()
end

--[[-------------------------------------------------------
   Precache Stuff
---------------------------------------------------------]]
function SWEP:Precache()
	--Should we have precached the models here?
	util.PrecacheSound(self.ShootSound)
end

--[[-------------------------------------------------------
	Reload clears the objects
---------------------------------------------------------]]
function SWEP:Reload()
	--This makes the reload a semi-automatic thing rather than a continuous thing
	if !self.Owner:KeyPressed(IN_RELOAD) then return end
	
	local strToolMode = self:GetMode()
	local tblTrace = util.TraceLine(util.GetPlayerTrace(self.Owner))
	if !tblTrace.Hit then return end
	
	local objTool = self:GetToolObject()
	if !objTool then return end
	
	objTool:CheckObjects()
	
	--Does the server setting say it's ok?
	if !objTool:Allowed() then return end
	
	--Ask the gamemode if it's ok to do this
	if !gamemode.Call("CanTool", self.Owner, tblTrace, strToolMode) then return end
	--If the reload function returns false don't shoot the effect
	if !objTool:Reload(tblTrace) then return end
	self:DoShootEffect(tblTrace.HitPos, tblTrace.HitNormal, tblTrace.Entity, tblTrace.PhysicsBone, IsFirstTimePredicted())
end

--[[-------------------------------------------------------
	Returns the mode we're in
---------------------------------------------------------]]
function SWEP:GetMode()
	return self.Mode
end

--[[-------------------------------------------------------
	Think does stuff every frame
---------------------------------------------------------]]
function SWEP:Think()
	self.Mode = self.Owner:GetInfo("gmod_toolmode")
	local strMode = self:GetMode()
	local objTool = self:GetToolObject()
	if !objTool then return end
	
	objTool:CheckObjects()
	self.last_mode = self.current_mode
	self.current_mode = strMode
	
	--Release ghost entities if we're not allowed to use this new mode?
	if !objTool:Allowed() then 
		self:GetToolObject(self.last_mode):ReleaseGhostEntity() 
		return 
	end
	if self.last_mode != self.current_mode then
		if !self:GetToolObject(self.last_mode) then return end
		--We want to release the ghost entity just in case
		self:GetToolObject(self.last_mode):Holster()
	end
	
	self.Primary.Automatic = objTool.LeftClickAutomatic or false
	self.Secondary.Automatic = objTool.RightClickAutomatic or false
	self.RequiresTraceHit = objTool.RequiresTraceHit or true
	
	objTool:Think()
end


--[[-------------------------------------------------------
	The shoot effect
---------------------------------------------------------]]
function SWEP:DoShootEffect(vecHitPos, vecNormal, entTarget, intBone, bFirstTimePredicted)
	self.Weapon:EmitSound(self.ShootSound)
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK) --View model animation
	
	--There's a bug with the model that's causing a muzzle to 
	--appear on everyone's screen when we fire this animation. 
	self.Owner:SetAnimation(PLAYER_ATTACK1) --3rd Person Animation
	
	if !bFirstTimePredicted then return end
	local effectdata = EffectData()
	effectdata:SetOrigin(vecHitPos)
	effectdata:SetNormal(vecNormal)
	effectdata:SetEntity(entTarget)
	effectdata:SetAttachment(intBone)
	util.Effect("selection_indicator", effectdata)	
	
	local effectdata = EffectData()
	effectdata:SetOrigin(vecHitPos)
	effectdata:SetStart(self.Owner:GetShootPos())
	effectdata:SetAttachment(1)
	effectdata:SetEntity(self.Weapon)
	util.Effect("ToolTracer", effectdata)
end

--[[-------------------------------------------------------
	Trace a line then send the result to a mode function
---------------------------------------------------------]]
function SWEP:PrimaryAttack()
	local strToolMode = self:GetMode()
	local trcTraceTable = util.GetPlayerTrace(self.Owner)
	trcTraceTable.mask = (CONTENTS_SOLID|CONTENTS_MOVEABLE|CONTENTS_MONSTER|CONTENTS_WINDOW|CONTENTS_DEBRIS|CONTENTS_GRATE|CONTENTS_AUX)
	local tblTrace = util.TraceLine(trcTraceTable)
	if !tblTrace.Hit then return end
	
	local objTool = self:GetToolObject()
	if !objTool then return end
	objTool:CheckObjects()
	
	--Does the server setting say it's ok?
	if !objTool:Allowed() then return end
	
	--Ask the gamemode if it's ok to do this
	if !gamemode.Call("CanTool", self.Owner, tblTrace, strToolMode) then return end
	--If the left click function returns false don't shoot the effect
	if !objTool:LeftClick(tblTrace) then return end
	
	self:DoShootEffect(tblTrace.HitPos, tblTrace.HitNormal, tblTrace.Entity, tblTrace.PhysicsBone, IsFirstTimePredicted())
end


--[[-------------------------------------------------------
	SecondaryAttack - Called when the player right clicks
---------------------------------------------------------]]
function SWEP:SecondaryAttack()
	local strToolMode = self:GetMode()
	local trcTraceTable = util.GetPlayerTrace(self.Owner)
	trcTraceTable.mask = (CONTENTS_SOLID|CONTENTS_MOVEABLE|CONTENTS_MONSTER|CONTENTS_WINDOW|CONTENTS_DEBRIS|CONTENTS_GRATE|CONTENTS_AUX)
	local tblTrace = util.TraceLine(trcTraceTable)
	if !tblTrace.Hit then return end
	
	local objTool = self:GetToolObject()
	if !objTool then return end
	
	objTool:CheckObjects()
	
	--Does the server setting say it's ok?
	if !objTool:Allowed() then return end
	
	--Ask the gamemode if it's ok to do this
	if !gamemode.Call("CanTool", self.Owner, tblTrace, strToolMode) then return end
	--If the right click function returns false don't shoot the effect
	if !objTool:RightClick(tblTrace) then return end

	self:DoShootEffect(tblTrace.HitPos, tblTrace.HitNormal, tblTrace.Entity, tblTrace.PhysicsBone, IsFirstTimePredicted())
end

--[[-------------------------------------------------------
   ContextScreenClick - Called when the player clicks the screen
---------------------------------------------------------]]
function SWEP:ContextScreenClick(vecAimVec, mcMouseCode, boolPressed, plyPlayer)
	if !boolPressed then return end
	
	--No prediction in single player
	if CLIENT and SinglePlayer() then return end 
	
	local entViewEnt = plyPlayer
	if CLIENT then entViewEnt = GetViewEntity() end
	if SERVER then entViewEnt = plyPlayer:GetViewEntity() end
	
	local strToolMode = self:GetMode()
	local tblTrace = util.TraceLine(utilx.GetPlayerTrace(entViewEnt, vecAimVec))
	if !tblTrace.Hit then return end
	
	local objTool = self:GetToolObject()
	if !objTool then return end
	
	objTool:CheckObjects()
	
	--Ask the gamemode if it's ok to do this
	if !objTool:Allowed() then return end
	if !gamemode.Call("CanTool", self.Owner, tblTrace, strToolMode) then return end
	if mcMouseCode == MOUSE_LEFT then
		if !objTool:LeftClick(tblTrace) then return end
	else
		if !objTool:RightClick(tblTrace) then return end
	end
	
	self:DoShootEffect(tblTrace.HitPos, tblTrace.HitNormal, tblTrace.Entity, tblTrace.PhysicsBone, true)
end

--[[-------------------------------------------------------
	Holster
---------------------------------------------------------]]
function SWEP:Holster()
	--Just do what the SWEP wants to do if there's no tool
	if !self:GetToolObject() then return self.CanHolster end
	
	local boolCanHolster = self:GetToolObject():Holster()
	if boolCanHolster ~= nil then return boolCanHolster end
	return self.CanHolster
end

--[[-------------------------------------------------------
	OnRemove
	- Delete ghosts here in case the weapon gets deleted all of a sudden somehow
---------------------------------------------------------]]
function SWEP:OnRemove()
	if !self:GetToolObject() then return end
	self:GetToolObject():ReleaseGhostEntity()
end


--[[-------------------------------------------------------
	OwnerChanged
	- This will remove any ghosts when a player dies and drops the weapon
---------------------------------------------------------]]
function SWEP:OwnerChanged()
	if !self:GetToolObject() then return end
	self:GetToolObject():ReleaseGhostEntity()
end

--[[-------------------------------------------------------
	Deploy
---------------------------------------------------------]]
function SWEP:Deploy()
	--Just do what the SWEP wants to do if there is no tool
	if !self:GetToolObject() then return self.CanDeploy end
	
	self:GetToolObject():UpdateData()
	
	local boolCanDeploy = self:GetToolObject():Deploy()
	if boolCanDeploy ~= nil then return boolCanDeploy end
	return self.CanDeploy
end

function SWEP:GetToolObject(strToolMode)
	strToolMode = strToolMode or self:GetMode()
	if !self.Tool[strToolMode] then return false end
	return self.Tool[strToolMode]
end

function SWEP:FireAnimationEvent(pos, ang, event, options)
	--Disables animation based muzzle event
	if event == 21 then return true end	
	--Disable thirdperson muzzle flash
	if event == 5003 then return true end
end

include('stool.lua')