local Player = FindMetaTable("Player")

concommand.Add("WAR_Sellect", function(ply, command, args)
	if !ply.Squads or !args[1] then return end
	local TargetEnt = ents.GetByIndex(tonumber(args[1]))
	if TargetEnt.SquadTable && TargetEnt.SquadTable.Owner == ply then
		TargetEnt:Sellect()
	end
end)

function Player:ClearSellection()
	if !self.SellectedSquads then return end
	for k, Squad in pairs(self.SellectedSquads) do
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
	for k, Squad in pairs(self.SellectedSquads) do
		TotalUnits = TotalUnits + #Squad.Units
		for l, Unit in pairs(Squad.Units) do
			SurfaceNeeded = math.sqrt(TotalUnits * (400 / ((TotalUnits / 200) + 1)))
			Unit.TargetPostion = vecPostion + Vector(math.random(-SurfaceNeeded, SurfaceNeeded), math.random(-SurfaceNeeded, SurfaceNeeded), 15)
			Unit:MoveToTarget()
			Unit:FaceTarget()
			--Unit:FireGun()
		end
	end
end
concommand.Add("WAR_MoveUnits", function(ply, command, args)
	ply:MoveSellectedSquad(Vector(tonumber(args[1]), tonumber(args[2]), tonumber(args[3])))
end)
