extends Control

class_name DisplayInput

@export var label : Label

var is_showing_animal_path : bool = false

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


func _on_show_animal_path_btn_button_down() -> void:
	is_showing_animal_path = not is_showing_animal_path
	var animal = get_tree().get_first_node_in_group("Animal")
	var grid = get_tree().get_first_node_in_group("Grid")
	if is_showing_animal_path:
		var paths = animal.astar.get_the_path()
		for path in paths:
			grid.get_node("Destination").set_cell(path.position, 3, Vector2i(0, 0))
	else:
		grid.clear_layer(4)
