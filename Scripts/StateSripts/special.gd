extends BaseState

class_name Special

func enter_state(_value: Node2D = null):
	print("Enter special state")

func exit_state():
	print("Exit special state")

func update_state():
	await get_tree().create_timer(3).timeout
	special_move()
	SwitchState.emit(self, "idle")

func special_move():
	print("Special: Do special move")

func finished_special():
	if character is Animal:
		character.grid.rescan()
		character.breakable_obstacle = null
		character.is_finished_special = true
