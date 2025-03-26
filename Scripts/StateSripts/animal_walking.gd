extends Walking

func physics_update():
	if !character: return
	if not character.character_controller.is_walking:
		SwitchState.emit(self, "idle")
		print("end turn ", character.name)
		
		character.turnbase_actor.emit_endturn()
