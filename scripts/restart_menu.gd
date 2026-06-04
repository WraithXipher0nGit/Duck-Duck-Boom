extends CanvasLayer

signal restart_requested

@onready var restart_button = $Panel/Restart
@onready var quit_button = $Panel/Quit


func _ready() -> void:
	restart_button.pressed.connect(_on_restart_pressed)
	quit_button.pressed.connect(_on_quit_pressed)


func _on_restart_pressed() -> void:
	print("Restart pressed")
	restart_requested.emit()


func _on_quit_pressed() -> void:
	get_tree().quit()
