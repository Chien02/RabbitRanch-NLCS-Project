extends Control

class_name LevelEvent

@onready var level_manager : LevelManager = get_tree().get_first_node_in_group("LevelManager")

func _ready() -> void:
	get_tree().paused = false
	visible = false
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func pause():
	appear()

func win():
	appear()

func loss():
	appear()

func appear():
	visible = !visible
	get_tree().paused = !get_tree().paused

func _on_continue_pressed() -> void:
	print("Continue")
	appear()

func _on_next_level_pressed() -> void:
	print("Go to next level scene")
	pass

func _on_restart_pressed() -> void:
	get_tree().paused = !get_tree().paused
	get_tree().reload_current_scene()

func _on_main_menu_pressed() -> void:
	print("Go to main menu")
	pass

func _on_level_selection_pressed() -> void:
	print("Go to level selecion")
	pass
