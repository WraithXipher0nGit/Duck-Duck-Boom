extends Camera2D

@export var scroll_speed: float = 500.0

func _process(delta):
	global_position.y -= scroll_speed * delta
