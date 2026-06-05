extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	print("started game")
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_stats_button_pressed() -> void:
	print("viewed stats")


func _on_encyclopedia_button_pressed() -> void:
	print("opened duck encyclopedia")


func _on_options_button_pressed() -> void:
	print("checked options")


func _on_exit_button_pressed() -> void:
	print("exited game")
	get_tree().quit()
