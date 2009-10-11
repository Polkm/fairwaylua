include('shared.lua')
SWEP.PrintName			= "Scripted Weapon"		// 'Nice' Weapon name (Shown on HUD)	
SWEP.Slot				= 0						// Slot in the weapon selection menu
SWEP.SlotPos			= 10					// Position in the slot
SWEP.DrawAmmo			= true					// Should draw the default HL2 ammo counter
SWEP.DrawCrosshair		= false					// Should draw the default crosshair
SWEP.SwayScale			= 1.0					// The scale of the viewmodel sway
SWEP.BobScale			= 1.0					// The scale of the viewmodel bob
SWEP.RenderGroup 		= RENDERGROUP_OPAQUE
surface.CreateFont("csd",ScreenScale(30),500,true,true,"CSKillIcons") 
surface.CreateFont("csd",ScreenScale(60),500,true,true,"CSSelectIcons") 

function SWEP:DrawHUD()
end

function SWEP:DrawWeaponSelection(x,y,wide,tall,alpha) 
	draw.SimpleText(self.IconLetter,"CSSelectIcons",x + wide/2,y + tall*0.2,Color(255,210,0,255),TEXT_ALIGN_CENTER) 
	draw.SimpleText(self.IconLetter,"CSSelectIcons",x + wide/2 + math.Rand(-4,4),y + tall*0.2 + math.Rand(-12,12),Color(255,210,0,math.Rand(10,80)),TEXT_ALIGN_CENTER) 
	draw.SimpleText(self.IconLetter,"CSSelectIcons",x + wide/2 + math.Rand(-4,4),y + tall*0.2 + math.Rand(-9,9),Color(255,210,0,math.Rand(10,80)),TEXT_ALIGN_CENTER) 
end 

function SWEP:FreezeMovement()
	return false
end
function SWEP:ViewModelDrawn()
end
function SWEP:OnRestore()
end
function SWEP:OnRemove()
end
function SWEP:CustomAmmoDisplay()
end
function SWEP:TranslateFOV(current_fov)
	return current_fov
end
function SWEP:DrawWorldModel()
	self.Weapon:DrawModel()
end
function SWEP:DrawWorldModelTranslucent()
	self.Weapon:DrawModel()
end
function SWEP:AdjustMouseSensitivity()
	return nil
end

