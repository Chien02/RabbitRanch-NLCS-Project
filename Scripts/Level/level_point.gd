extends Sprite2D

class_name LevelPoint

# Source button https://greenpixels.itch.io/pixel-art-asset-3

enum {
	LOCK, UNLOCK, COMPLETED
}

@export_enum("LOCK", "UNLOCK", "COMPLETED") var current_state : int = LOCK
@export var level_num : int = 0
@export var lock_frame : int = 11
@export var unlock_frame : int = 6
@export var completed_frame : int = 2
@export var next_level_path : String = ""
@export var control_node : Control
@export var texture_rect : TextureRect

var is_step_on : bool = false
var _origin_pos_sign : Vector2 = Vector2.ZERO
var is_game_pad : bool = false

var gamepad_texture_button : String = "res://Sprites/GUI/Buttons/Buttons Pack/XBOX/B.png"
var pc_texture_button : String = "res://Sprites/GUI/Buttons/Buttons Pack/KEYBOARD/KEYS/SPACE.png"

func _ready() -> void:
	is_step_on = false
	_origin_pos_sign = control_node.position
	change_state(current_state)

func _process(_delta: float):
	if Input.is_action_just_pressed("accept") and is_step_on:
		print("From LevelPoint: Change to sample scene")
		var scene_tree = get_tree()
		var level_selection : LevelSelection = scene_tree.get_first_node_in_group("LevelSelection")
		# Play audio
		level_selection.audio.play_sound(UISoundFX.Sound.COMFIRM)
		
		GlobalProperties.current_level = level_num
		print("From ", name, " go to level: ", level_num)
		
		level_selection.transition.trans_in()
		await get_tree().create_timer(0.5).timeout
			
		# Chuyển đến nextpath
		scene_tree.change_scene_to_file(next_level_path)


func change_state(state: int):
	match state:
		LOCK: frame = lock_frame
		UNLOCK:
			frame = unlock_frame
			await get_tree().create_timer(1.25).timeout
			CustomTween.bounce(self, scale, Vector2(0.5, 0.35), 0.25)
		COMPLETED: frame = completed_frame
	current_state = state

func get_next_level() -> String:
	return next_level_path

func _on_control_visibility_changed() -> void:
	if control_node.visible == true:
		var duration = 1
		CustomTween.loop_up_down(control_node, _origin_pos_sign, 10.0, duration)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if current_state == LOCK:
		print("From ", name, " state = LOCK")
		return
	if body is CharacterSelectLevel:
		control_node.visible = true
		is_step_on = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	for tween in get_tree().get_processed_tweens():
			tween.kill()
	if body is CharacterSelectLevel:
		control_node.visible = false
		is_step_on = false

func change_input_texture(_is_gamepad: bool):
	if _is_gamepad:
		texture_rect.texture = load(gamepad_texture_button)
		is_game_pad = true
	else:
		texture_rect.texture = load(pc_texture_button)
		is_game_pad = false
