extends Node2D
@export var bullet: PackedScene

@export var can_shoot: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(get_global_mouse_position())

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		EventBus.emit_signal("player_shot")
		print("player shot!")
		spawn_bullet()

func spawn_bullet():
	if can_shoot == true:
		print("bullet spawned!")
		var muzzle = $Marker2D
		var bullet_instance = bullet.instantiate()
		bullet_instance.global_position = muzzle.global_position
		bullet_instance.rotation = muzzle.global_rotation
		get_tree().current_scene.add_child(bullet_instance)
		#fire rate, comment out if not needed
		can_shoot = false
		await get_tree().create_timer(0.1).timeout
		can_shoot = true
