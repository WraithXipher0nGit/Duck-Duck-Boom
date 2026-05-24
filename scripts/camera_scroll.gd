extends Camera2D

@export var scroll_speed: float = 100.0

func _process(delta):
	global_position.y -= scroll_speed * delta
