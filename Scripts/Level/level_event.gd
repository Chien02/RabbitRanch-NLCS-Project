extends Control

class_name LevelEvent

@export var audio : UISoundFX
@export var animation_player : AnimationPlayer

@onready var level_manager : LevelManager = get_tree().get_first_node_in_group("LevelManager")
@onready var gui : DisplayUI = get_tree().get_first_node_in_group("GUI")

var level_selection_scene_path : String = "res://Scenes/Levels/level_selection_scene.tscn"
var main_menu_scene_path : String = "res://Scenes/Levels/main_menu.tscn"

func _ready() -> void:
	get_tree().paused = false
	visible = false
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func pause():
	appear()

func win():
	GlobalProperties.complete_level(level_manager.current_level)
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
	await get_tree().create_timer(0.5).timeout
	get_tree().paused = !get_tree().paused
	get_tree().reload_current_scene()

func _on_main_menu_pressed() -> void:
	audio.play_sound(CharacterSoundFX.Sound.SELECT)
	# Don't need to save
	print("Go to main menu")
	get_tree().change_scene_to_file(main_menu_scene_path)

func _on_level_selection_pressed() -> void:
	audio.play_sound(CharacterSoundFX.Sound.SELECT)
	print("Go to level selecion")
	get_tree().change_scene_to_file(level_selection_scene_path)
