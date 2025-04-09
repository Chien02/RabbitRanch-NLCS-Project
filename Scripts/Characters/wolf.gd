extends Animal

class_name Wolf

enum Role { HUNTER, GATE_KEEPER }

var role : int = -1
var charge_rate : float = 30.0
var charge_point : int = 0
var paths : Array[TilePath] = []
@export var max_charge_point : int = 3

signal Charged
signal Bited

func _ready() -> void:
	super()
	var animal_turnbase_actor = AnimalTurnBaseActor.new()
	turnbase_actor = animal_turnbase_actor
	turnbase_actor.EnterTurn.connect(_on_enter_turn)
	turnbase_actor.init(self)
	character_controller = CharacterController.new()
	if health:
		health.Died.connect(_on_health_die)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("mouse_left"):
		if !health:
			print("From Wolf: There not health inside wolf")
			return
		health.damage(15)
		print("From Wolf: current health is: ", health.current_health)
	foot_step_sign.change_text(str(charge_point))
	if !turnbase_actor.is_active: return
	

func _on_health_die():
	super()
	var lvl_manager : LevelManager = get_tree().get_first_node_in_group("LevelManager")
	lvl_manager.wolve_manager.wolve.erase(self)
	# Wait for animation
	await get_tree().create_timer(0.5).timeout
	queue_free()
