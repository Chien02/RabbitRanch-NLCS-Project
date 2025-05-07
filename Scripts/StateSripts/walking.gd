extends BaseState

class_name Walking

func enter_state(_value: Node2D = null):
	print("From Walking: ", character.name, " enter walking state")

func exit_state():
	print("From Walking: ", character.name, " update local position: ", character.local_position)
	print("From Walking: ", character.name, " exit walking state")

func update_state():
	pass

func physics_update():
	if !character: return
	
	# Both main character and animal
	if not character.character_controller.is_walking:
		SwitchState.emit(self, "idle")
		
		if character is MainCharacter:
			character.init_player_zone()
			character.grid.rescan(character.player_zone)
		
		character.turnbase_actor.emit_endturn("I finished walking")
