local Quest = {}
Quest.Name = "quest_killzombies"
Quest.PrintName = "Quest Killzombie"
Quest.Kill = {}
Quest.Kill["npc_zombie"] = 10
Quest.GainedExp = 100
Quest.GainedItems = {}
Quest.GainedItems["money"] = 50
Register.Quest(Quest)

local Quest = {}
Quest.Name = "quest_obtainzombieblood"
Quest.PrintName = "Quest ZombieBlood"
Quest.Description = "We've been researching into an anti virus for containing the zombies but we need a few blood samples"
Quest.ObtainItems = {}
Quest.ObtainItems["zombie_blood"] = 10
Quest.GainedExp = 200
Register.Quest(Quest)

local Quest = {}
Quest.Name = "quest_killantlionboss"
Quest.PrintName = "Quest KillAntlionboss"
Quest.TeamAllowed = 2
Quest.GainedExp = 500
Quest.Kill = {}
Quest.Kill["npc_antlionguard"] = 1
Register.Quest(Quest)

function KillNPC(npc, killer, weapon)
	if npc:GetNWInt("level") > 0 && killer:IsPlayer() then
		local tblNPCTable = NPCTable(npc:GetNWString("npc"))
		local tblQuestTable = QuestTable(tblNPCTable.Quest)
		if tblQuestTable && tblQuestTable.Kill then
			for Kill, args in pairs(tblQuestTable.Kill or {}) do
				if npc:GetClass() == Kill then
				end
			end
		end
	end
end
hook.Add( "OnNPCKilled", "KillNPC", KillNPC )
