extends LevelEvent

class_name WinEvent

func _process(_delta: float) -> void:
	if flag: return
	if level_manager.state == level_manager.State.WIN:
		print("From Win: Open visible")
		GlobalProperties.complete_level(level_manager.current_level)
		flag = true
		appear()

func _on_visibility_changed() -> void:
	if visible:
		animation_player.play("default")
