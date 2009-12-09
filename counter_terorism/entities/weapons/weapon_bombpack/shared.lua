if (SERVER) then
	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= true
	SWEP.HoldType			= "slam"
end

if ( CLIENT ) then
	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= true
	SWEP.ViewModelFOV		= 64
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= false
	SWEP.PrintName			= "The bomb"			
	SWEP.Author				= "Noobulator"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 11
end

SWEP.Author			= "Noobulator"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= "Aim away from face"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_c4.mdl"
SWEP.WorldModel			= "models/weapons/w_c4.mdl"

SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= -1
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.Delay			= 2

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "slam"

SWEP.Secondary.Recoil		= 0
SWEP.Secondary.Damage		= -1
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.Delay		= 0.2
SWEP.Secondary.NextFire 	= 0

SWEP.Secondary.ClipSize		= 1
SWEP.Secondary.DefaultClip	= 1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

function SWEP:Initialize()
	if (SERVER) then
		self:SetWeaponHoldType(self.HoldType)
	end
end

function SWEP:Deploy()
end

function SWEP:Reload()
end

function SWEP:Think()
end
	
function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	if self:GetOwner():GetNWBool("CanPlant") == true then
		local trace = self:GetOwner():GetEyeTrace()
		local hitpos = trace.HitPos
		if self:GetOwner():GetPos():Distance(hitpos) <= 100 then
			timer.Simple(self.Primary.Delay + 0.2,function() self:CreateBomb() end)
			self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
			self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
			self.Owner:SetAnimation(PLAYER_ATTACK1)
		end
	else
		self:GetOwner():PrintMessage(HUD_PRINTCENTER,"you cant plant here")
	end
end

function SWEP:SecondaryAttack()
	self.Owner:PrintMessage(HUD_PRINTCENTER,"detonation time: 45 seconds")
end

function SWEP:Holster()
	return true
end

function SWEP:OnRemove()
	return true
end

function SWEP:CreateBomb()
	if #ents.FindByClass("sent_bomb") > 0 then return end
	if self:GetOwner():GetNWBool("CanPlant") == true then
		local trace = self:GetOwner():GetEyeTrace()
		local hitpos = trace.HitPos
		if self:GetOwner():GetPos():Distance(hitpos) <= 100 then
			local bomb = ents.Create("sent_bomb")
			bomb:SetPos(hitpos)
			bomb:DropToFloor()
			bomb:Spawn()
			self:TakePrimaryAmmo(1)
		end
	end
end