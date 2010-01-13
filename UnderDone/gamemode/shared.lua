-------------------------
---------Generic---------
GM.Name 		= "UnderDone"
GM.Author 		= "Shell Shocked Gaming"
GM.Email 		= "polkmpolkmpolkm@gmail.com"
GM.Website 		= "http://shellshocked.net46.net/"
-----Global Vars---------
GM.MonsterViewDistance = 140
GM.RelationHate = 1
GM.RelationFear = 2
GM.RelationLike = 3
GM.RelationNeutral = 4
-----Global Inv Vars-----
MaxWeight = 25
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
function SlotTable(strSlot)
	return GAMEMODE.DataBase.Slots[strSlot]
end
local intStatIndex = 1
function Register.Stat(tblItem)
	GM.DataBase.Stats[tblItem.Name] = tblItem
	GM.DataBase.Stats[tblItem.Name].Index = intStatIndex
	intStatIndex = intStatIndex + 1
end
function StatTable(strStat)
	return GAMEMODE.DataBase.Stats[strStat]
end
function Register.NPC(tblItem)
	GM.DataBase.NPCs[tblItem.Name] = tblItem
end
function NPCTable(strNPC)
	return GAMEMODE.DataBase.NPCs[strNPC]
end
-------------------------

function toExp(intLevel)
	if intLevel <= 1 then intLevel = 0 end
	intLevel = math.pow(intLevel, 2)
	intLevel = intLevel * 20
	return intLevel
end

function toLevel(intExp)
	intExp = intExp / 20
	intExp = math.Clamp(intExp, 1, intExp)
	intExp = math.sqrt(intExp)
	intExp = math.floor(intExp)
	return intExp
end

if SERVER then
	function SendUsrMsg(strName, plyTarget, tblArgs)
		
			umsg.Start(strName, plyTarget)
			for _, value in pairs(tblArgs or {}) do
				if type(value) == "string" then umsg.String(value)
				elseif type(value) == "number" then umsg.Long(value)
				elseif type(value) == "boolean" then umsg.Bool(value)
				elseif type(value) == "entity" or type(value) == "Player" then umsg.Entity(value)
				elseif type(value) == "Vector" then umsg.Vector(value)
				elseif type(value) == "Angle" then umsg.Angle(value) end
			end
			umsg.End()
		
	end
end








