extends Control

class_name DisplayInput

@export var label : Label

func _process(_delta: float) -> void:
	if !label: return
	if Input.is_action_just_pressed("ui_left"):
		label.text = "Left"
	elif Input.is_action_just_pressed("ui_right"):
		label.text = "Right"
	elif Input.is_action_just_pressed("ui_up"):
		label.text = "Up"
	elif Input.is_action_just_pressed("ui_down"):
		label.text = "Down"
