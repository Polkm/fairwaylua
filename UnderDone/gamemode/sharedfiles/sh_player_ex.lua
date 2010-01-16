local Player = FindMetaTable("Player")

function Player:IsMelee()
	if ItemTable(self:GetSlot("slot_primaryweapon")) && ItemTable(self:GetSlot("slot_primaryweapon")).HoldType then
		return ItemTable(self:GetSlot("slot_primaryweapon")).HoldType == "melee"
	end
	return
end

function Player:GetLevel()
	return toLevel(self:GetNWInt("exp"))
end

function Player:GetArmorRating()
	local intTotalArmor = 1
	if !self.Data.Paperdoll then return intTotalArmor end
	for slot, item in pairs(self.Data.Paperdoll or {}) do
		local tblItemTable = ItemTable(item)
		if tblItemTable && tblItemTable.Armor then
			intTotalArmor = intTotalArmor + tblItemTable.Armor
		end
	end
	return intTotalArmor
end

if SERVER then
	function Player:GiveExp(intAmount)
		local intCurrentExp = self:GetNWInt("exp")
		local intPreExpLevel = self:GetLevel()
		if intCurrentExp + intAmount >= 0 then
			local intTotal = intCurrentExp + intAmount
			self:SetNWInt("exp", math.Clamp(intTotal, toExp(intPreExpLevel), intTotal))
			local intPostExpLevel = self:GetLevel()
			if intPreExpLevel < intPostExpLevel then
				self:CreateIndacator("Holy_Shit_Your_Cool!", self:GetPos() + Vector(0, 0, 70), "purple", true)
				self:CreateIndacator("Nice_Man!", self:GetPos() + Vector(0, 0, 70), "blue", true)
				self:CreateIndacator("You_Are_Epic!", self:GetPos() + Vector(0, 0, 70), "orange", true)
				self:CreateIndacator("I_Wish_I_Was_As_Cool_As_You!", self:GetPos() + Vector(0, 0, 70), "purple", true)
				self:CreateIndacator("I_Jizzed!", self:GetPos() + Vector(0, 0, 70), "blue", true)
				self:CreateIndacator("Gratz!", self:GetPos() + Vector(0, 0, 70), "orange", true)
				self:CreateIndacator("I_Just_Shat_My_Pants!", self:GetPos() + Vector(0, 0, 70), "blue", true)
				self:CreateIndacator("Call_Me!", self:GetPos() + Vector(0, 0, 70), "purple", true)
				self:CreateIndacator("You_Should_Model!", self:GetPos() + Vector(0, 0, 70), "orange", true)
			end
		end
	end

	function Player:CreateIndacator(strMessage, vecPosition, strColor, boolAll)
		local strSendColor = strColor or "white"
		local tblVector = {}
		tblVector[1] = math.Round(vecPosition.x)
		tblVector[2] = math.Round(vecPosition.y)
		tblVector[3] = math.Round(vecPosition.z)
		local strCommand = "UD_AddDamageIndacator " .. strMessage .. " " .. table.concat(tblVector, "!") .. " " .. strSendColor
		self:ConCommand(strCommand)
		if boolAll then
			for _, ply in pairs(player.GetAll()) do
				if self != ply && ply:GetPos():Distance(self:GetPos()) < 200 then
					ply:ConCommand(strCommand)
				end
			end
		end
	end
	
	function Player:CreateNotification(strMessage)
		self:ConCommand("UD_AddNotification " .. strMessage) 
	end
	
	local function PlayerAdjustDamage(entVictim, entInflictor, entAttacker, intAmount, dmginfo)
		if entVictim:IsPlayer() then
			local clrDisplayColor = "red"
			local tblNPCTable = NPCTable(entAttacker:GetNWString("npc"))
			if tblNPCTable then
				dmginfo:SetDamage(tblNPCTable.Damage or 0)
				print(entVictim:GetArmorRating())
				print(1 / (((entVictim:GetArmorRating() - 1) / 25) + 1))
				dmginfo:SetDamage(dmginfo:GetDamage() * (1 / (((entVictim:GetArmorRating() - 1) / 25) + 1)))
				dmginfo:SetDamage(math.Clamp(math.Round(dmginfo:GetDamage() + math.random(-1, 1)), 0, 9999))
				if dmginfo:GetDamage() > 0 then
					entVictim:CreateIndacator(dmginfo:GetDamage(), dmginfo:GetDamagePosition(), clrDisplayColor)
				else
					entVictim:CreateIndacator("Miss!", dmginfo:GetDamagePosition(), "orange")
				end
			end
		end
	end
	hook.Add("EntityTakeDamage", "PlayerAdjustDamage", PlayerAdjustDamage)
end