local tblNewClass = {}
tblNewClass.Name = "melontrooper"
tblNewClass.PrintName = "Melon Trooper"
tblNewClass.Model = "models/props_junk/watermelon01.mdl"
tblNewClass.SquadEquiptmentSlots = {}
tblNewClass.SquadEquiptmentSlots["equiptment"] = 2
tblNewClass.UnitEquiptmentSlots = {}
tblNewClass.UnitEquiptmentSlots["hand"] = 2
tblNewClass.DefaultEquiptment = {}
tblNewClass.DefaultEquiptment["smg"] = 1
tblNewClass.Health = 20
tblNewClass.SquadLimit = 4
tblNewClass.MoveSpeed = 50
tblNewClass.CircleSize = 35
RegisterClass(tblNewClass)


local tblNewEquiptment = {}
tblNewEquiptment.Name = "grenade"
tblNewEquiptment.PrintName = "Grenade"
tblNewEquiptment.Slots = {}
tblNewEquiptment.Slots["equiptment"] = 1
tblNewEquiptment.Model = "models/weapons/w_smg1.mdl"
tblNewEquiptment.Sound = ""
function tblNewEquiptment.Use(entUser)
	print("used")
end


local tblNewGun = {}
tblNewGun.Name = "smg"
tblNewGun.PrintName = "SMG"
tblNewGun.Slots = {}
tblNewGun.Slots["hand"] = 1
tblNewGun.Model = "models/weapons/w_smg1.mdl"
tblNewGun.Sound = "weapons/smg1/npc_smg1_fire1.wav"
tblNewGun.Damage = 1
tblNewGun.FireSpeed = 0.2
tblNewGun.HoldPosition = {Position = Vector(3, 4, 8), Angles = Angle(0, 0, -90)}
tblNewGun.FireAnim = {}
tblNewGun.FireAnim[1] = {Position = Vector(1, 4, 8), Angles = Angle(5, 0, -90)}
RegisterEquiptment(tblNewGun)

local tblNewGun = {}
tblNewGun.Name = "shotgun"
tblNewGun.PrintName = "Shotgun"
tblNewGun.Slots = {}
tblNewGun.Slots["hand"] = 2
tblNewGun.Model = "models/weapons/w_shotgun.mdl"
tblNewGun.Sound = "weapons/shotgun/shotgun_fire6.wav"
tblNewGun.Damage = 3
tblNewGun.NumShots = 5
tblNewGun.Spread = 0.2
tblNewGun.FireSpeed = 2
tblNewGun.HoldPosition = {Position = Vector(5, 2, 8), Angles = Angle(0, 180, -90)}
tblNewGun.FireAnim = {}
tblNewGun.FireAnim[1] = {Position = Vector(3, 2, 8), Angles = Angle(0, 180, -90)}
RegisterEquiptment(tblNewGun)