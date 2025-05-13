extends Obstacle

class_name BigTree

@export var animation_player : AnimationPlayer
@export var animation_tree : AnimationTree
@export var area2D : Area2D
@export var audio : CharacterSoundFX
@export var logs_manager : LogsManager

var counter : int = 0
var max_chop : int = 2
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
			logs_manager.spawn_log()
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


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is not Character: return
	print("From bigTree: Character behide, fade this tree.")
	modulate = Color(1, 1, 1, 0.5)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is not Character: return
	modulate = Color(1, 1, 1, 1)
