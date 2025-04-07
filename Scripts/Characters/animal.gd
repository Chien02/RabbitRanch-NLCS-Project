extends Character

class_name Animal
@export_category("Properties")
@export var speed : float = 10.0
@export_enum("diagonal", "not_diagonal") var mode : String = "not_diagonal"
@export_enum("ignore", "not_ignore") var option : String = "ignore"
@export var breakable_obstacle : Obstacle = null
var is_finished_special : bool = false

@export_category("Components")
@export var grid : Grid
@export var astar : Astar

var character_controller : CharacterController
var facing_direction : Vector2 = Vector2(0, 1)

func _ready() -> void:
	super()
	var animal_turnbase_actor = AnimalTurnBaseActor.new()
	turnbase_actor = animal_turnbase_actor
	turnbase_actor.EnterTurn.connect(_on_enter_turn)
	turnbase_actor.init(self)
	character_controller = CharacterController.new()
	if !health: return
	health.Died.connect(_on_health_die)
	health.Hurted.connect(_on_health_hurt)

func _process(_delta: float) -> void:
	if !turnbase_actor.is_active: return
	if Input.is_action_just_pressed("mouse_left"):
		if !health:
			print("From Wolf: There not health inside wolf")
			return
		health.damage(15)
		print("From Wolf: current health is: ", health.current_health)

func is_mode_diagonal() -> bool:
	return mode=="diagonal"

func is_option_ignore() -> bool:
	return option=="ignore"

func change_option(new_option: String):
	if (new_option == "ignore" or new_option == "not_ignore"):
		option = new_option

func change_mode(new_mode: String):
	if (new_mode == "diagonal" or new_mode == "not_diagonal"):
		mode = new_mode

func _on_health_hurt():
	print("From ", name, ": Ouchhh")
