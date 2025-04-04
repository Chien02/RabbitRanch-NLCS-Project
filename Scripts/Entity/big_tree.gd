extends Obstacle

class_name BigTree

@export var animation_player : AnimationPlayer
@export var animation_tree : AnimationTree
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
	else:
		CustomTween.explode(self, duration)
		Destroyed.emit(local_position)
		if !CustomTween.is_connected("finished", queue_free):
			CustomTween.connect("finished", queue_free)

func switch_anim_to(new_anim: String):
	match new_anim:
		"chopped": animation_tree["parameters/conditions/is_chopped"] = true
		"chopchop": animation_tree["parameters/conditions/is_chopchop"] = true

func finish_chopchop():
	animation_tree["parameters/conditions/is_chopchop"] = false

func spawn_logs():
	var logs : Array[Obstacle]
