extends BaseState

class_name Idle

func enter_state(_value: Node2D = null):
	if character is MainCharacter:
		print("------From Idle: Main Character enter state")
		character.init_player_zone()
		character.grid.rescan(character.player_zone)

func exit_state():
	print("From Idle: Exit Idle State")
	pass

func update_state():
	if !character.turnbase_actor.is_active: return
	if character.is_stun:
		character.turnbase_actor.emit_endturn("I'm stunned")
		return

func physics_update():
	if !character: return
	if !character.turnbase_actor.is_active: return
	if character.is_stun: return
	check_caught_animal()
	if character.character_controller.is_walking:
		SwitchState.emit(self, "walking")

func check_caught_animal():
	if character is MainCharacter:
		var grid : Grid = character.grid
		var turnbase_manager : TurnBasedManager = get_tree().get_first_node_in_group("TurnBasedManager")
		var level_manager : LevelManager = get_tree().get_first_node_in_group("LevelManager")
		
		var current_local_pos = grid.local_to_map(character.position)
		var actors = turnbase_manager.actor
		for actor in actors:
			if actor == null:
				continue
			if actor is Animal and actor is not Wolf and grid.local_to_map(actor.position) == current_local_pos:
				level_manager.animals_manager.caught_animal(actor, AnimalManager.Catcher.PLAYER)
