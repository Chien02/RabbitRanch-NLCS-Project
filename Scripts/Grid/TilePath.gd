class_name TilePath

var position : Vector2i
var parent : TilePath = null
var f : float = 0.0
var heuristic : float = 0.0
var cost : float = 0.0
var is_path : bool = true

func set_value(_position: Vector2, _f: float = 0.0, _heuristic: float = 0.0, _cost: int = 0):
	position = _position
	f = _f
	heuristic = _heuristic
	cost = _cost

func set_parent(_parent):
	parent = _parent

func calculate_f():
	f = heuristic + cost
