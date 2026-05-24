extends Area2D
@export var bullet_speed = 1200

func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	position += transform.x * bullet_speed * delta
	
