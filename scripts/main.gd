extends Node

@onready var menu = $World/Hud

func _ready() -> void:
	menu.hide()

	if menu.has_signal("restart_requested"):
		menu.restart_requested.connect(_on_restart_requested)

	await get_tree().create_timer(10.0).timeout
	show_menu()

func show_menu() -> void:
	menu.show()
	get_tree().paused = true

func _on_restart_requested() -> void:
	print("RESTART SIGNAL RECEIVED")

	get_tree().paused = false

	GameManager.score = 0
	GameManager.lives = 3
	GameManager.bullets = 5

	get_tree().reload_current_scene()
