extends BaseState

class_name Charging

@export var animation_duration : float = 0.65

func enter_state():
	print("From Wolf Charging: Entered")
	character.Charged.emit()
	await get_tree().create_timer(animation_duration).timeout
	character.charge_point += 1
	if character.charge_point >= character.max_charge_point:
		character.charge_point = character.max_charge_point
	print("From Wofl Charging: Charge point: ", character.charge_point)
	SwitchState.emit(self, "idle")
	character.turnbase_actor.emit_endturn()

func exit_state():
	print("From Wolf Charging: Exited")

func update_state():
	pass
