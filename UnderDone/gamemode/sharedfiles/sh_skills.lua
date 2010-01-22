local Player = FindMetaTable("Player")
local intSkillPointsPerLevel = 1

local Skill = {}
Skill.Name = "skill_basictraining"
Skill.PrintName = "Basic Training"
Skill.Tier = 1
Skill.Levels = 3
Skill.Desc = {}
Skill.Desc[1] = "Increase Dexterity by 2"
Skill.Desc[2] = "Increase Dexterity by 3"
Skill.Desc[3] = "Increase Dexterity by 4"
function Skill:OnSet(ply, intSkillLevel, intOldSkillLevel)
	local tblStatTable = {}
	tblStatTable[0] = 0
	tblStatTable[1] = 2
	tblStatTable[2] = 3
	tblStatTable[3] = 4
	ply:AddStat("stat_dexterity", tblStatTable[intSkillLevel] - tblStatTable[intOldSkillLevel])
end
Skill.Icon = "icons/weapon_pistol"
Register.Skill(Skill)

local Skill = {}
Skill.Name = "skill_closecombat"
Skill.PrintName = "Close Quarters Combat"
Skill.Tier = 1
Skill.Levels = 3
Skill.Desc = {}
Skill.Desc[1] = "Increase Strength by 1"
Skill.Desc[2] = "Increase Strength by 3"
Skill.Desc[3] = "Increase Strength by 5"
function Skill:OnSet(ply, intSkillLevel, intOldSkillLevel)
	local tblStatTable = {}
	tblStatTable[0] = 0
	tblStatTable[1] = 1
	tblStatTable[2] = 3
	tblStatTable[3] = 5
	ply:AddStat("stat_strength", tblStatTable[intSkillLevel] - tblStatTable[intOldSkillLevel])
end
Skill.Icon = "icons/junk_gnome"
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
	local intSkillPoints = self:GetLevel() * intSkillPointsPerLevel
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
		plyNewPlayer:SetNWInt("SkillPoints", plyNewPlayer:GetNWInt("SkillPoints") + intSkillPointsPerLevel)
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