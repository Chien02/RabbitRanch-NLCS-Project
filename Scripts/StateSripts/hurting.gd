extends BaseState

class_name Hurting

@export var animation_duration : float = 0.65

func enter_state():
	print("From Hurting state: Entered")
	await get_tree().create_timer(animation_duration).timeout
	SwitchState.emit(self, "idle")

func exit_state():
	print("From Hurting state: Exited")

func update_state():
	print("From Hurting: Waiting for hurt animation finished")
