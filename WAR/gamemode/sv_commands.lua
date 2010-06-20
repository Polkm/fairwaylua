local Player = FindMetaTable("Player")

concommand.Add("WAR_Sellect", function(ply, command, args)
	if !args[1] then return end
	local TargetEnt = ents.GetByIndex(tonumber(args[1]))
	if TargetEnt.SquadTable && TargetEnt.SquadTable.Owner == ply then
		TargetEnt:Sellect()
	end
end)

function Player:ClearSellection()
	if !self.SellectedSquads then return end
	for _, Squad in pairs(self.SellectedSquads) do
		for l, Unit in pairs(Squad.Units) do Unit:SetNWBool("sellected", false) end
	end
	self.SellectedSquads = {}
end
concommand.Add("WAR_UnSellect", function(ply, command, args)
	ply:ClearSellection()
end)

function Player:MoveSellectedSquad(vecPostion)
	local TotalUnits = 0
	local SurfaceNeeded = 0
	if !self.SellectedSquads then return end
	for _, Squad in pairs(self.SellectedSquads) do
		Squad.HomePos = vecPostion
		TotalUnits = TotalUnits + #Squad.Units
		SurfaceNeeded = math.sqrt(TotalUnits * (1000 / ((TotalUnits / 200) + 1)))
		for _, Unit in pairs(Squad.Units) do
			local vecTargetPosition = vecPostion + Vector(math.random(-SurfaceNeeded, SurfaceNeeded), math.random(-SurfaceNeeded, SurfaceNeeded), 15)
			Unit:SeaseFire()
			Unit:MoveTo(vecTargetPosition)
			Unit:TurnTo(vecTargetPosition)
		end
	end
end
concommand.Add("WAR_MoveUnits", function(ply, command, args)
	ply:MoveSellectedSquad(Vector(tonumber(args[1]), tonumber(args[2]), tonumber(args[3])))
end)

function Player:AttackWithSellected(tblSquadTable)
	if tblSquadTable && tblSquadTable.Units then
		for _, Squad in pairs(self.SellectedSquads) do
			for _, Unit in pairs(Squad.Units) do
				--print(Unit:FindIdealTarget(tblSquadTable.Units))
				Unit:Attack(Unit:FindIdealTarget(tblSquadTable.Units))
			end
		end
	end
end
concommand.Add("WAR_AttackSquad", function(ply, command, args)
	if !args[1] then return end
	local entTarget = ents.GetByIndex(tonumber(args[1]))
	if entTarget && entTarget:IsValid() && entTarget.SquadTable then
		ply:AttackWithSellected(entTarget.SquadTable)
	end
end)

concommand.Add("WAR_Dev_AddSquad", function(ply, command, args)
	ply:CreateSquad("melontrooper", ply:GetPos(), "shotgun")
end)


