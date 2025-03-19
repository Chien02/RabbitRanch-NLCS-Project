class_name TilePath

var position : Vector2i
var parent : TilePath
var f : float = 0
var heuristic : float = 0
var cost : int = 0
var is_path : bool = true

func set_value(_position: Vector2, _f: float = 0.0, _heuristic: float = 0.0, _cost: int = 0):
	position = _position
	f = _f
	heuristic = _heuristic
	cost = _cost

func calculate_f():
	f = heuristic + cost
