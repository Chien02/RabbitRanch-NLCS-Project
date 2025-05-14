extends Node2D

class_name SelectPointManager

@export var level_points : Array[LevelPoint]
@export var scripted_unlocked_level : Array[Array] = [
	[1, 2], # 0
	[3], # 1
	[4], # 2
]
var level_selection : LevelSelection

func _ready() -> void:
	level_selection = get_parent()
	load_level_process()

func load_level_process():
	for level in level_points:
		# load các level đã complete
		if GlobalProperties.completed_level.has(level.level_num) and level.current_state != LevelPoint.COMPLETED:
			level.change_state(LevelPoint.COMPLETED)
			unlock_new_level(level.level_num)
			continue
		
		# Load các level đã được unlock
		if GlobalProperties.unlocked_level.has(level.level_num) and level.current_state != LevelPoint.COMPLETED:
			level.change_state(LevelPoint.UNLOCK)
		

func unlock_new_level(current_level: int):
	for index in range(0, scripted_unlocked_level.size()):
		if index != current_level: continue
		
		for child in scripted_unlocked_level[index]:
			var new_level : LevelPoint = level_points.get(child)
			new_level.change_state(LevelPoint.UNLOCK)
			GlobalProperties.unlocked_level.append(new_level.get_index())
			print("From LevelPointManager: unlock ", new_level.level_num)
		return
