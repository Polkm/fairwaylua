include('shared.lua')
SWEP.PrintName			= "Scripted Weapon"
SWEP.Slot				= 0
SWEP.SlotPos			= 10
SWEP.DrawAmmo			= true
SWEP.DrawCrosshair		= false
SWEP.SwayScale			= 1.0
SWEP.BobScale			= 1.0
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

