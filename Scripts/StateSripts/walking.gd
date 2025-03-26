extends BaseState

class_name Walking

func enter_state():
	pass

func exit_state():
	pass

func update_state():
	pass

func physics_update():
	if !character: return
	check_caught_animal()
	
	if not character.character_controller.is_walking:
		SwitchState.emit(self, "idle")
		print("end turn ", character.name)
		
		if character is MainCharacter:
			character.init_player_zone()
			character.grid.rescan(character.player_zone)
		
		character.turnbase_actor.emit_endturn()

func check_caught_animal():
	if character is MainCharacter:
		var grid : Grid = character.grid
		var turnbase_manager : TurnBasedManager = get_tree().get_first_node_in_group("TurnBasedManager")
		var level_manager : LevelManager = get_tree().get_first_node_in_group("LevelManager")
		
		var current_local_pos = grid.local_to_map(character.position)
		var actors = turnbase_manager.actor
		for actor in actors:
			if actor is Animal and grid.local_to_map(actor.position) == current_local_pos:
				level_manager.caught_animal(actor.name)
