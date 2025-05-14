extends Node2D

class_name Loading

@export var transition : Transition
@export var animation_player : AnimationPlayer
var next_scene_path : String = ""
var progress : Array
var flag : bool = false

func _ready() -> void:
	if get_tree().paused:
		get_tree().paused = false
	
	# Play Animation Fade in
	transition.fade_in()
	animation_player.play("loading")
	
	flag = false
	next_scene_path = ChangingLevel.next_scene
	var next_scene = load(next_scene_path)
	await get_tree().create_timer(1.45).timeout
	load_next_scene(next_scene)
	
	# Can't use multiple threads for HTML export
	#ResourceLoader.load_threaded_request(next_scene)

#func _process(_delta: float) -> void:
	#ResourceLoader.load_threaded_get_status(next_scene, progress)
	#if progress[0] >= 1.0 and !flag:
		#flag = true
		#get_tree().change_scene_to_packed(
		#ResourceLoader.load_threaded_get(next_scene)
	#)

func load_next_scene(_next_scene: PackedScene) -> void:
	transition.fade_out()
	#await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_packed(_next_scene)
	
