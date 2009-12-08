include('shared.lua')
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()
	self.Entity:DrawModel()
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ZomBlood ( UMsg )
	local vPoint = UMsg:ReadVector();
	local effectdata = EffectData()
	effectdata:SetStart( vPoint )
	effectdata:SetOrigin( vPoint )
	effectdata:SetScale( 1 )
	util.Effect('BloodImpact', effectdata);
end
usermessage.Hook('zomblood', ZomBlood);