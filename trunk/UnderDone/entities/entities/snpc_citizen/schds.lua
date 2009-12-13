schdShoot = ai_schedule.New("UD Shoot")

schdShoot:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
schdShoot:EngTask("TASK_STOP_MOVING", 0)
schdShoot:EngTask("TASK_FACE_ENEMY", 0)
schdShoot:EngTask("TASK_ANNOUNCE_ATTACK", 0)
schdShoot:EngTask("TASK_WAIT_RANDOM", 1)
schdShoot:EngTask("TASK_ANNOUNCE_ATTACK", 0)
schdShoot:EngTask("TASK_RANGE_ATTACK1", 0)
schdShoot:EngTask("TASK_RELOAD", 0)

schdMelee = ai_schedule.New("UD Melee")

schdMelee:EngTask("TASK_STOP_MOVING", 0)
schdMelee:EngTask("TASK_FACE_ENEMY", 0)
schdMelee:EngTask("TASK_ANNOUNCE_ATTACK", 0)
schdMelee:EngTask("TASK_MELEE_ATTACK1", 0)


schdWander = ai_schedule.New("UD Wander")

schdWander:EngTask("TASK_GET_PATH_TO_RANDOM_NODE", 128)
schdWander:EngTask("TASK_WALK_PATH", 0)
schdWander:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)


schdDie = ai_schedule.New("AIFighter Die")

schdDie:EngTask("TASK_FALL_TO_GROUND", 128)
schdDie:EngTask("TASK_DIE", 0)


schdRespondToBeacon = ai_schedule.New("UD RespondToBeacon")

schdRespondToBeacon:EngTask("TASK_GET_PATH_TO_ENEMY", 128)
schdRespondToBeacon:EngTask("TASK_WALK_PATH", 0)
schdRespondToBeacon:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)

schdRespondToBeaconRun = ai_schedule.New("UD RespondToBeacon")

schdRespondToBeaconRun:EngTask("TASK_GET_PATH_TO_ENEMY", 128)
schdRespondToBeaconRun:EngTask("TASK_RUN_PATH", 0)
schdRespondToBeaconRun:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)


schdWalkToEnemy = ai_schedule.New("UD WalkToEnemy")

schdWalkToEnemy:EngTask("TASK_GET_PATH_TO_ENEMY", 128)
schdWalkToEnemy:EngTask("TASK_WALK_PATH", 0)


schdRunToEnemy = ai_schedule.New("UD WalkToEnemy")

schdRunToEnemy:EngTask("TASK_GET_PATH_TO_ENEMY", 128)
schdRunToEnemy:EngTask("TASK_RUN_PATH", 0)