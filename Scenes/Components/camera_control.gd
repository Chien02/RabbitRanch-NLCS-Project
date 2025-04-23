extends Camera2D

class_name CameraController

@export var init_zoom : Vector2
@export var final_zoom : Vector2
@export var target : Node2D
@export var zoom_duration : float = 2.0

func _ready() -> void:
	offset = Vector2.ZERO
	zoom = init_zoom

func _process(_delta: float) -> void:
	position = target.position
