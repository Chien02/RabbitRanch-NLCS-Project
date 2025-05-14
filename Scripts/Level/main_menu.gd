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
	
	if transition:
		transition.fade_in()
	if !animation_player: return
	animation_player.play("default")
	

func _on_play_button_pressed() -> void:
	# Thực hiện audio khi nút được bấm
	audio.play_sound(CharacterSoundFX.Sound.CONFIRM)
	# Chuyển sang menu chọn màn chơi
	# nhưng hiện tại chỉ chuyển sang màn chơi
	transition.trans_in()
	get_tree().change_scene_to_packed(preload("res://Scenes/Levels/level_selection_scene.tscn"))
	#await get_tree().create_timer(1).timeout
	#ChangingLevel.change_scene_to(get_tree(), level_selection_scene_path)


func _on_setting_button_pressed() -> void:
	# Thực hiện audio khi nút được bấm
	audio.play_sound(CharacterSoundFX.Sound.SELECT)
	$CanvasLayer/Setting.visible = !$CanvasLayer/Setting.visible


func _on_credit_button_pressed() -> void:
	var credit = get_node("CanvasLayer/Credit")
	audio.play_sound(UISoundFX.Sound.SELECT)
	credit.visible = true
