extends LevelEvent

class_name PauseEvent

func _ready() -> void:
	level_manager.Paused.connect(pause)
