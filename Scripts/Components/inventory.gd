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

# Signals
signal AddItem
signal ActivateItem

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("item_1"):
		print("From Inventory: just pressed item_1 key")
		if item_1:
			print("From Inventory: active item_1")
			item_1.active()
		else:
			print("From Inventory: cannot active item_1")
	elif Input.is_action_just_pressed("item_2"):
		print("From Inventory: just pressed item_2 key")
		if item_2:
			print("From Inventory: active item_2")
			item_2.active()
		else:
			print("From Inventory: cannot active item_2")

func add_item(item: Item):
	slots.append(item)
	print("From Inventory: Added new item: ", item.resource.name)
	set_main_item()
	print("From Inventory: Inventory's size: ", slots.size())
	AddItem.emit(item)

func drop_item(item: Item):
	if !slots.has(item): return
	slots.erase(item)
	item_manager.scan_items()
	print("From Inventory: Dropped item ", item.resource.name)

func set_main_item():
	if slots.is_empty(): return
	for slot in slots:
		if item_1 == null:
			item_1 = slot
			print("From Inventory: Set item_1 is ", slot.resource.name)
		elif item_2 == null:
			item_2 = slot
			print("From Inventory: Set item_2 is ", slot.resource.name)
		print("From Inventory: Item's name: ", slot.resource.name)

func is_using_item():
	return item_using != null
