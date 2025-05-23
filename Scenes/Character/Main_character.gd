extends Character

class_name MainCharacter

@export var speed : float = 10.0
var player_zone : Array[Vector2i] = []
var is_look_at_mouse: bool = false
var tooling : bool = false
var is_using_item : bool = false

# Components
@export var inventory : Inventory
@export var hitbox : Area2D
@export var hitbox_collider : CollisionShape2D
var push : PushComponent

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
#
func init_player_zone():
	player_zone.clear()
	grid.clear_layer(Grid.PLAYER_ZONE)
	
	var local_pos = grid.local_to_map(position)
	var temp = grid.get_surrounding_cells(local_pos)
	for cell in temp:
		if grid.is_within_grid(cell):
			player_zone.append(cell)
	
	local_pos = grid.local_to_map(position)
	player_zone.append(local_pos)

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
	var tile_size : int = 10
	collider.global_position = position + facing_direction * tile_size

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


func _on_hitbox_body_entered(_body: Node2D) -> void:
	pass # Replace with function body.
