extends Special

class_name Breaking

@export var duration : float = 1.5
var flag : bool = false

func enter_state():
	print("Enter Breaking state")
	flag = false

func exit_state():
	print("Exit breaking state")

func update_state():
	if flag: return
	special_move()

func special_move():
	if character is Animal:
		if character.breakable_obstacle == null : return
		character.breakable_obstacle.destroy(duration)
		flag = true
		await get_tree().create_timer(duration).timeout
		finished_special()
		switch_to("idle")

func switch_to(new_state: String):
	SwitchState.emit(self, new_state)
