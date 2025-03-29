extends Item

class_name Food

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is MainCharacter:
		print("From Rice: collide with Main Character")
		var new_item = Food.new()
		new_item.init(grid, character, resource)
		body.inventory.add_item(new_item)
	elif body is Animal:
		print("From Rice: collide with Animal")
	disappear()
