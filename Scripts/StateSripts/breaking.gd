extends Special

class_name Breaking

@export var duration : float = 1
var flag : bool = false

func enter_state():
	flag = false
	print("From Breaking: Enter breaking state")

func exit_state():
	print("From Breaking: Exit breaking state")

func update_state():
	if flag: return
	if character is Animal:
		if character.breakable_obstacle == null : return
		flag = true
		
		var next_pos : Vector2i = character.breakable_obstacle.local_position
		print("From breaking: Destroy the obstacle")
		character.breakable_obstacle.destroy(duration)
		
		await get_tree().create_timer(duration).timeout
		print("From Breaking: Rescan the grid")
		character.grid.rescan()
		finished_special()
		switch_to_walking(next_pos)

func switch_to_walking(next_pos: Vector2i):
	var next_global_pos = character.grid.map_to_local(next_pos)
	character.character_controller.move_to(character, next_global_pos, duration)
	SwitchState.emit(self, "walking")
