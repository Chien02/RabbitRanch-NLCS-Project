extends LevelEvent

class_name LossEvent

func _ready() -> void:
	level_manager.connect("loss", loss)
