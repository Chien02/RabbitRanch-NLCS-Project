extends BaseState

class_name WolfWalking

func enter_state(_value: Node2D = null):
	print("From Wolf walking: Entered walking")

func exit_state():
	super()
	print("From Wolf walking: Exit walking")
	character.Walked.emit()

func update_state():
	if !character.character_controller.is_walking:
		print("From Wolf Walking: Walked, switch to idle")
		SwitchState.emit(self, "idle")
