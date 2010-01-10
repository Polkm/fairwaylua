-------------------------
---------Generic---------
GM.Name 		= "UnderDone"
GM.Author 		= "Shell Shocked Gaming"
GM.Email 		= "polkmpolkmpolkm@gmail.com"
GM.Website 		= "http://shellshocked.net46.net/"
-----Global Inv Vars-----
MaxWeight = 20
--------DataBase---------
GM.DataBase = {}
GM.DataBase.Items = {}
GM.DataBase.Slots = {}
GM.DataBase.Stats = {}
GM.DataBase.NPCs = {}
--------Register---------
Register = {}
function Register.Item(tblItem)
	GM.DataBase.Items[tblItem.Name] = tblItem
end
function ItemTable(strItem)
	return GAMEMODE.DataBase.Items[strItem]
end
function Register.Slot(tblItem)
	GM.DataBase.Slots[tblItem.Name] = tblItem
end
local intStatIndex = 1
function Register.Stat(tblItem)
	GM.DataBase.Stats[tblItem.Name] = tblItem
	GM.DataBase.Stats[tblItem.Name].Index = intStatIndex
	intStatIndex = intStatIndex + 1
end
function Register.NPC(tblItem)
	GM.DataBase.NPCs[tblItem.Name] = tblItem
end
-------------------------

--Polkm: Example NPCs
local NPC = {}
NPC.Name = "zombie"
NPC.PrintName = "Zombie"
NPC.SpawnName = "npc_zombie"
NPC.HealthPerLevel = 10
Register.NPC(NPC)










