extends CharacterBody2D

class_name CharacterController

@export var tile_size : int = 16
var speed : float = 10.0
var is_walking : bool = false
var can_walk : bool = true
var is_face_same_dir : bool = false
var direction : Vector2

signal FinishedWalk

func movement(_object, _delta: float):
	if is_walking: return
	if !_object.grid: return
	if _object is MainCharacter and _object.is_using_item: return
	
	if !is_just_type_input(): return
	
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").floor()
	
	if direction == Vector2.ZERO or direction.x != 0 and direction.y != 0:
		return
	
	var next_position : Vector2 = _object.position + direction * tile_size
	var local_next_pos : Vector2i = _object.grid.local_to_map(next_position)
	# Check for the chest in game, check if next position is overlay or not with chest
	var chest : Chest = _object.get_tree().get_first_node_in_group("Chest")
	var chest_local_pos : Vector2i = Vector2i.ZERO
	if chest != null:
		chest_local_pos = _object.grid.local_to_map(chest.position)
	# Check if next_position is a obstacle or the bound then player can move to that next_position
	if _object.grid:
		# Check input is the same to current direction that character is facing
		if check_direction(_object, direction):
			can_walk = _object.grid.is_within_grid(local_next_pos) and _object.grid.is_path(local_next_pos) and local_next_pos != chest_local_pos
		else:
			can_walk = false
		print("From CharacterController: Checking can_walk: ", can_walk,"and next_local_pos: ", local_next_pos)
	is_walking = true if can_walk else false
	if !is_walking: return
	if _object.audio:
		_object.audio.play_sound(CharacterSoundFX.Sound.WALK)
	
	CustomTween.movement(_object, next_position, speed * _delta)
	await _object.get_tree().create_timer(speed * _delta + 0.1).timeout
	_object.update_local_position()
	is_walking = false

func is_just_type_input():
	if Input.is_action_just_pressed("up") or Input.is_action_just_pressed("down") or Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"):
		return true
	return false

func check_direction(character, dir: Vector2):
	if character.facing_direction != dir:
		character.facing_direction = dir
		return false
	return true

func move_to(_object, next_pos: Vector2, duration: float):
	is_walking = true
	if _object is Character:
		_object.facing_direction = (next_pos - _object.position).normalized()
	CustomTween.movement(_object, next_pos, duration)
	await _object.get_tree().create_timer(duration).timeout
	# Update local position
	if _object != null and _object is Character:
		_object.update_local_position()
	
	is_walking = false
	FinishedWalk.emit()

func movement_free(character: CharacterSelectLevel, _delta: float):
	# Get the input
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	# Nếu hướng đi khác không thì set hướng nhìn bằng hướng đi
	if direction != Vector2.ZERO:
		character.facing_direction = direction
		# Bật cờ di chuyển lên
		is_walking = true
	else:
		is_walking = false
		return
		
	# Play audio, thêm điều kiện kiểm tra để tránh bị đè âm thanh
	if character.audio and !character.audio.playing:
		character.adjust_random_pitch()
		character.audio.play_sound(CharacterSoundFX.Sound.WALK)
	
	# Hàm lerf để di chuyển nhân vật
	character.position = lerp(character.position, character.position + direction * character.speed * _delta, character.speed * _delta)
	
