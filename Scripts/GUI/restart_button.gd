extends Control

# Restart button.gd

func _on_pressed() -> void:
	var scene_tree = get_tree()
	var level_manager : LevelManager = scene_tree.get_first_node_in_group("LevelManager")
	
	level_manager.audio.play_sound(UISoundFX.Sound.CONFIRM)
	await scene_tree.create_timer(0.25).timeout
	scene_tree.reload_current_scene()
