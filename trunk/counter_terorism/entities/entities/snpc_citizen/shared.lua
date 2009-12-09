ENT.Base = "base_ai" 
ENT.Type = "ai"

FemaleModels = {
	"models/Humans/Group01/Female_01.mdl",
	"models/Humans/Group01/Female_02.mdl",
	"models/Humans/Group01/Female_03.mdl",
	"models/Humans/Group01/Female_04.mdl",
	"models/Humans/Group01/Female_06.mdl",
	"models/Humans/Group01/Female_07.mdl",
	}
MaleModels = {
	"models/Humans/Group01/Male_01.mdl",
	"models/Humans/Group01/male_02.mdl",
	"models/Humans/Group01/male_03.mdl",
	"models/Humans/Group01/Male_04.mdl",
	"models/Humans/Group01/Male_05.mdl",
	"models/Humans/Group01/male_06.mdl",
	"models/Humans/Group01/male_07.mdl",
	"models/Humans/Group01/male_08.mdl",
	"models/Humans/Group01/male_09.mdl",
}

PanicMaleSounds = {
	"vo/npc/male01/goodgod.wav",
	"vo/npc/male01/gethellout.wav",
	"vo/npc/male01/gordead_ans04.wav",
	"vo/npc/male01/no01.wav",
	"vo/npc/male01/no02.wav",
	"vo/npc/male01/ohno.wav",
	"vo/npc/male01/gordead_ans19.wav",
	"vo/npc/male01/runforyourlife01.wav",
	"vo/npc/male01/runforyourlife02.wav",
	"vo/npc/male01/runforyourlife03.wav",
	"vo/npc/male01/wetrustedyou01.wav",
	"vo/npc/male01/wetrustedyou02.wav",	
}

PanicFemaleSounds = {
	"vo/npc/female01/goodgod.wav",
	"vo/npc/female01/gethellout.wav",
	"vo/npc/female01/gordead_ans02.wav",
	"vo/npc/female01/gordead_ans04.wav",
	"vo/npc/female01/gordead_ans05.wav",
	"vo/npc/female01/gordead_ans06.wav",
	"vo/npc/female01/gordead_ans05.wav",
	"vo/npc/female01/no01.wav",
	"vo/npc/female01/no02.wav",
	"vo/npc/female01/ohno.wav",
	"vo/npc/female01/runforyourlife01.wav",
	"vo/npc/female01/runforyourlife02.wav",
	"vo/npc/female01/runforyourlife03.wav",
	"vo/npc/female01/wetrustedyou01.wav",
	"vo/npc/female01/wetrustedyou02.wav",	
}

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
		timer.Simple(Steps * TimePerStep, function() if ragdoll:IsValid() then ragdoll:Remove() end end)
	end
	timer.Simple(15, function() if ragdoll:IsValid() then FadeOut(ragdoll) end   end)
end

