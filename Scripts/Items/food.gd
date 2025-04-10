extends Item

class_name Food

var is_selecting : bool = false
var throwable_slot : Array[Vector2i] = []
var debug_layer : int = 4

func _ready() -> void:
	is_selecting = false

func _process(_delta: float) -> void:
	if !character: return
	if character.character_controller.is_walking and is_selecting:
		is_selecting = false

func _input(event: InputEvent) -> void:
	if !is_selecting and character != null:
		character.is_look_at_mouse = false
		return
	if event is InputEventMouseButton and event.is_pressed():
		var mouse_pos = get_global_mouse_position()
		var local_mouse_pos = grid.local_to_map(mouse_pos)
		print("From Food: mouse position is ", local_mouse_pos)
		
		if !throwable_slot.has(local_mouse_pos): return
		print("From Food: Selected position is ", local_mouse_pos)
		# Let character stop look at the mouse
		character.facing_direction = character.get_local_mouse_position()
		# Turn off these flags
		character.is_look_at_mouse = false
		is_selecting = false
		# Do the thing
		var localize_position = grid.map_to_local(local_mouse_pos)
		throw_item(localize_position)
		grid.clear_layer(debug_layer)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is MainCharacter:
		print("From Rice: collide with Main Character")
		var new_item = Food.new()
		new_item.init(grid, body, resource)
		body.inventory.add_item(new_item)
	elif body is Animal:
		print("From Rice: collide with Animal")
	disappear()

func active():
	if is_selecting: return
	is_selecting = true # If player move or press key ESC then cancel
	character.is_look_at_mouse = true
	print("From Food: Activate Food")
	print("From Food: Active is_selecting: ", is_selecting)
#	// Generate zone that player can throw item
	throwable_zone()
#	Let character look at the mouse and play look at animation
	set_process(is_selecting)

func throwable_zone():
	print("From Food: Generate throwable zone")
	var min_pos = grid.local_to_map(character.position) - Vector2i(2, 2)
	var max_pos = grid.local_to_map(character.position) + Vector2i(3, 3)
	for x in range(min_pos.x, max_pos.x):
		for y in range(min_pos.y, max_pos.y):
			if grid.is_within_grid(Vector2i(x, y)) and grid.is_path(Vector2i(x, y)):
				throwable_slot.append(Vector2i(x, y))
				# for debug:
				grid.get_node("Destination").set_cell(Vector2i(x, y), debug_layer, Vector2i(0, 0))
			elif !grid.is_path(Vector2i(x, y)):
				var obstacle = grid.obstacles_management.get_obstacle_at(Vector2i(x, y))
				if obstacle != null and !obstacle.Destroyed.is_connected(_on_obstacle_destroyed):
					obstacle.Destroyed.connect(_on_obstacle_destroyed)

func _on_obstacle_destroyed(local_pos: Vector2i):
	print("From Obstacle: Connected with obstacle, rescan throwable zone")
	throwable_slot.append(local_pos)

func throw_item(pos: Vector2):
	print("From Food: thrown item in ", pos)
	finish_active()
	# Create new instance of this item
	character.inventory.drop_item(self, pos)
