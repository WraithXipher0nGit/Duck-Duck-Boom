extends Area2D
@export var bullet_speed = 1200

@onready var notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	notifier.screen_exited.connect(_on_screen_exited) 


func _process(delta: float) -> void:
	position += transform.x * bullet_speed * delta
	

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("ducks"):
		EventBus.duck_hit.emit(area)
		area.die()
		queue_free()
	elif area.is_in_group("obstacles"):
		queue_free()


func _on_screen_exited() -> void:
	queue_free()
