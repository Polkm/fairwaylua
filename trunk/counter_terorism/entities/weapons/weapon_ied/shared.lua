if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= true
	SWEP.HoldType			= "slam"
end
if (CLIENT) then
	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= true
	SWEP.ViewModelFOV		= 64
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= false
	SWEP.PrintName			= "IED"			
	SWEP.Author				= "Noobulator"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 11
end
SWEP.Author			= "Noobulater"
SWEP.Instructions		= "Click on a prop and then right click to remote detonate it"
SWEP.Purpose		= ""
SWEP.Instructions	= "Trust Me, You will want to run"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_c4.mdl"
SWEP.WorldModel			= "models/weapons/w_c4.mdl"

SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= -1
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.Delay			= 1.0
SWEP.Primary.ClipSize		= 2
SWEP.Primary.DefaultClip	= 2

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "Ieds"

SWEP.Secondary.Recoil		= 0
SWEP.Secondary.Damage		= -1
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.Delay		= 0.5
SWEP.Secondary.NextFire 	= 0

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:Initialize()
	if (SERVER) then
		self:SetWeaponHoldType(self.HoldType)
		self.Planted = false
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
	if self.Planted != true then
		local trace = self:GetOwner():GetEyeTrace()
		local hitpos = trace.HitPos
		if self:GetOwner():GetPos():Distance(hitpos) <= 100 then
			timer.Simple(self.Primary.Delay + 0.6,function() self:CreateBomb() end)
			self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
			self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
			self.Owner:SetAnimation(PLAYER_ATTACK1)
		end
	end
end


function SWEP:SecondaryAttack()
	if self.Planted == true then
		for k,v in pairs (ents.FindByClass("sent_iedbomb")) do
			if v:GetOwner() == self:GetOwner() then
				v:Asplodeied()
				self.Planted = false
			end
		end
	else
		self.GetOwner():PrintMessage(HUD_PRINTCENTER,"None of your bombs have been planted")
	end	
end

function SWEP:Holster()
	return true
end

function SWEP:OnRemove()
	return true
end

function SWEP:CreateBomb()
	local trace = self:GetOwner():GetEyeTrace()
	local hitpos = trace.HitPos
	if self:GetOwner():GetPos():Distance(hitpos) <= 100 then
		local bomb = ents.Create("sent_iedbomb")
		bomb:SetPos(hitpos)
		bomb:DropToFloor()
		bomb:SetPos(bomb:GetPos()+Vector(0,0,16))
		bomb:SetOwner(self:GetOwner())
		bomb:Spawn()
		self:TakePrimaryAmmo(1)
		self.Planted = true
	end
end
