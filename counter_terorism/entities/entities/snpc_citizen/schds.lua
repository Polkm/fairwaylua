
	schdWander = ai_schedule.New("CT Wander")

schdWander:EngTask("TASK_GET_PATH_TO_RANDOM_NODE", 128)
schdWander:EngTask("TASK_WALK_PATH", 0)
schdWander:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)

	schdRun = ai_schedule.New("CT Run")

schdRun:EngTask("TASK_GET_PATH_TO_RANDOM_NODE", 128)
schdRun:EngTask("TASK_RUN_PATH_FLEE",100)
schdRun:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)

	schdWait = ai_schedule.New("CT Wait")

schdWait:EngTask("TASK_WAIT", 0.5)
schdWait:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)

	schdFleeShot = ai_schedule.New("CT Flee shot")
schdFleeShot:EngTask("TASK_GET_PATH_TO_RANDOM_NODE", 1000)
schdFleeShot:EngTask("TASK_RUN_PATH")
schdFleeShot:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)