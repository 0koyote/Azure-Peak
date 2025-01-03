/datum/ai_controller/elite_orc
	movement_delay = ORC_MOVEMENT_SPEED

	ai_movement = /datum/ai_movement/basic_avoidance

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic()
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/simple_find_target/closest,
		/datum/ai_planning_subtree/melee_spacing,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/spearorc,
		
	)

	idle_behavior = /datum/idle_behavior/idle_random_walk
