extends BaseState

class_name Idle

func enter_state():
	if character is MainCharacter:
		print("------From Idle: Main Character enter state")
		character.init_player_zone()
		character.grid.rescan(character.player_zone)
		print("From Idle: rescan the grid")
		for zone in character.player_zone:
			character.grid.get_node("Destination").set_cell(zone, 4, Vector2i(0, 0)) # debug

func exit_state():
	print("From Idle: Exit Idle State")
	pass

func update_state():
	if character is MainCharacter:
		if !character.turnbase_actor.is_active: return
		check_for_tool_input()

func physics_update():
	if !character: return
	if !character.turnbase_actor.is_active: return
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
			if actor is Animal and grid.local_to_map(actor.position) == current_local_pos:
				level_manager.caught_animal(actor.name)

func check_for_tool_input():
	if character is MainCharacter:
		if Input.is_action_just_pressed(character.main_item_input):
			SwitchState.emit(self, "tooling")
	return
