extends Control

class_name LevelEvent

@export var audio : UISoundFX
@export var animation_player : AnimationPlayer

@onready var level_manager : LevelManager = get_tree().get_first_node_in_group("LevelManager")
@onready var gui : DisplayUI = get_tree().get_first_node_in_group("GUI")

var level_selection_scene_path : String = "res://Scenes/Levels/level_selection_scene.tscn"
var main_menu_scene_path : String = "res://Scenes/Levels/main_menu.tscn"
var flag : bool = false

func pause():
	appear()

func appear():
	visible = !visible
	get_tree().paused = !get_tree().paused
	# Blur shader
	gui.colorect.material["shader_parameter/blur_amount"] = 2.0 if visible == true else 0.0

func _on_continue_pressed() -> void:
	audio.play_sound(CharacterSoundFX.Sound.CANCEL)
	#await get_tree().create_timer(0.15).timeout
	appear()

#func _on_next_level_pressed() -> void:
	#print("Go to next level scene")
	#audio.play_sound(CharacterSoundFX.Sound.SELECT)
	#await get_tree().create_timer(0.35).timeout

func _on_restart_pressed() -> void:
	audio.play_sound(CharacterSoundFX.Sound.SELECT)
	get_tree().reload_current_scene()

func _on_main_menu_pressed() -> void:
	audio.play_sound(CharacterSoundFX.Sound.CANCEL)
	if level_manager:
		level_manager.transition.trans_in()
	else:
		print("From ", name, ": Use level_selection")
		var level_selection : LevelSelection = get_tree().get_first_node_in_group("LevelSelection")
		level_selection.transition.trans_in()
	await get_tree().create_timer(1).timeout
	# Don't need to save
	print("Go to main menu")
	ChangingLevel.change_scene_to(get_tree(), main_menu_scene_path)

func _on_level_selection_pressed() -> void:
	audio.play_sound(CharacterSoundFX.Sound.SELECT)
	if level_manager:
		level_manager.transition.trans_in()
	else:
		print("From ", name, ": Use level_selection")
		var level_selection : LevelSelection = get_tree().get_first_node_in_group("LevelSelection")
		level_selection.transition.trans_in()
	await get_tree().create_timer(1).timeout
	print("Go to level selecion")
	ChangingLevel.change_scene_to(get_tree(), level_selection_scene_path)
