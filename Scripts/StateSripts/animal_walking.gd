extends Walking

func physics_update():
	if !character: return
	if not character.character_controller.is_walking:
		SwitchState.emit(self, "idle")
		print("end turn ", character.name)
		
		# create a bit delay
		#await character.get_tree().create_timer(0.15).timeout
		character.turnbase_actor.emit_endturn("I finished walking")
