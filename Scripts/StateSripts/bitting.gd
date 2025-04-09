extends BaseState

class_name Bitting

@export var animation_duration : float = 0.45

func enter_state():
	print("From Wolf Bitting: ", character.name, " enter walking state")
	character.Bited.emit()
	await character.get_tree().create_timer(animation_duration).timeout
	SwitchState.emit(self, "idle")
	# Mỗi lần cắn đều được cộng 1
	character.charge_point += 1
	character.turnbase_actor.emit_endturn()

func exit_state():
	print("From Wolf Bitting: ", character.name, " exit walking state")

func update_state():
	pass
