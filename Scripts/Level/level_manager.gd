extends Node2D

class_name LevelManager

enum State {
	WIN, LOSS, NEUTRAL
}

@export_category("Level Number")
@export var current_level : int = 0

@export_category("Components")
@export var transition : Transition
@export var audio : UISoundFX
@export_category("LevelScore")
@export var suitable_score : int

@onready var grid : Grid = get_tree().get_first_node_in_group("Grid")
@onready var turnbase_manager : TurnBasedManager = get_tree().get_first_node_in_group("TurnBasedManager")

@onready var wolve_manager : Wolve_Manager = Wolve_Manager.new()
@onready var animals_manager : AnimalManager = AnimalManager.new()
@onready var is_loss : bool = false
var state : int = State.NEUTRAL

signal Paused
signal DropActorUIBar

func _ready() -> void:
	if get_tree().paused:
		get_tree().paused = !get_tree().paused
	GlobalProperties.current_level = current_level
	# Play transition when enter scene
	transition.trans_out()
	
	var eventUI = get_tree().get_first_node_in_group("GUI").get_children()
	
	animals_manager.call_deferred("init_animals", self)
	animals_manager.call_deferred("set_max_animal_score", suitable_score)
	
	wolve_manager.call_deferred("init_wolve", self)
	wolve_manager.call_deferred("set_role")
	wolve_manager.call_deferred("get_wolve")
	wolve_manager.WolfDisappeared.connect(_on_animal_disappear)
	
	# Add animals_manager to the scene
	add_child(animals_manager)

func _process(_delta: float) -> void:
	if get_tree().paused: return
	if Input.is_action_just_pressed("cancel"):
		var player : MainCharacter = get_tree().get_first_node_in_group("MainCharacter")
		if player.is_using_item: return
		audio.play_sound(UISoundFX.Sound.SELECT)
		emit_pause()

func emit_pause():
	Paused.emit()

func _on_pause_button_pressed() -> void:
	audio.play_sound(CharacterSoundFX.Sound.SELECT)
	emit_pause()

func _on_animal_disappear(animal_name: String):
	DropActorUIBar.emit(animal_name)
