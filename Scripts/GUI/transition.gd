extends Node2D

class_name Transition

@export var sprite : Sprite2D
@export var animation_player : AnimationPlayer

signal Finished

func trans_in():
	animation_player.play("trans_in")

func trans_out():
	animation_player.play("trans_out")

func fade_in():
	animation_player.play("Fade_in")

func fade_out():
	animation_player.play("fade_out")

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	Finished.emit()
