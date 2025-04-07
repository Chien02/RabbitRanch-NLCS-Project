extends Node2D

class_name LevelManager

@onready var grid : Grid = get_tree().get_first_node_in_group("Grid")
@onready var turnbase_manager : TurnBasedManager = get_tree().get_first_node_in_group("TurnBasedManager")
@onready var is_loss : bool = false
var animals = {}
var animals_caught : int = 0
var events : Array[LevelEvent] = []

signal win
signal loss
signal paused

func _ready() -> void:
	call_deferred("get_animal")
	var eventUI = get_tree().get_first_node_in_group("GUI").get_children()
	for event in eventUI:
		if event is LevelEvent:
			events.append(event)

func _process(_delta: float) -> void:
	check_lose_event()

func get_animal():
	var actors = turnbase_manager.actor
	for actor in actors:
		if actor is Animal and !actor.is_in_group("Wolf"):
			animals[actor.name] = {
				"is_caught": false
			}
	print("From level Manager: animal number is: ", animals.size())

func caught_animal(animal_name: String):
	if animals.has(animal_name):
		if !animals[animal_name]["is_caught"]:
			animals[animal_name] = {
				"is_caught": true
			}
			animals_caught += 1
	
	if animals_caught == animals.size():
		win.emit()
		reset()

func check_lose_event():
	if is_loss: return
	if turnbase_manager.current_actor is Animal:
		if grid.local_to_map(turnbase_manager.current_actor.position) == grid.destination:
			loss.emit()
			is_loss = true

func emit_pause():
	paused.emit()

func reset():
	animals_caught = 0

func _on_pause_button_pressed() -> void:
	emit_pause()
