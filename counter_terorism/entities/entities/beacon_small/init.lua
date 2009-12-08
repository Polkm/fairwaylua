
include('shared.lua')



function ENT:Initialize()
	print("initilized")
	for a,b in pairs(ents.FindByClass("snpc_citizen")) do
		print(b:GetPos():Distance(self:GetPos()))
		if b:GetPos():Distance(self:GetPos()) < 1000 then
			if !b.Panic then
				b.Panic = true
				b:SetSchedule(schdFleeShot)
			end
			b.PanicPos = self:GetPos()
			print("shouldmove")
		end
	end
	self:Remove()
end
function ENT:AcceptInput(name,activator,caller)
end
function ENT:KeyValue(key,value)
end
function ENT:OnRemove()
end
function ENT:Think() 
end
