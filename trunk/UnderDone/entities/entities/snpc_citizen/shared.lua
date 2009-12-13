ENT.Base = "base_ai" 
ENT.Type = "ai"

Models = {}
Models.female = {}
Models.female[0] = "models/Humans/Group01/Female_01.mdl"
Models.male = {}
Models.cop = {}
Models.cop[0] = "models/police.mdl"

WatchEntities = {"player"}

function ENT:Ragdoll(dmgforce)
	if CLIENT then return false end
	local ragdoll = ents.Create("prop_ragdoll")
	ragdoll:SetModel(self:GetModel())
	ragdoll:SetPos(self:GetPos())
	ragdoll:SetAngles(self:GetAngles())
	ragdoll:SetVelocity(self:GetVelocity())
	ragdoll:Spawn()
	ragdoll:Activate()
	ragdoll:SetCollisionGroup(1)
	ragdoll:GetPhysicsObject():ApplyForceCenter(dmgforce)
	local function FadeOut(ragdoll)
		--Polkm: This will work better then the old one
		local Steps = 30
		local TimePerStep = 0.05
		local CurentAlpha = 255
		for i = 1, Steps do
			timer.Simple(i * TimePerStep, function()
				CurentAlpha = CurentAlpha - (255 / Steps)
				ragdoll:SetColor(255, 255, 255, CurentAlpha)
			end)
		end
		timer.Simple(Steps * TimePerStep, function() ragdoll:Remove() end)
	end
	timer.Simple(15, function() FadeOut(ragdoll) end)
end
/*
function ENT:TaskStart_LocateThreat( )
		for a,b in pairs(WatchEntities) do
		for k,v in pairs( ents.FindByClass( b ) ) do
			if (  v:IsValid() && v != self && v:GetClass() == b && v.Threat >= 1 && self:Visible(v)  ) then
				self:SetEnemy( v, true )
				self:UpdateEnemyMemory( v, v:GetPos() )
				if v:GetClass() == "player" then
					Msg("Get out of sight")
					timer.Simple(10,function() AttemptThreatCoolDown(v) end)
				end
				return
			elseif (  v:IsValid() && v != self && v:GetClass() == b && v.Threat <= 0  ) then
				
			end
		end	
	end
	self:SetEnemy( NULL )	
end

function ENT:Task_LocateThreat(  )

end*/