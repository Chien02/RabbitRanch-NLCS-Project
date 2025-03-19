extends BaseState

class_name Idle

func enter_state():
	#print("Enter Idle State")
	pass

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
