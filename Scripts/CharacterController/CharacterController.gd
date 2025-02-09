extends CharacterBody2D

class_name CharacterController

var speed : float = 10.0
var is_walk: bool = false

func movement(_object, _delta: float):
	if is_walk: return
	if !_object.grid: return
	var direction : Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").floor()
	if direction == Vector2.ZERO or direction.x != 0 and direction.y != 0: return
	is_walk = true
	var destination : Vector2 = _object.position.floor() + direction * 16
	CustomTween.movement(_object, destination, speed * _delta, is_walk)
	await _object.get_tree().create_timer(speed * _delta).timeout
	is_walk = false
	
