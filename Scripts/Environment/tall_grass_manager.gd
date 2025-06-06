extends Node2D

class_name TallGrassManager

var grass_areas : Array[Area2D] = []
var area_animals_inside = {}
var area_players_inside = {}

func _ready() -> void:
	var areas_manager : AreaManager = get_node("Areas")
	for area in areas_manager.get_children():
		grass_areas.append(area)
		area_animals_inside[area.name] = {
			"body": []
		}
		area_players_inside[area.name] = {
			"body": []
		}
	
	areas_manager.body_entered.connect(on_area_2d_body_entered)
	areas_manager.body_exited.connect(on_area_2d_body_enxited)

func hide_body(body: Character, area: Area2D):
	if body == null: return
	
	# Kiểm tra xem body này là con vật hay người chơi, sau đó thêm area được truyền vào
	# theo đúng phân loại
	if body is MainCharacter:
		print("From TallGrassManager: body is ", body.name)
		if not area_players_inside.has(area.name):
			area_players_inside[area.name] = {"body": []}
		
		area_players_inside[area.name]["body"].append(body)
		body.modulate = Color(1, 1, 1, 0.65)
		
		# Kiểm tra trong bụi có con vật không
		if area_animals_inside.has(area.name):
			for _body in area_animals_inside[area.name]["body"]:
				_body.visible = true
				print("From TallGrassManager: Found ", _body.name, " in the same grass with player")
		return
	
	if body is Animal:
		print("From TallGrassManager: body: ", body.name, " is Animal")
		# Nếu bụi này chưa khởi tạo có con vật nào bên trong thì khởi tạo bụi này
		if not area_animals_inside.has(area.name):
			area_animals_inside[area.name] = {"body": []}
		
		# Thêm con vật vào trong bụi tương ứng
		body.modulate = Color(1, 1, 1, 0.65)
		body.visible = false
		area_animals_inside[area.name]["body"].append(body)
		
		# Kiểm tra trong bụi có nguời chơi không
		if area_players_inside.has(area.name):
			if area_players_inside[area.name]["body"].is_empty(): return
			print("From TallGrassManager: Found Player in the same grass with ", body.name)
			for _body in area_animals_inside[area.name]["body"]:
				_body.visible = true


func stop_hide_body(body: Character, area: Area2D):
	body.modulate = Color(1, 1, 1, 1)
	if body is Animal:
		body.visible = true
		area_animals_inside[area.name]["body"].erase(body)
		if area_animals_inside[area.name]["body"].is_empty():
			area_animals_inside.erase(area.name)
	
	elif body is MainCharacter:
		area_players_inside[area.name]["body"].erase(body)
		if area_players_inside[area.name]["body"].is_empty():
			area_players_inside.erase(area.name)
		
		# Tắt visible của các con vật trong area đó nếu có
		if area_animals_inside.has(area.name):
			if area_animals_inside[area.name]["body"].is_empty(): return
			for animal in area_animals_inside[area.name]["body"]:
				animal.visible = false


func on_area_2d_body_entered(body: Node2D, area: Area2D) -> void:
	if body is not Character: return
	print("From TallGrassManager: body entered is ", body.name, " and area is: ", area.name)
	hide_body(body, area)


func  on_area_2d_body_enxited(body: Node2D, area: Area2D) -> void:
	if body is not Character: return
	print("From TallGrassManager: body exited is ", body.name, " and area is: ", area.name)
	stop_hide_body(body, area)
