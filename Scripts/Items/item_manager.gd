extends Node2D

class_name ItemManager

# Components
@export var grid : Grid

var items_on_field = {}
var items : Array[Item] = []

func scan_items():
	items.clear()
	items_on_field.clear()
	
	for child in get_children():
		if child is Item:
			items.append(child)
			
			var item_local_pos : Vector2i = grid.local_to_map(child.position)
			var is_food : bool = true if child.resource.is_food else false
			items_on_field[str(item_local_pos)] = {
				"is_food": child.resource.is_food
			}
	print("From Item Manager: items_on_field: ", items_on_field)

func get_items():
	scan_items()
	return items_on_field
