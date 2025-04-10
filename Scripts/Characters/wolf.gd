extends Animal

class_name Wolf

enum Role { HUNTER, GATE_KEEPER }

@export var max_charge_point : int = 4

var role : int = -1
var charge_rate : float = 30.0
var charge_point : int = 1
var paths : Array[TilePath] = []
var target : Character = null

signal Charged
signal Bited

func _ready() -> void:
	super()

func _process(_delta: float) -> void:
	if !turnbase_actor.is_active: return

func check_role():
	match role:
		Role.HUNTER: hunt_animal()
		Role.GATE_KEEPER: keep_gate()

func hunt_animal():
	pass

func keep_gate():
	pass

func _on_health_die():
	super()
	var lvl_manager : LevelManager = get_tree().get_first_node_in_group("LevelManager")
	lvl_manager.wolve_manager.wolve.erase(self)
	# Wait for animation
	await get_tree().create_timer(0.5).timeout
	queue_free()
