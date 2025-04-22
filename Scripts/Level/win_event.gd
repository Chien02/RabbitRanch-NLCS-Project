extends LevelEvent

class_name WinEvent

func _ready() -> void:
	level_manager.Win.connect(win)


func _on_visibility_changed() -> void:
	if !visible: return
	if !animation_player: return
	animation_player.play("default")
