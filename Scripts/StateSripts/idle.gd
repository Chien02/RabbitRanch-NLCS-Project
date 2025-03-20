extends BaseState

class_name Idle

func enter_state():
	if character is MainCharacter:
		character.init_player_zone()
		character.grid.rescan(character.player_zone)
		for zone in character.player_zone:
			character.grid.get_node("Destination").set_cell(zone, 4, Vector2i(0, 0)) # debug

func exit_state():
	#print("Exit Idle State")
	pass

func update_state():
	if character is MainCharacter:
		if !character.turnbase_actor.is_active: return

func physics_update():
	if !character: return
	if !character.turnbase_actor.is_active: return
	if character.character_controller.is_walking:
		SwitchState.emit(self, "walking")
