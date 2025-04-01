extends Character

class_name MainCharacter

@export var speed : float = 10.0
var player_zone : Array[Vector2i] = []
var facing_direction : Vector2 = Vector2(0, 1)
var is_look_at_mouse: bool = false
var tooling : bool = false

# Component variables
@export var grid : Grid
@export var inventory : Inventory
var push : PushComponent
var character_controller : CharacterController

# For simulation demo for main_item in inventory
var main_item_input: String = "tool"

func _ready() -> void:
	super()
	character_controller = CharacterController.new()
	push = PushComponent.new()
	push.init_variable(self, grid)
	call_deferred("init_player_zone")

func _process(delta: float) -> void:
	if !turnbase_actor.is_active: return
	character_controller.movement(self, delta)
	# Debugging
	debug_canwalk()

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		push.pushing_check()

func init_player_zone():
	player_zone.clear()
	grid.clear_layer(6)
	
	var local_pos = grid.local_to_map(position)
	var temp = grid.get_surrounding_cells(local_pos)
	for cell in temp:
		if grid.is_within_grid(cell):
			player_zone.append(cell)
	
	local_pos = grid.local_to_map(position)
	player_zone.append(local_pos)
	
	for zone in player_zone:
		grid.get_node("PlayerZone").set_cell(zone, 2, Vector2i(0, 0))

func is_tooling():
	return tooling

func debug_canwalk():
	#debug
	var mouse_position = grid.local_to_map(get_global_mouse_position())
	if is_look_at_mouse:
		$Control/Label.text = "Click on white border field to throw item"
	else:
		if mouse_position == grid.local_to_map(position):
			$Control/Label.text = "can_walk: " + str(character_controller.can_walk)
		else:
			$Control/Label.text = ""
	
