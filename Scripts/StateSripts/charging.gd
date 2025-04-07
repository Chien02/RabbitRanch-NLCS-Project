extends BaseState

class_name Charging

@export var animation_duration : float = 0.65

func enter_state():
	print("From Charging: Entered")
	await get_tree().create_timer(animation_duration).timeout
	SwitchState.emit(self, "idle")

func exit_state():
	print("From Charging: Exited")

func update_state():
	print("From Charging: Waiting for smiling animation")
