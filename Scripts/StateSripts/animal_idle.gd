extends Idle

var paths : Array[TilePath] = []
var found_path_flag : bool = false

func enter_state(): # Overriding
	found_path_flag = false

func exit_state():
	var destination_layer : int = 4
	character.grid.clear_layer(destination_layer)

func update_state(): # Overriding
	if character:
		if not character.turnbase_actor.is_active: return
		if found_path_flag: return
		finding_path()

func finding_path():
	if character:
		paths = character.astar.get_the_path()
		
		if paths.is_empty():
			print("From idle animal: Could not find the paths")
		else:
			print("----From idle animal:")
			for path in paths:
				print(path.position, " is_path: ", path.is_path)
				character.grid.get_child(4).set_cell(path.position, 3, Vector2i(0, 0))
		found_path_flag = true
