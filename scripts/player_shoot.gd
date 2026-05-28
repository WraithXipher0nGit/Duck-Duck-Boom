extends Node2D
@export var bullet: PackedScene

@export var can_shoot: bool = true

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	look_at(get_global_mouse_position())

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		EventBus.emit_signal("player_shot")
		spawn_bullet()

func spawn_bullet():
	if can_shoot == true:
		var muzzle = $Marker2D
		var bullet_instance = bullet.instantiate()
		bullet_instance.global_position = muzzle.global_position
		bullet_instance.rotation = muzzle.global_rotation
		get_tree().current_scene.add_child(bullet_instance)

		can_shoot = false
		await get_tree().create_timer(0.1).timeout
		can_shoot = true
