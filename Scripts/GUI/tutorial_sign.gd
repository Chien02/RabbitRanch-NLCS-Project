extends Control

# Tutorial Sign UI
signal Accepted


func _on_button_pressed() -> void:
	Accepted.emit(name)
