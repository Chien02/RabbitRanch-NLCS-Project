extends Obstacle

class_name BigTree

@export var animation_player : AnimationPlayer
@export var animation_tree : AnimationTree
@export var area2D : Area2D
@export var audio : CharacterSoundFX
@export var log_link : String = "res://Scenes/Entity/log.tscn"
var counter : int = 0
var max_chop : int = 3
var rooted_flag : bool = false

func _ready() -> void:
	grid = get_tree().get_first_node_in_group("Grid")

func destroy(duration: float, character: Character = null):
	if character == null or character is not MainCharacter:
		print("From BigTree: You're too weak to take me down")
	#	Play animation that shake the tree
		switch_anim_to("chopchop")
		return
	
	if !rooted_flag:
		if counter < max_chop:
			counter += 1
			switch_anim_to("chopchop")
		elif counter >= max_chop:
			counter = 0
			rooted_flag = true
			switch_anim_to("chopped")
			spawn_logs()
	else:
		CustomTween.explode(self, duration)
		Destroyed.emit(local_position)
		if !CustomTween.is_connected("finished", queue_free):
			CustomTween.connect("finished", queue_free)

func switch_anim_to(new_anim: String):
	match new_anim:
		"chopped":
			animation_tree["parameters/conditions/is_chopped"] = true
			area2D.get_child(0).set_deferred("set_disabled", true)
			modulate = Color(1, 1, 1, 1)
		"chopchop":
			animation_tree["parameters/conditions/is_chopchop"] = true

func finish_chopchop():
	animation_tree["parameters/conditions/is_chopchop"] = false

func spawn_logs():
	var logs : Array[Vector2i] = []
	var rand_num : int
	var finish_flag : bool = false
	print("From BigTree: ready to spawn logs")
	
	# play audio
	if audio:
		audio.play_sound(CharacterSoundFX.Sound.FALLING_TREE)
	
	var neighbors = grid.get_surrounding_cells(local_position)
	var count_loop = 0
	var max_loop = 10
	while (!finish_flag and count_loop < max_loop):
		var random_neighbor = neighbors.pick_random()
		logs.append(random_neighbor)
		print("From BigTree: random at position: ", random_neighbor)
			
		# Add second slot to logs
		match rand_num:
			1: logs.append(random_neighbor + Vector2i(-1, 0))
			2: logs.append(random_neighbor + Vector2i(0, -1))
			3: logs.append(random_neighbor + Vector2i(1, 0))
			4: logs.append(random_neighbor + Vector2i(0, 1))
			
		# Check logs
		var turnbased_manager : TurnBasedManager = get_tree().get_first_node_in_group("TurnBasedManager")
		var actors_pos : Array[Vector2i] = []
		for actor in turnbased_manager.actor:
			if actor == null: continue
			actors_pos.append(grid.local_to_map(actor.position))
		# Check that position is spawnable or not
		for _log in logs:
			if !grid.is_path(_log) or actors_pos.has(_log):
				print("From BigTree: Overlay on obstacle at ", _log)
				logs.erase(_log)
				continue
			if grid.is_path(_log) and !actors_pos.has(_log):
				# Sinh ra các logs
				var new_log : Obstacle = load(log_link).instantiate()
				new_log.global_spawn = grid.map_to_local(_log)
				new_log.global_position = grid.map_to_local(_log)
				new_log.init_pushable_diretion(grid)
				var obstacle_manager = get_parent()
				obstacle_manager.call_deferred("add_child", new_log)
				print("From BigTree: Added new log to scene")
		
		if !logs.is_empty():
			finish_flag = true
			grid.rescan()
			return
		else:
			count_loop += 1


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is not Character: return
	print("From bigTree: Character behide, fade this tree.")
	modulate = Color(1, 1, 1, 0.5)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is not Character: return
	modulate = Color(1, 1, 1, 1)
