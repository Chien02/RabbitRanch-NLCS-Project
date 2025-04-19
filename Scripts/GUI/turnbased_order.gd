extends Control

class_name TurnBaseOrder

@export var vbox_container : VBoxContainer
@export var actors_UI : Array[TurnBasedUI] = []
var actors : Array[Character] = []
var turnbased_manager : TurnBasedManager

func _ready() -> void:
	var level_manager : LevelManager = get_tree().get_first_node_in_group("LevelManager")
	level_manager.DropActorUIBar.connect(drop_ui_bar)
	turnbased_manager = get_tree().get_first_node_in_group("TurnBasedManager")
	turnbased_manager.SwitchedActor.connect(display_current_actor)
	
	init_actor_to_UI()
	display_current_actor()

# Hàm này dùng để xác định số lượng actor đang có ở trên sân
# để khởi tạo các thanh UI hiển thị
func init_actor_to_UI():
	var temp_array = get_tree().get_nodes_in_group("Character")
	for character in temp_array:
		if character is not Character: continue
		actors.append(character)
		character.Disappear.connect(drop_ui_bar)
	
	# Lấy texture và số bước của các character để set cho các UI
	for character in actors:
		if character.resource == null:
			print("From TurnBasedOrder: ", character.name, "has no resource")
			continue
		
		var new_ui_bar = preload("res://Scenes/GUI/turnbasedUI.tscn").instantiate()
		
		new_ui_bar.init(character.name, character.resource.texture, character.resource.step)
		
		actors_UI.append(new_ui_bar)
		vbox_container.add_child(new_ui_bar)

func display_current_actor(actor: Character = null):
	#var _duration : float = 0.5  This use for custom_tween
	var inactive = TurnBasedManager.INACTIVE
	var active = TurnBasedManager.ACTIVE
	var temp_current_actor = turnbased_manager.current_actor
	
	for _actor in actors_UI:
		if actor:
			if actor.name.to_lower() != _actor.character_name.to_lower():
				_actor.set_color(inactive)
				continue
			_actor.set_color(active)
		else:
			if _actor.character_name == temp_current_actor.name:
				_actor.set_color(active)
				continue
			_actor.set_color(inactive)

func drop_ui_bar(character: Character):
	for actor in actors_UI:
		if actor.character_name.to_lower() != character.name.to_lower():
			continue
		print("From TurnBaseOrder: drop ui_bar: ", character.name)
		actor.visible = false
		actor.clear_property()
		return
