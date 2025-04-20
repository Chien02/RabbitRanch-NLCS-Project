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

func _ready() -> void:
	super()
	var animal_turnbase_actor = AnimalTurnBaseActor.new(self)
	turnbase_actor = animal_turnbase_actor
	turnbase_actor.EnterTurn.connect(_on_enter_turn)
	character_controller = CharacterController.new()

func _process(_delta: float) -> void:
	if !turnbase_actor.is_active: return

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

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is MainCharacter and self is not Wolf:
		var animals_manager : AnimalManager = get_tree().get_first_node_in_group("LevelManager").animals_manager
		turnbase_actor.emit_endturn("I caught by player")
		# Nên có animation chèn vào khúc này
		Disappear.emit(self)
		animals_manager.caught_animal(self, AnimalManager.Catcher.PLAYER)

func _on_health_die():
	super()
	var animals_manager : AnimalManager = get_tree().get_first_node_in_group("LevelManager").animals_manager
	Disappear.emit(self)
	# Đợi animation mất máu chạy xong
	await get_tree().create_timer(0.5).timeout
	animals_manager.caught_animal(self, AnimalManager.Catcher.WOLF)
