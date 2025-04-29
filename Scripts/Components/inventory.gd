extends Node2D

class_name Inventory

# Properties
var slots : Array[Item] = []
var item_1 : Item = null
var item_2 : Item = null
var item_using: Item = null

# Components
@onready var item_manager : ItemManager = get_tree().get_first_node_in_group("ItemManager")
@onready var inventoryUI : InventoryUI = get_tree().get_first_node_in_group("InventoryUI")
@onready var character : MainCharacter = get_parent()

# Signals
signal AddItem
signal DropItem
signal UsingItem
signal FinishedUsingItem

func _process(_delta: float) -> void:
	# Stop receive input when not in turn
	if !character.turnbase_actor.is_active: return
	
	if Input.is_action_just_pressed("item_1"):
		print("From Inventory: just pressed item_1 key")
		if item_1:
			print("From Inventory: active item_1: ", item_1.resource.name)
			item_1.active()
			UsingItem.emit(item_1.resource.name)
		else:
			print("From Inventory: cannot active item_1: ", item_1)
			print("From Inventory: inventory ", slots)
	
	if Input.is_action_just_pressed("item_2"):
		print("From Inventory: just pressed item_2 key")
		if item_2:
			print("From Inventory: active item_2: ", item_2.resource.name)
			item_2.active()
			UsingItem.emit(item_2.resource.name)
		else:
			print("From Inventory: cannot active item_2: ", item_2)
			print("From Inventory: inventory ", slots)

func add_item(item: Item):
	if !item.character:
		item.set_character(character)
	
	slots.append(item)
	#call_deferred("add_child", item)
	print("From Inventory: Added new item: ", item.resource.name)
	set_main_item(item)
	print("From Inventory: Inventory's size: ", slots.size())
	AddItem.emit(item)

func drop_item(item: Item, pos: Vector2):
	if !slots.has(item): return
	if item_1 != null and item.resource.name == item_1.resource.name: item_1 = null
	elif item_2 != null and item.resource.name == item_2.resource.name: item_2 = null
	slots.erase(item)
	DropItem.emit(item)
	# Add new item to the field
	var new_item : Item = load(item.resource.link).instantiate()
	new_item.init(item.grid, item.character, item.resource)
	new_item.position = pos
	item_manager.call_deferred("add_child", new_item)
	# Release old item in inventory
	item.queue_free()
	# Scan new item on the field
	item_manager.scan_items()
	print("From Inventory: Dropped item ", item.resource.name)
	print("From Inventory: Items in inventory: ", slots)
	print("From Inventory: item1: ", item_1, " -- item2: ", item_2)

func set_main_item(item: Item):
	if item_1 == null:
		item_1 = item
		print("From Inventory: Set item_1 is ", item_1.resource.name)
	elif item_2 == null:
		item_2 = item
		print("From Inventory: Set item_2 is ", item_2.resource.name)

func is_using_item():
	return item_using != null

func has_item(item_name: String):
	for item in slots:
		if item.name.to_lower() == item_name.to_lower():
			return true
	return false
