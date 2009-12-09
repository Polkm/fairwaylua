
include('shared.lua')



function ENT:Initialize()
	self:SetNoDraw(true)
	for a,b in pairs(ents.FindByClass("snpc_citizen")) do
		if b:GetPos():Distance(self:GetPos()) < 1000 then
			if !b.Panic then
				b.Panic = true
				b:SetSchedule(schdFleeShot)
			end
			b.PanicEnt = self
		end
	end
	timer.Simple(30,function() if self:IsValid() then self:Remove() end end)
end
function ENT:AcceptInput(name,activator,caller)
end
function ENT:KeyValue(key,value)
end
function ENT:OnRemove()
end
function ENT:Think() 
end
