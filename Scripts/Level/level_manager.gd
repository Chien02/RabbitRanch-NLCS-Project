extends Node2D

class_name LevelManager

@export_category("Level Number")
@export var current_level : int = 0

@export_category("Components")
@export var transition : Transition
@export var audio : UISoundFX

@onready var grid : Grid = get_tree().get_first_node_in_group("Grid")
@onready var turnbase_manager : TurnBasedManager = get_tree().get_first_node_in_group("TurnBasedManager")

@onready var wolve_manager : Wolve_Manager = Wolve_Manager.new()
@onready var animals_manager : AnimalManager = AnimalManager.new()
@onready var is_loss : bool = false
var events : Array[LevelEvent] = []

signal Win
signal Loss
signal Paused
signal DropActorUIBar

func _ready() -> void:
	GlobalProperties.current_level = current_level
	# Play transition when enter scene
	transition.trans_out()
	
	var eventUI = get_tree().get_first_node_in_group("GUI").get_children()
	for event in eventUI:
		if event is LevelEvent:
			events.append(event)
	
	wolve_manager.call_deferred("init_wolve", self)
	wolve_manager.call_deferred("set_role")
	wolve_manager.call_deferred("get_wolve")
	
	animals_manager.call_deferred("init_animals", self)
	wolve_manager.WolfDisappeared.connect(_on_animal_disappear)
	
	# add animals_manager to the scene
	add_child(animals_manager)

func _process(_delta: float) -> void:
	animals_manager.check_animal_on_field(self)

func emit_pause():
	Paused.emit()

func _on_pause_button_pressed() -> void:
	audio.play_sound(CharacterSoundFX.Sound.SELECT)
	emit_pause()

func _on_animal_disappear(animal_name: String):
	DropActorUIBar.emit(animal_name)
