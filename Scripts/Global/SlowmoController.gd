extends Node

func slow_mo(time_scale_value: float):
	Engine.time_scale = time_scale_value

func stop_slow_mo():
	Engine.time_scale = 1.0
