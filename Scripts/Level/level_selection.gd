extends Node2D

class_name LevelSelection

@export var audio : UISoundFX
@export var transition : Transition
@export var level_point_manager : SelectPointManager
@export var character : CharacterSelectLevel

func _ready() -> void:
	if get_tree().paused:
		get_tree().paused = false
	transition.trans_out()
	
	# Load position at the current_level
	load_position()

func load_position():
	if GlobalProperties.current_level == -1: return
	var curr_level : int = GlobalProperties.current_level
	print("From LevelSelection: global current_level is ", curr_level)
	
	var curr_node = level_point_manager.level_points.get(curr_level)
	if curr_node:
		print("From LevelSelection: Found curr node at: ", curr_node.name)
	character.position = curr_node.position
