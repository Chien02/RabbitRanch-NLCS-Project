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

func add_item(item: Item):
	slots.append(item)
	item_manager.scan_items()
	print("From Inventory: Added new item: ", item.resource.name)
	
	if slots.is_empty() or slots.size() == 1:
		set_main_item(item)
	
	print("From Inventory: Inventory's size: ", slots.size())
	AddItem.emit(item)

func drop_item(item: Item):
	if !slots.has(item): return
	slots.erase(item)
	item_manager.scan_items()
	print("From Inventory: Dropped item ", item.resource.name)

func set_main_item(item: Item):
	if item_1 == null:
		item_1 = item
		print("From Inventory: Set item_1 = ", item.resource.name)
	elif item_2 == null:
		item_2 = item
		print("From Inventory: Set item_2 = ", item.resource.name)

func is_using_item():
	return item_using != null
