extends Control

class_name DisplayUI

@export var label : Label
@export var label_mouse_pos : Label
@onready var level_manager : LevelManager = get_parent().get_parent()
var is_showing_animal_path : bool = false

func _process(_delta: float) -> void:
	show_input()
	show_mouse_pos()
	handle_event_UI()
	
func show_input():
	if !label: return
	if Input.is_action_just_pressed("ui_left"):
		label.text = "Left"
	elif Input.is_action_just_pressed("ui_right"):
		label.text = "Right"
	elif Input.is_action_just_pressed("ui_up"):
		label.text = "Up"
	elif Input.is_action_just_pressed("ui_down"):
		label.text = "Down"

func show_mouse_pos():
	if !label_mouse_pos: return
	var grid : Grid = get_tree().get_first_node_in_group("Grid")
	var global_mouse_pos = grid.get_global_mouse_position()
	var mouse_pos : Vector2i = grid.local_to_map(global_mouse_pos)
	label_mouse_pos.text = str(mouse_pos)
	if !grid.cells.is_empty():
		if grid.is_within_grid(mouse_pos):
			label_mouse_pos.text = str(mouse_pos) + " - is path: " + str(grid.is_path(mouse_pos))
	else:
		print("Display: Cannot find mouse_pos in cells")

func handle_event_UI():
	if $PauseUI.visible or $LossUI.visible or $WinUI.visible:
		$DebugUI/ButtonVBox/PauseButton.visible = false
	elif !$PauseUI.visible and !$LossUI.visible and !$WinUI.visible:
		$DebugUI/ButtonVBox/PauseButton.visible = true

#func _on_pause_button_pressed() -> void:
	#level_manager.emit_pause()

func _on_show_animal_path_btn_button_down() -> void:
	is_showing_animal_path = not is_showing_animal_path
	var animal : Animal = get_tree().get_first_node_in_group("Animal")
	var grid = get_tree().get_first_node_in_group("Grid")
	if is_showing_animal_path:
		var paths = animal.astar.get_the_path(animal.option, animal.mode)
		for path in paths:
			grid.get_node("Destination").set_cell(path.position, 3, Vector2i(0, 0))
	else:
		grid.clear_layer(4)
