extends EnvironmentObject

class_name TallGrass

@export var animation_tree : AnimationTree
var visited : bool = false

func _on_area_2d_body_entered(_body: Node2D) -> void:
	waving()

func _on_area_2d_body_exited(_body: Node2D) -> void:
	waving()

func waving():
	animation_tree["parameters/conditions/is_waving"] = true
	animation_tree["parameters/conditions/is_not_waving"] = false

func stop_waving():
	animation_tree["parameters/conditions/is_waving"] = false
	animation_tree["parameters/conditions/is_not_waving"] = true
