GM.Name 		= "UnderDone RP"
GM.Author 		= "Shell Shocked"
GM.Email 		= ""
GM.Website 		= ""
GM.TeamBased 	= true
-------------
MaxWeight = 20
-------------

GM.DataBase = {}
GM.DataBase.Items = {}
GM.DataBase.NPCs = {}

Register = {}
function Register.Item(tblItem)
	GM.DataBase.Items[tblItem.Name] = tblItem
end
function Register.NPC(tblItem)
	GM.DataBase.NPCs[tblItem.Name] = tblItem
end

--Polkm: Example NPCs
local NPC = {}
NPC.Name = "citezen"
NPC.Gender = "random"
NPC.Wander = true
function NPC:GenerateInv(npc)
	npc.Inventory = {}
	npc.Inventory["money"] = math.random(5,25)
end
Register.NPC(NPC)

local NPC = {}
NPC.Name = "cop"
NPC.Gender = "random"
NPC.Wander = true
NPC.Cop = true
function NPC:GenerateInv(npc)
	npc.Inventory = {}
	npc.Inventory["money"] = math.random(5,50)
	npc.Inventory["pistol"] = 1
end
Register.NPC(NPC)