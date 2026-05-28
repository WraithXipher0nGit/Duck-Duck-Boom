extends CharacterBody2D
@onready var sprite2D = $Sprite2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var forward_speed = 500


func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	velocity.y = -forward_speed
	move_and_slide()
	
	position.x = clampf(position.x, -960, 960)
