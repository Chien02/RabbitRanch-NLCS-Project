extends Node2D

class_name CustomAnimation

signal finished

func movement(_object, destination_pos: Vector2, duration: float):
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_property(_object, "position", destination_pos, duration)
	finished.emit()

func explode(_object, duration: float):
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(_object, "scale", Vector2(1.5, 1.5), duration)
	await get_tree().create_timer(duration).timeout
	finished.emit()

func scale_to(_object, _scale_to: Vector2, duration: float):
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_property(_object, "scale", _scale_to, duration)
	await get_tree().create_timer(duration).timeout
	finished.emit()

func pop_up(_object, new_scale: Vector2, duration: float):
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(_object, "scale", new_scale, duration)
	await get_tree().create_timer(duration).timeout
	finished.emit()

func disappear(_object, duration: float):
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(_object, "scale", Vector2.ZERO, duration)
	await get_tree().create_timer(duration).timeout
