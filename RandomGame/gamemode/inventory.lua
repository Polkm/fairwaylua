include( 'shared.lua' )

function AddToInventory(ply,item)
	local Inv = ply.inventory
	for k,v in pairs(Inv) do
		if v.Item == 0  then
			for a,b in pairs(Weapons) do
				if v.Item == a then 
					Inv[k].Item = item
					Inv[k].Amount = Inv[k].Amount + 1
					SendDataToAClient(ply)
					return
				end
			end
			Inv[k].Item = item
			Inv[k].Amount =  1
			SendDataToAClient(ply)
			return
		elseif v.Item == item && v.Amount >= Items[v.Item].Max then
			print(fail)
		elseif v.Item == item && v.Amount << Items[v.Item].Max then
			Inv[k].Item = item
			Inv[k].Amount = Inv[k].Amount + 1
			SendDataToAClient(ply)
			return
		end
	end
end

function RemoveItem(ply,slot)
	ply.inventory[math.Round(slot)] = {Item = 0,Amount = 0}
	SendDataToAClient(ply)
end

function UseItem(ply,command,args)
	local item = args[1]
	local slot = math.Round(args[2])
	local Inv = ply.inventory
	if Inv[slot].Item != 0 then 
		Items[item].Function(ply)
		for k,v in pairs(Weapons) do
			if item == k then 
				return 
			end
		end
		if Inv[slot].Amount <=  1 then
			RemoveItem(ply,args[2])
		else	
			Inv[slot].Amount = Inv[slot].Amount - 1
			SendDataToAClient(ply)
		end
	end
end
concommand.Add("UseItem",UseItem)

function GiveItem(ply,command,args)
	local trace = ply:GetEyeTraceNoCursor( )
	if !trace.Hit then return end
	if trace.HitWorld then return end	
	if trace.Entity:IsPlayer() && trace.Entity:Team() == TEAM_HUNK then
		local item = args[1]
		local slot = tonumber(math.Round(args[2]))
		local rply = trace.Entity
		local Inv = ply.inventory
		local rInv = rply.inventory	
		//if ply:GetPos():Distance(rply:GetPos()) >> 90 then return end
		if HasRoom(rply,item) then
			AddToInventory(rply,item)
			rply:PrintMessage(HUD_PRINTTALK,ply:Nick().." gave you a "..Items[item].Name)
			if Inv[math.Round(args[2])].Amount <=  1 then
				RemoveItem(ply,math.Round(args[2]))
			else
				Inv[math.Round(args[2])].Amount = Inv[math.Round(args[2])].Amount - 1
				SendDataToAClient(ply)
			end
			for k,v in pairs(Weapons) do 
				if item == k then  
					ply:StripWeapon(v.Weapon)
					ply:EmitSound("items/ammo_pickup.wav",110,100)
					rply:Give(v.Weapon)
					rply:SelectWeapon(b.Weapon)
					rply.Upgrades[item] = ply.Upgrades[item]
					ply.Upgrades[item] = {pwrlvl = 1,accrlvl = 1, clplvl = 1,spdlvl = 1}
					RemoveItem(ply,math.Round(args[2]))
					break
				end
			end
		end
	end
end
concommand.Add("GiveItem",GiveItem)

function HasRoom(ply,item)
	local Inv = ply.inventory
	for k,v in pairs(Inv) do
		for a,b in pairs(Weapons) do
			if a == item then
				if v.Item == item then
					return false
				end
			end
		end
			if v.Item == 0 && v.Amount == 0 then
				return true
			elseif v.Item == item then
				if v.Amount < Items[v.Item].Max then
					return true
				elseif v.Amount >= Items[v.Item].Max then
					for k,v in pairs(ply.inventory) do
						if v.Item == 0 && v.Amount == 0 then
							return true
						elseif v.Item == item then
							if v.Amount < Items[v.Item].Max then
								return true
							end
						end
					end
				return false
			end
		end
	end
	return false
end

function DropItem(ply,command,args)
	local item = args[1]
	local slot = math.Round(args[2])
	local Inv = ply.inventory
	for k,v in pairs(Weapons) do 
		if item == k then
			ply:StripWeapon(v.Weapon)
		end
	end
	MakeAndThrow(ply,item,args[3])
	if Inv[slot].Amount <=  1 then
		RemoveItem(ply,slot)
	else	
		Inv[slot].Amount = Inv[slot].Amount - 1
		SendDataToAClient(ply)
	end
end
concommand.Add("DropItem",DropItem)

function MakeAndThrow(ply,item,force)
	local tr = ply:GetEyeTrace()
	local DropedEnt = ents.Create(item)
	DropedEnt:SetAngles(ply:EyeAngles())
	DropedEnt:Spawn()
	if item == "item_c4" || item == "item_landmine" then
		DropedEnt:SetPos(ply:GetPos())
	else
		DropedEnt:SetPos(ply:EyePos() + (ply:GetAimVector() * 30))
		DropedEnt:GetPhysicsObject():ApplyForceCenter (ply:GetAimVector():GetNormalized() * math.pow(tr.HitPos:Length(),force))
	end
	for k,v in pairs(Weapons) do
		if DropedEnt:GetClass() == k then
			DropedEnt.Upgrades = {}
			DropedEnt.Upgrades = ply.Upgrades[k]
			DropedEnt.hasupgrade = true
			print(util.TableToKeyValues(DropedEnt.Upgrades))
			ply.Upgrades[k] = {pwrlvl = 1,accrlvl = 1, clplvl = 1,spdlvl = 1}
		end
	end
	timer.Simple(600,function() DropedEnt:Remove() end)
