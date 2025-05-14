extends Node

# ChangingScene : Global

var next_scene : String
var loaded_next_scene : PackedScene
func change_scene_to(scene_tree: SceneTree, _path: String):
	next_scene = _path
	scene_tree.change_scene_to_packed(preload("res://Scenes/GUI/loading_scene.tscn"))
