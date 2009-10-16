require("glon")
require("gm_sqlite")
local Player = FindMetaTable("Player")

function GM:Initialize()
	if !sql.TableExists("player_acounts") then
		local SQLQuery = "CREATE TABLE player_acounts (unique_id varchar(255), cash int, locker text, perks text)"
		local SQLResult = sql.Query(SQLQuery)
		if sql.TableExists("player_acounts") then
			print("Succes ! table 1 created \n")
		else
			print("Somthing went wrong with the player_acounts query !\n")
			print(sql.LastError(SQLResult) .. "\n")
		end
	end
end

function Player:SQLExist()
	local steamID = self:GetNWString("SteamID")
	local SQLResult = sql.Query("SELECT unique_id, cash FROM player_acounts WHERE unique_id = '"..steamID.."'")
	if SQLResult then
		self:SQLLoadGame()
	else
		self:SQLNewGame()
	end
end

function Player:SQLLoadGame()

end

function Player:SQLSaveGame()
	
end

function Player:SQLNewGame()
	self.Locker = {}
	self:AddWeaponToLocker("weapon_mp5_tx")
	self:AddWeaponToLocker("weapon_p220_tx")
	self:SetNWInt("ActiveWeapon", 1)
	self:SetNWInt("Weapon1", 1)
	self:SetNWInt("Weapon2", 2)
	self.Perks = {}
	self.Perks["perk_ammoup"] = false
	local steamID = self:GetNWString("SteamID")
	local intCash = self:GetNWInt("cash")
	local strLockerSaveString = glon.encode(self.Locker)
	local strPerksSaveString = glon.encode(self.Perks)
	if SQLResult then
	local strQuery = "INSERT INTO player_acounts (`unique_id`, `cash`, `locker`, `perks`)VALUES ('" .. steamID .. "', '" .. intCash .. "', '" .. strLockerSaveString .. "', '" .. strPerksSaveString .. "')"
	sql.Query(strQuery)
	local SQLResult = sql.Query("SELECT unique_id, money FROM player_info WHERE unique_id = '"..steamID.."'")
	if SQLResult then
		print("Player account created !\n")
	else
		print("Something went wrong with creating a players info !\n")
	end
end