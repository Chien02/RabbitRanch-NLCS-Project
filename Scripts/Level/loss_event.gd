extends LevelEvent

class_name LossEvent


func _ready() -> void:
	level_manager.Loss.connect(loss)


func _on_visibility_changed() -> void:
	if !visible: return
	if !animation_player: return
	animation_player.play("default")
