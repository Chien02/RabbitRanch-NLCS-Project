extends Control

# Restart button.gd

func _on_pressed() -> void:
	get_tree().reload_current_scene()
