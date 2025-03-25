extends BaseState

class_name Walking

func enter_state():
	print("Enter Walking State")
	pass

func exit_state():
	pass

func update_state():
	pass

func physics_update():
	if !character: return
	if not character.character_controller.is_walking:
		SwitchState.emit(self, "idle")
		print("end turn ", character.name)
		
		if character is MainCharacter:
			character.init_player_zone()
			character.grid.rescan(character.player_zone)
		
		character.turnbase_actor.emit_endturn()
