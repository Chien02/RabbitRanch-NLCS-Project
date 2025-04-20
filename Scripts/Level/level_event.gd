extends Control

class_name LevelEvent

@export var audio : UISoundFX
@onready var level_manager : LevelManager = get_tree().get_first_node_in_group("LevelManager")
@onready var gui : DisplayUI = get_tree().get_first_node_in_group("GUI")

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
	
	if visible == true:
		gui.colorect.material["shader_parameter/blur_amount"] = 2.0
	else:
		gui.colorect.material["shader_parameter/blur_amount"] = 0.0

func _on_continue_pressed() -> void:
	audio.play_sound(CharacterSoundFX.Sound.SELECT)
	appear()

func _on_next_level_pressed() -> void:
	print("Go to next level scene")
	audio.play_sound(CharacterSoundFX.Sound.SELECT)
	pass

func _on_restart_pressed() -> void:
	audio.play_sound(CharacterSoundFX.Sound.SELECT)
	get_tree().paused = !get_tree().paused
	get_tree().reload_current_scene()

func _on_main_menu_pressed() -> void:
	audio.play_sound(CharacterSoundFX.Sound.SELECT)
	print("Go to main menu")
	pass

func _on_level_selection_pressed() -> void:
	audio.play_sound(CharacterSoundFX.Sound.SELECT)
	print("Go to level selecion")
	pass
