local Player = FindMetaTable("Player")
local intDefaultPlayerSpeed = 340

if SERVER then
	function Player:AddMoveSpeed(intAmount)
		self.MoveSpeed = self.MoveSpeed or intDefaultPlayerSpeed
		self:SetMoveSpeed(self.MoveSpeed + intAmount)
	end
	function Player:SetMoveSpeed(intAmount)
		self.MoveSpeed = self.MoveSpeed or intDefaultPlayerSpeed
		self.MoveSpeed = math.Clamp(intAmount or self.MoveSpeed, 0, 1000)
		self:SetWalkSpeed(math.Clamp(self.MoveSpeed, 0, 1000))
		self:SetRunSpeed(math.Clamp(self.MoveSpeed, 0, 1000))
		print(self.MoveSpeed)
	end
	function Player:GetMoveSpeed()
		self.MoveSpeed = self.MoveSpeed or intDefaultPlayerSpeed
		return self.MoveSpeed
	end
	
	hook.Add("PlayerSpawn", "PlayerSpawn_Movement", function(ply)
		ply:SetMoveSpeed()
		if ply.MoveSpeedDebt && ply.MoveSpeedDebt != 0 then
			ply:AddMoveSpeed(ply.MoveSpeedDebt)
		end
	end)
end