local Player = FindMetaTable("Player")

local Skill = {}
Skill.Name = "skill_smallarms"
Skill.PrintName = "Pistol Power"
Skill.Levels = 2
Skill.Desc = {}
Skill.Desc[1] = "Your damage with pistols increase by 2%"
Skill.Desc[2] = "Your damage with pistols increase by 5%"
function Skill:DamageMod(plyPlayer, intSkillLevel, intDamage)
	local intPercent = 0
	if intSkillLevel == 1 then intPercent = 2 end
	if intSkillLevel == 2 then intPercent = 5 end
	return intDamage + (intDamage * (intPercent / 100))
end
Skill.Icon = "icons/weapon_pistol"
Register.Skill(Skill)

function Player:SetSkill(strSkill, intAmount)
	local tblSkillTable = SkillTable(strSkill)
	if tblSkillTable then
		intAmount = intAmount or 0
		self.Data.Skills = self.Data.Skills or {}
		self.Data.Skills[strSkill] = intAmount
		if SERVER then
			SendUsrMsg("UD_UpdateSkils", self, {strSkill, intAmount})
		end
	end
end

function Player:GetSkill(strSkill)
	self.Data.Skills = self.Data.Skills or {}
	return self.Data.Skills[strSkill] or 0
end

if CLIENT then
	usermessage.Hook("UD_UpdateSkils", function(usrMsg)
		LocalPlayer():SetSkill(usrMsg:ReadString(), usrMsg:ReadLong())
	end)
end