extends CharacterBody2D

class_name MainCharacter

@export var speed : float = 10.0
@export var grid : Grid
var player_zone : Array[Vector2i] = []
var turnbase_actor : TurnBaseActor
var character_controller : CharacterController

func _ready() -> void:
	character_controller = CharacterController.new()
	turnbase_actor = TurnBaseActor.new()
	call_deferred("init_player_zone")

func _process(delta: float) -> void:
	if !turnbase_actor.is_active: return
	character_controller.movement(self, delta)

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
	
	print(player_zone)
	
	for zone in player_zone:
		grid.get_node("PlayerZone").set_cell(zone, 2, Vector2i(0, 0))
