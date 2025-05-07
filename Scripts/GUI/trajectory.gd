extends Line2D

class_name TrajectoryPath

@export var speed: float = 1.0
@export var gravity: float = 100.0
@export var time_step: float = 0.1
@export var max_points: int = 50

@onready var character : MainCharacter = get_tree().get_first_node_in_group("MainCharacter")

var show_line_flag: bool = false

# Test grid data
var grid: Grid
var selecting_tile: Vector2i
var selecting_position: Vector2
var direction : Vector2 = Vector2.ZERO


func _ready() -> void:
	grid = get_tree().get_first_node_in_group("Grid")
	hide_line()


func update_trajectory(target_pos: Vector2) -> void:
	if !show_line_flag: return

	clear_points()

	var start : Vector2 = position
	direction = (target_pos - character.position).normalized()
	var velocity : Vector2 = direction
	var _position : Vector2 = start

	for i in max_points:
		add_point(_position)
		velocity.y += gravity * time_step
		_position += velocity * time_step
		# Optional: break if below target
		if position.distance_to(target_pos) < 5.0:
			break


func show_line() -> void:
	#print("From Trajectory: show line")
	visible = true
	show_line_flag = true


func hide_line() -> void:
	#print("From Trajectory: hide line")
	visible = false
	show_line_flag = false
