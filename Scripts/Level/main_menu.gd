extends Node2D
# Main Menu

@export var animation_player : AnimationPlayer
@export var transition : Transition
@export var audio : UISoundFX

var demo_scene_path : String = "res://Scenes/Prototype/sample_level.tscn"
var level_selection_scene_path : String = "res://Scenes/Levels/level_selection_scene.tscn"

func _ready() -> void:
	if get_tree().paused:
		get_tree().paused = false
		
	if !animation_player: return
	animation_player.play("default")

func _on_play_button_pressed() -> void:
	# Thực hiện audio khi nút được bấm
	audio.play_sound(CharacterSoundFX.Sound.CONFIRM)
	# Chuyển sang menu chọn màn chơi
	# nhưng hiện tại chỉ chuyển sang màn chơi
	transition.trans_in()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file(level_selection_scene_path)


func _on_transition_scene_finished() -> void:
	get_tree().change_scene_to_file(demo_scene_path)


func _on_setting_button_pressed() -> void:
	# Thực hiện audio khi nút được bấm
	audio.play_sound(CharacterSoundFX.Sound.SELECT)
	$CanvasLayer/Setting.visible = !$CanvasLayer/Setting.visible
