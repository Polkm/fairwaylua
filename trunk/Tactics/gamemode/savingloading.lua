local Player = FindMetaTable("Player")

function Player:Save()
	local strSteamID = string.Replace(self:SteamID(), ":", ";")
	if strSteamID != "STEAM_ID_PENDING" then
		local strFilePath = "Tactics/" .. strSteamID .. "/playerinfo.txt"
		local tblSaveTable = {}
		tblSaveTable["name"] = self:Nick()
		tblSaveTable["cash"] = self:GetNWInt("cash")
		tblSaveTable["locker"] = self.Locker
		tblSaveTable["perks"] = self.Perks
		tblSaveTable["weapon1"] = self:GetNWInt("Weapon1")
		tblSaveTable["weapon2"] = self:GetNWInt("Weapon2")
		local strConvertedTable = util.TableToKeyValues(tblSaveTable)
		file.Write(strFilePath, strConvertedTable)
		return true
	end
	return false
end

function Player:Load()
	local strSteamID = string.Replace(self:SteamID(),":",";")
	if strSteamID != "STEAM_ID_PENDING" then
		local strFilePath = "Tactics/" .. strSteamID .. "/playerinfo.txt"
		if !file.Exists(strFilePath) then
			self:SetNWInt("cash", 0)
			self.Locker = {}
			self.Perks = {}
			self:AddWeaponToLocker("weapon_p220_tx")
			self:SetNWInt("ActiveWeapon", 1)
			self:SetNWInt("Weapon1", 1)
		elseif file.Exists(strFilePath) then
			local tblLoadedTable = util.KeyValuesToTable(file.Read(strFilePath))
			local strLoadedCash = tblLoadedTable["cash"]
			local tblLoadedLocker = tblLoadedTable["locker"]
			local tblLoadedPerks = tblLoadedTable["perks"]
			local strLoadedWeapon1 = tblLoadedTable["weapon1"]
			local strLoadedWeapon2 = tblLoadedTable["weapon2"]
			self:SetNWInt("cash", tonumber(strLoadedCash))
			self:SetNWInt("Weapon1", tonumber(strLoadedWeapon1))
			self:SetNWInt("Weapon2", tonumber(strLoadedWeapon2))
			self:SetNWInt("ActiveWeapon", self:GetNWInt("Weapon1"))
			self.Locker = {}
			self.Perks = {}
			if tblLoadedLocker then
				for id, weaponTable in pairs(tblLoadedLocker) do
					self:AddWeaponToLocker(
					tostring(weaponTable["weapon"]),
					tonumber(weaponTable["maxpoints"]),
					tonumber(weaponTable["pwrlvl"]), 
					tonumber(weaponTable["acclvl"]),
					tonumber(weaponTable["clplvl"]),
					tonumber(weaponTable["spdlvl"]),
					tonumber(weaponTable["reslvl"]))
				end
			end
			if tblLoadedPerks then
				for id, active in pairs(tblLoadedPerks) do 
					self.Perks[tostring(id)] = tobool(active)
				end
			end
		end
		self:Save()
		timer.Create(self:Nick() .. "AutoSaver", 60, 0, function() self:Save() end)
		hook.Call("PlayerLoadout", GAMEMODE, self)
	else
		timer.Simple(0.1, function() self:Load() end)
	end
end