extends BaseState

class_name Special

func enter_state():
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
		character.grid.change_tile_property(character.breakable_obstacle.local_position)
		character.breakable_obstacle = null
		character.is_finished_special = true
