extends Node2D

class_name CustomAnimation

signal finished

func movement(_object, destination_pos: Vector2, duration: float):
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_property(_object, "position", destination_pos, duration)
	await get_tree().create_timer(duration / 2.0).timeout

func explode(_object, duration: float):
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(_object, "scale", Vector2(1.5, 1.5), duration)
	await get_tree().create_timer(duration).timeout
	finished.emit()

func scale_to(_object, _scale_to: Vector2, duration: float):
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_property(_object, "scale", _scale_to, duration)
	await get_tree().create_timer(duration).timeout

func pop_up(_object, new_scale: Vector2, duration: float):
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(_object, "scale", new_scale, duration)
	await get_tree().create_timer(duration).timeout
	finished.emit()

func disappear(_object, duration: float):
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(_object, "scale", Vector2.ZERO, duration)
	await get_tree().create_timer(duration).timeout

func jump_up(_object, up_pos: Vector2, duration: float):
	var last_position = _object.position
	var half_duration : float = duration / 2.0
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_property(_object, "position", _object.position + up_pos, half_duration)
	tween.tween_property(_object, "position", last_position, half_duration)
	await get_tree().create_timer(duration).timeout

func fade_up(_object, destination: Vector2, duration: float):
	if !_object.is_visible():
		_object.set_visible(true)
	var final_pos : Vector2 = _object.position + destination
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_property(_object, "position", final_pos, duration)
	tween.set_parallel().tween_property(_object, "modulate", Color(1, 1, 1, 0), duration)
	await tween.finished
	if !_object: return
	_object.set_visible(false)
	_object.position = _object.position - destination
	_object.modulate = Color(1, 1, 1, 1)

func change_color(_object, color: Color, scale_up: Vector2, duration: float):
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(_object, "scale", scale_up, duration)
	
	_object.set_color(color)

func zoom_in(camera: CameraController, duration: float):
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(camera, "zoom", camera.final_zoom, duration)
	tween.set_parallel().tween_property(camera, "position", camera.target.position, duration)
	
func loop_up_down(object, start_pos: Vector2, distance: float, duration: float):
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(object, "position", Vector2(start_pos.x, start_pos.y - distance), duration)
	tween.tween_property(object, "position", start_pos, duration)
	tween.set_loops()

func bounce(_object, start_scale: Vector2, scale_amount: Vector2, duration: float):
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(_object, "scale", start_scale + scale_amount, duration)
	tween.tween_property(_object, "scale", start_scale, duration)
	
