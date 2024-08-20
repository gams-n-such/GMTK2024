extends Label

@onready var _timer : Timer = $GameTimer

var _seconds_passed : float:
	get: 
		return _timer.wait_time - _timer.time_left

var time_string : String:
	get:
		var int_seconds = _seconds_passed as int
		var minutes = int_seconds / 60
		var seconds = int_seconds % 60
		return "%02d:%02d" % [minutes, seconds]

func _process(delta: float) -> void:
	text = time_string
	pass
