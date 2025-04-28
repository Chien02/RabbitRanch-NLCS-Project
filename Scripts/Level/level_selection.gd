extends Node2D

class_name LevelSelection

@export var audio : UISoundFX
@export var transition : Transition
@export var level_point_manager : SelectPointManager
@export var character : CharacterSelectLevel

func _ready() -> void:
	if get_tree().paused:
		get_tree().paused = false
	# Load position at the current_level
	load_position()
	transition.trans_out()
	CustomTween.zoom_in($Camera2D, 1)
	
	# Connect with gamepad
	# Nếu connect với gamepad thì chuyển sang giao diện nút bấm của game pad
	Input.joy_connection_changed.connect(change_level_point_input)

func load_position():
	if GlobalProperties.current_level == -1: return
	var curr_level : int = GlobalProperties.current_level
	print("From LevelSelection: global current_level is ", curr_level)
	
	var curr_node = level_point_manager.level_points.get(curr_level)
	if curr_node:
		print("From LevelSelection: Found curr node at: ", curr_node.name)
		character.position = curr_node.position + Vector2(0, 5)

func change_level_point_input(device: int, connected: bool):
	if connected:
		print("From LevelSelection: Connected with joypad")
		for level_point in level_point_manager.level_points:
			level_point.change_input_texture(connected)
	else:
		print("From LevelSelection: Connected with joypad")
		for level_point in level_point_manager.level_points:
			level_point.change_input_texture(connected)
