extends Character

class_name MainCharacter

@export var speed : float = 10.0
var player_zone : Array[Vector2i] = []
var facing_direction : Vector2 = Vector2(0, 1)
var is_look_at_mouse: bool = false
var tooling : bool = false
var is_using_item : bool = false

# Component variables
@export var grid : Grid
@export var inventory : Inventory

var push : PushComponent
var character_controller : CharacterController

# For simulation demo for main_item in inventory
var main_item_input: String = "tool"

func _ready() -> void:
	super()
	turnbase_actor = TurnBaseActor.new(self)
	turnbase_actor.EnterTurn.connect(_on_enter_turn)
	character_controller = CharacterController.new()
	push = PushComponent.new()
	push.init_variable(self, grid)
	call_deferred("init_player_zone")
	if !inventory: return
	inventory.UsingItem.connect(_on_inventory_using_item)
	inventory.FinishedUsingItem.connect(_on_inventory_finished_using_item)

func _process(delta: float) -> void:
	if !turnbase_actor.is_active: return
	character_controller.movement(self, delta)
	set_collider_position()
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
	
func set_collider_position():
	if area == null: return
	var collider : CollisionShape2D= area.get_child(0)
	collider.global_position = position + facing_direction * grid.tile_size


func _on_area_2d_area_entered(_area: Area2D) -> void:
	pass # Replace with function body.


func _on_area_2d_body_entered(_body: Node2D) -> void:
	pass # Replace with function body.

func _on_health_die():
	super()
	
	# Phát đi tín hiệu thua
	var level_manager : LevelManager = get_tree().get_first_node_in_group("LevelManager")
	await get_tree().create_timer(0.8).timeout
	level_manager.Loss.emit()

func _on_inventory_using_item(item_name: String):
	print("From MainCharacter: I'm using ", item_name)
	is_using_item = true

func _on_inventory_finished_using_item():
	is_using_item = false
