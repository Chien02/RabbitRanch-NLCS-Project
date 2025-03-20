extends Idle

class_name IdleAnimal

var paths : Array[TilePath] = []
var flag : bool = false

func enter_state():
	flag = false

func exit_state():
	character.grid.clear_layer(4)

func update_state(): # Overriding
	if character is Animal:
		if !character.turnbase_actor.is_active or flag: return
		finding_path()
	
	if paths.is_empty():
		print("From idle animal: Could not find the paths")
	elif not flag:
		for path in paths:
			#print(path.position, " is_path: ", path.is_path)
			character.grid.get_child(4).set_cell(path.position, 3, Vector2i(0, 0))
		flag = true

func finding_path():
	if character is Animal:
		paths = character.astar.get_the_path()
