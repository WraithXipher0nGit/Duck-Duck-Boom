extends Node2D
@export var bullet: PackedScene

@export var can_shoot: bool = true

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	look_at(get_global_mouse_position())

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		var stub: Vector2 = Vector2()
		if GameManager.bullets <= 0:
			return
		EventBus.player_shot.emit(stub, stub)
		spawn_bullet()

func spawn_bullet():
	if not can_shoot:
		return
	
	var muzzle = $Marker2D
	
	if GameManager.current_powerup == "spread_shot":
		var spread_angles = [-0.4, -0.2, 0.0, 0.2, 0.4]
		for angle_offset in spread_angles:
			_spawn_single_bullet(muzzle, angle_offset)
	else:
		_spawn_single_bullet(muzzle, 0.0)
	
	can_shoot = false
	await get_tree().create_timer(0.1).timeout
	can_shoot = true


func _spawn_single_bullet(muzzle: Node2D, angle_offset: float) -> void:
	var bullet_instance = bullet.instantiate()
	bullet_instance.global_position = muzzle.global_position
	bullet_instance.rotation = muzzle.global_rotation + angle_offset
	get_tree().current_scene.add_child(bullet_instance)
