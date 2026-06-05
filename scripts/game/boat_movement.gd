extends CharacterBody2D
@onready var sprites = $Sprites
@onready var hitbox: Area2D = $Hitbox
@onready var camera: Camera2D = $Camera2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var invulnerable_duration: float = 2.0
var forward_speed = 300
var max_forward_speed = 1000

var _is_invulnerable: bool = false


func _physics_process(delta: float) -> void:
	if forward_speed < max_forward_speed:
		forward_speed += 0.05
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	velocity.y = -forward_speed
	move_and_slide()
	
	position.x = clampf(position.x, -960, 960)


func _ready() -> void:
	hitbox.area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	if _is_invulnerable:
		return
	if area.is_in_group("obstacles"):
		EventBus.obstacle_collided.emit(area)
		print("obstacle collided")
		area.queue_free()
		camera.shake()
		_start_invulnerability()
	else:
		pass
		

func _start_invulnerability() -> void:
	_is_invulnerable = true
	var blink_tween = create_tween()
	blink_tween.set_loops(int(invulnerable_duration / 0.2))
	blink_tween.tween_property(sprites, "modulate:a", 0.3, 0.1)
	blink_tween.tween_property(sprites, "modulate:a", 1.0, 0.1)
	
	await get_tree().create_timer(invulnerable_duration).timeout
	
	_is_invulnerable = false
	sprites.modulate.a = 1.0
