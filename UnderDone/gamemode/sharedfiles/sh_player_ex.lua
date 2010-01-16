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

if SERVER then
	function Player:GiveExp(intAmount)
		local intCurrentExp = self:GetNWInt("exp")
		local intPreExpLevel = self:GetLevel()
		if intCurrentExp + intAmount >= 0 then
			local intTotal = intCurrentExp + intAmount
			self:SetNWInt("exp", math.Clamp(intTotal, toExp(intPreExpLevel), intTotal))
			local intPostExpLevel = self:GetLevel()
			if intPreExpLevel < intPostExpLevel then
				for _,ply in pairs(player.GetAll()) do
					if ply:GetPos():Distance(self:GetPos()) < 200 then
						ply:CreateIndacator("Holy_Shit_Your_Cool!", self:GetPos() + Vector(0, 0, 70), "purple")
						ply:CreateIndacator("Nice_Man!", self:GetPos() + Vector(0, 0, 70), "blue")
						ply:CreateIndacator("You_Are_Epic!", self:GetPos() + Vector(0, 0, 70), "orange")
						ply:CreateIndacator("I_Wish_I_Was_As_Cool_As_You!", self:GetPos() + Vector(0, 0, 70), "purple")
						ply:CreateIndacator("I_Jizzed!", self:GetPos() + Vector(0, 0, 70), "blue")
						ply:CreateIndacator("Gratz!", self:GetPos() + Vector(0, 0, 70), "orange")
						ply:CreateIndacator("I_Just_Shat_My_Pants!", self:GetPos() + Vector(0, 0, 70), "blue")
						ply:CreateIndacator("Call_Me!", self:GetPos() + Vector(0, 0, 70), "purple")
						ply:CreateIndacator("You_Should_Model!", self:GetPos() + Vector(0, 0, 70), "orange")
					end
				end
			end
		end
	end

	function Player:CreateIndacator(strMessage, vecPosition, strColor)
		local strSendColor = strColor or "white"
		local tblVector = {}
		tblVector[1] = math.Round(vecPosition.x)
		tblVector[2] = math.Round(vecPosition.y)
		tblVector[3] = math.Round(vecPosition.z)
		self:ConCommand("UD_AddDamageIndacator " .. strMessage .. " " .. table.concat(tblVector, "!") .. " " .. strSendColor)
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
				dmginfo:SetDamage(math.Clamp(math.Round(dmginfo:GetDamage() + math.random(-1, 1)), 0, 9999))
				if dmginfo:GetDamage() > 0 then
					for _,ply in pairs(player.GetAll()) do
						if ply:GetPos():Distance(entVictim) < 200 then
							ply:CreateIndacator(dmginfo:GetDamage(), dmginfo:GetDamagePosition(), clrDisplayColor)
						end
					end
				else
					for _,ply in pairs(player.GetAll()) do
						if ply:GetPos():Distance(entVictim) < 200 then
							ply:CreateIndacator("Miss!", dmginfo:GetDamagePosition(), "orange")
						end
					end
				end
			end
		end
	end
	hook.Add("EntityTakeDamage", "PlayerAdjustDamage", PlayerAdjustDamage)
end