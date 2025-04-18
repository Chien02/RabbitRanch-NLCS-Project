extends Node2D
# Main Menu

@export var animation_player : AnimationPlayer
@export var transition : Transition
var demo_scene_path : String = "res://Scenes/Prototype/sample_level.tscn"

func _ready() -> void:
	if !animation_player: return
	animation_player.play("default")


func _on_play_button_pressed() -> void:
	# Chuyển sang menu chọn màn chơi
	# nhưng hiện tại chỉ chuyển sang màn chơi
	transition.trans_in()


func _on_transition_scene_finished() -> void:
	get_tree().change_scene_to_file(demo_scene_path)