end

function UpgradeWeapon(ply,command,args)
	local upg = ply.Upgrades
	local weapon = args[1]
	local trait = args[2]
	local cash = tonumber(ply:GetNWInt("Money"))
	local pwr = upg[weapon].pwrlvl
	local acc = upg[weapon].accrlvl
	local clp = upg[weapon].clplvl
	local fis = upg[weapon].spdlvl
	local res = upg[weapon].reslvl
	if trait == "Power" && upg[weapon].pwrlvl != UpgradeLevels[weapon].MaxPower then
		if cash >= UpgPrices[weapon].Power[pwr] then
			ply:SetNWInt("Money", cash - UpgPrices[weapon].Power[pwr])			
			upg[weapon].pwrlvl = upg[weapon].pwrlvl + 1
		end
	elseif trait == "Accuracy" && upg[weapon].accrlvl != UpgradeLevels[weapon].MaxAccuracy  then
		if  cash >= UpgPrices[weapon].Accuracy[acc] then	
		ply:SetNWInt("Money", cash - UpgPrices[weapon].Accuracy[acc])
		upg[weapon].accrlvl = upg[weapon].accrlvl + 1
		end
	elseif trait == "ClipSize" && upg[weapon].clplvl != UpgradeLevels[weapon].MaxClipSize then
		if  cash >= UpgPrices[weapon].ClipSize[clp] then	
			ply:SetNWInt("Money", cash - UpgPrices[weapon].ClipSize[clp])			
			upg[weapon].clplvl = upg[weapon].clplvl + 1
		end
	elseif trait == "FiringSpeed" && upg[weapon].spdlvl != UpgradeLevels[weapon].MaxFiringSpeed  then
		if  cash >= UpgPrices[weapon].FiringSpeed[fis] then	
			ply:SetNWInt("Money", cash - UpgPrices[weapon].FiringSpeed[fis])		
			upg[weapon].spdlvl = upg[weapon].spdlvl + 1
		end
	elseif trait == "ReloadSpeed" && upg[weapon].spdlvl != UpgradeLevels[weapon].MaxReloadSpeed  then
		if  cash >= UpgPrices[weapon].FiringSpeed[res] then	
			ply:SetNWInt("Money", cash - UpgPrices[weapon].FiringSpeed[res])		
			upg[weapon].reslvl = upg[weapon].reslvl + 1
		end
	end
	if ply:GetActiveWeapon():GetClass() == Weapons[weapon].Weapon then
		ply:GetActiveWeapon():Update()
	end
end
concommand.Add("UpgradeWeapon",UpgradeWeapon)

function BuyItem(ply,command,args)
local inv = ply.inventory
local cash = tonumber(ply:GetNWInt("Money"))
local item = args[1]
local price = tonumber(args[2])
	if HasRoom(ply,item) then
		if cash >= price then 
			AddToInventory(ply,item)
			ply:SetNWInt("Money",cash - price)
			for k,v in pairs(Weapons) do 
				if item == k then 
					if ply:Team() == TEAM_HUNK then
						ply:Give(Weapons[k].Weapon)
						ply.Upgrades[k] = {pwrlvl = 1, accrlvl = 1, clplvl = 1, spdlvl = 1, reslvl = 1 }
					end
				end
			end
		end
	end
end
concommand.Add("BuyItem",BuyItem)

function SellWeapon(ply,command,args)
local inv = ply.inventory
local cash = tonumber(ply:GetNWInt("Money"))
local item = args[1]
local slot = math.Round(args[2])
local upg = ply.Upgrades
local pwr = upg[item].pwrlvl
local acc = upg[item].accrlvl
local clp = upg[item].clplvl
local fis = upg[item].spdlvl
local res = upg[weapon].reslvl
local pwraddition = 0
local accaddition = 0
local clpaddition = 0
local fisaddition = 0
local spdaddition = 0
	if pwr > 1 then
	pwraddition = UpgPrices[item].Power[pwr] / 2 
	elseif acc > 1 then
		accaddition = UpgPrices[item].Accuracy[acc] / 2 
	elseif clp > 1 then
		clpaddition = UpgPrices[item].ClipSize[clp] / 2 
	elseif fis > 1 then
		fisaddition = UpgPrices[item].FiringSpeed[fis] / 2 
	elseif fis > 1 then
		spdaddition = UpgPrices[item].FiringSpeed[spd] / 2 
	end
local price = Items[item].Price / 2 + pwraddition + accaddition + clpaddition + fisaddition + spdaddition
	for k,v in pairs(Weapons) do 
		if item == k then 
			if ply:Team() == TEAM_HUNK then
				ply:StripWeapon(Weapons[k].Weapon)
			end
		ply:SetNWInt("Money",cash + price)
		RemoveItem(ply,slot)
		ply.Upgrades[k] = {pwrlvl = 1, accrlvl = 1, clplvl = 1, spdlvl = 1,reslvl }
		break
		end
	end
end
concommand.Add("SellWeapon",SellWeapon)


Locker = {}
Locker[1] = {
	weapon = "weapon_pistol"
	upgrades = {
		acuarsy = 1
		powor = 2
		clip = 3
		speed = 1
	}
}
Locker[2] = {
	weapon = "weapon_pistol"
	upgrades = {
		acuarsy = 1
		powor = 4
		clip = 2
		speed = 4
	}
}
Locker[3] = {
	weapon = "weapon_smg"
	upgrades = {
		acuarsy = 2
		powor = 1
		clip = 3
		speed = 1
	}
}

ply.SetNWVar("Weapon1",1)
ply.SetNWVar("Weapon2",3)






