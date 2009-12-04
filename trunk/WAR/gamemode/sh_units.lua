local tblNewUnit = {}
tblNewUnit.Name = "melontrooper"
tblNewUnit.PrintName = "Melon Trooper"
tblNewUnit.Model = "models/props_junk/watermelon01.mdl"
tblNewUnit.Health = 20
tblNewUnit.SquadLimit = 10
tblNewUnit.MoveSpeed = 300
tblNewUnit.CircleSize = 35
RegisterUnit(tblNewUnit)

local tblNewGun = {}
tblNewGun.Name = "smg"
tblNewGun.PrintName = "SMG"
tblNewGun.Model = "models/weapons/w_smg1.mdl"
tblNewGun.Damage = 1
tblNewGun.FireSpeed = 0.2
tblNewGun.HoldPosition = {Position = Vector(3, 4, 8), Angles = Angle(0, 0, -90)}
tblNewGun.FireAnim = {}
tblNewGun.FireAnim[1] = {Position = Vector(2, 4, 8), Angles = Angle(5, 0, -90)}
tblNewGun.FireAnim[2] = {Position = Vector(3, 4, 8), Angles = Angle(0, 0, -90)}
RegisterEquiptment(tblNewGun)

local tblNewGun = {}
tblNewGun.Name = "shotgun"
tblNewGun.PrintName = "Shotgun"
tblNewGun.Model = "models/weapons/w_shotgun.mdl"
tblNewGun.Damage = 2
tblNewGun.NumShots = 5
tblNewGun.Spread = 0.1
tblNewGun.FireSpeed = 1
tblNewGun.HoldPosition = {Position = Vector(5, 2, 8), Angles = Angle(0, 180, -90)}
tblNewGun.FireAnim = {}
tblNewGun.FireAnim[1] = {Position = Vector(0, 2, 8), Angles = Angle(0, 180, -90)}
tblNewGun.FireAnim[2] = {Position = Vector(0, 2, 8), Angles = Angle(0, 180, -90)}
tblNewGun.FireAnim[3] = {Position = Vector(0, 2, 8), Angles = Angle(0, 180, -90)}
tblNewGun.FireAnim[4] = {Position = Vector(1, 2, 8), Angles = Angle(0, 180, -90)}
tblNewGun.FireAnim[5] = {Position = Vector(1, 2, 8), Angles = Angle(0, 180, -90)}
tblNewGun.FireAnim[6] = {Position = Vector(2, 2, 8), Angles = Angle(0, 180, -90)}
tblNewGun.FireAnim[7] = {Position = Vector(2, 2, 8), Angles = Angle(0, 180, -90)}
tblNewGun.FireAnim[8] = {Position = Vector(3, 2, 8), Angles = Angle(0, 180, -90)}
tblNewGun.FireAnim[9] = {Position = Vector(3, 2, 8), Angles = Angle(0, 180, -90)}
tblNewGun.FireAnim[10] = {Position = Vector(4, 2, 8), Angles = Angle(0, 180, -90)}
RegisterEquiptment(tblNewGun)