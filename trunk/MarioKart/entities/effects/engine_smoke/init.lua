
function EFFECT:Init(tblData)
	local entCartEntity = tblData:GetEntity()
	local vecStartPos = tblData:GetOrigin()
	--local clrDrawColor = tblData:GetStart()
	local Emitter = ParticleEmitter(vecStartPos, true)
	timer.Create(tostring(self) .. "PuffTimer", 0.05, 0, function()
		local intNumberOfParticles = 5
		for i = 0, intNumberOfParticles do
			local intSize = math.Rand(4, 5)
			local vecPosition =
				entCartEntity:GetPos() +
				(entCartEntity:GetAngles():Forward() * (vecStartPos.y + (intSize / 2))) +
				(entCartEntity:GetAngles():Right() * (vecStartPos.x - (intSize / 2))) +
				(entCartEntity:GetAngles():Up() * (vecStartPos.z - (intSize / 2)))
			local prtlSmoke = Emitter:Add("particle/particle_smokegrenade", vecPosition)
			--local prtlSmoke = Emitter:Add("effects/freeze_unfreeze", vecPosition)
			if prtlSmoke then
				prtlSmoke:SetVelocity(Vector(0, 0, 0))
				prtlSmoke:SetLifeTime(0)
				prtlSmoke:SetDieTime(0.2)
				prtlSmoke:SetStartAlpha(200)
				prtlSmoke:SetEndAlpha(50)
				prtlSmoke:SetStartSize(intSize)
				prtlSmoke:SetEndSize(intSize)
				--prtlSmoke:SetRoll(math.Rand(0, 360))
				--prtlSmoke:SetRollDelta(math.Rand(-5, 5))
				prtlSmoke:SetAirResistance(400)
				prtlSmoke:SetGravity(Vector(0, 0, 10))
				local intRndColor = math.Rand(0.8, 1.0)
				--prtlSmoke:SetColor(clrDrawColor.r * intRndColor, clrDrawColor.g * intRndColor, clrDrawColor.b * intRndColor)
				prtlSmoke:SetAngleVelocity(Angle(math.Rand(-160, 160), math.Rand(-160, 160), math.Rand(-160, 160))) 
				prtlSmoke:SetCollide(false)
				prtlSmoke:SetLighting(true)
			end
		end
	end)
	--emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
