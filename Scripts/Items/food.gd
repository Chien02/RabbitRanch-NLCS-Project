extends Item

class_name Food

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is MainCharacter:
		print("From Rice: collide with Main Character")
	elif body is Animal:
		print("From Rice: collide with Animal")
	disappear()
