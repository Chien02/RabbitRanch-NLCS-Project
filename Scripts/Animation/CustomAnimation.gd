extends Node2D

class_name CustomAnimation

func movement(_object, destination_pos: Vector2, duration: float):
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_property(_object, "position", destination_pos, duration)
