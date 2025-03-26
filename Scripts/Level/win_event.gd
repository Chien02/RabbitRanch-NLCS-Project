extends LevelEvent

class_name WinEvent

func _ready() -> void:
	level_manager.connect("win", win)
