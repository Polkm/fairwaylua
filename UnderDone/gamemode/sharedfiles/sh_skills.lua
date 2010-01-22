local Player = FindMetaTable("Player")
local intSkillPointsPerLeve = 1

local Skill = {}
Skill.Name = "skill_basictraining"
Skill.PrintName = "Basic Training"
Skill.Tier = 1
Skill.Levels = 2
Skill.Desc = {}
Skill.Desc[1] = "Increase dexterity by 1"
Skill.Desc[2] = "Increase dexterity by 2"
Skill.Desc[3] = "Increase dexterity by 4"
function Skill:OnSet(ply, intSkillLevel, intOldSkillLevel)
	local intDirection = math.abs(intSkillLevel - intOldSkillLevel) / (intSkillLevel - intOldSkillLevel)
	local intAddValue = 0
	local intRemoveValue = 0
	if intSkillLevel == 1 then intAddValue = 2 end
	if intOldSkillLevel == 1 then intRemoveValue = 2 end
	if intSkillLevel == 2 then intAddValue = 5 end
	if intOldSkillLevel == 2 then intRemoveValue = 5 end
	ply:AddStat("stat_dexterity", intDirection * intAddValue)
	ply:AddStat("stat_dexterity", -intDirection * intRemoveValue)
end
Skill.Icon = "icons/weapon_pistol"
Register.Skill(Skill)

function Player:SetSkill(strSkill, intAmount)
	local tblSkillTable = SkillTable(strSkill)
	if tblSkillTable then
		intAmount = intAmount or 0
		self.Data.Skills = self.Data.Skills or {}
		local intOldSkill = self.Data.Skills[strSkill] or 0
		self.Data.Skills[strSkill] = intAmount
		if SERVER then
			if tblSkillTable.OnSet then
				tblSkillTable:OnSet(self, intAmount, intOldSkill)
			end
			SendUsrMsg("UD_UpdateSkills", self, {strSkill, intAmount})
		end
		if CLIENT then
			if GAMEMODE.MainMenu then GAMEMODE.MainMenu.CharacterTab:LoadSkills() end
			if GAMEMODE.MainMenu then GAMEMODE.MainMenu.InventoryTab:LoadInventory() end
		end
	end
end

function Player:GetSkill(strSkill)
	self.Data.Skills = self.Data.Skills or {}
	return self.Data.Skills[strSkill] or 0
end

function Player:GetSkillPoints()
	local intSkillPoints = self:GetLevel() * intSkillPointsPerLeve
	for strSkill, intAmount in pairs(self.Data.Skills or {}) do
		intSkillPoints = math.Clamp(intSkillPoints - intAmount, 0, self:GetLevel())
	end
	return intSkillPoints
end

if SERVER then
	hook.Add("UD_Hook_PlayerLoad", "PlayerLoad_SkillPoints", function(plyNewPlayer)
		plyNewPlayer:SetNWInt("SkillPoints", plyNewPlayer:GetSkillPoints())
	end)
	
	hook.Add("UD_Hook_PlayerLevelUp", "PlayerLevelUp_SkillPoints", function(plyNewPlayer)
		plyNewPlayer:SetNWInt("SkillPoints", plyNewPlayer:GetNWInt("SkillPoints") + intSkillPointsPerLeve)
	end)
	
	function Player:BuySkill(strSkill)
		if self:GetNWInt("SkillPoints") <= 0 then return false end
		local tblSkillTable = SkillTable(strSkill)
		if !tblSkillTable then return false end
		if self:GetSkill(strSkill) < tblSkillTable.Levels then
			self:SetSkill(strSkill, self:GetSkill(strSkill) + 1)
			self:SetNWInt("SkillPoints", self:GetNWInt("SkillPoints") - 1)
			return true
		end
	end
	concommand.Add("UD_BuySkill", function(ply, command, args) ply:BuySkill(args[1]) end)
end

if CLIENT then
	usermessage.Hook("UD_UpdateSkills", function(usrMsg)
		LocalPlayer():SetSkill(usrMsg:ReadString(), usrMsg:ReadLong())
	end)
end