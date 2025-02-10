extends CharacterBody2D

class_name CharacterController

var speed : float = 10.0
var is_walk : bool = false
var can_walk : bool = true

func movement(_object, _delta: float):
	if is_walk: return
	if !_object.grid: return
	var direction : Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").floor()
	if direction == Vector2.ZERO or direction.x != 0 and direction.y != 0: return
	var next_position : Vector2 = _object.position.floor() + direction * 16
	# Check if next_position is a obstacle then player can move to that next_position
	if _object.grid:
		can_walk = false if _object.grid.is_obstacle(next_position) else true
	if !can_walk:
		is_walk = false
		return
	else:
		is_walk = true
	CustomTween.movement(_object, next_position, speed * _delta)
	await _object.get_tree().create_timer(speed * _delta).timeout
	is_walk = false
	
