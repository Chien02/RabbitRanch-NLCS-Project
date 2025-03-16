extends BaseState

class_name Walking

func enter_state():
	#print("Enter Walking State")
	pass

func exit_state():
	#print("Exit Walking State")
	pass

func update_state():
	pass

func physics_update():
	if !character: return
	if not character.character_controller.is_walking:
		SwitchState.emit(self, "idle")
		print("end turn ", character.name)
		character.turnbase_actor.emit_endturn()
