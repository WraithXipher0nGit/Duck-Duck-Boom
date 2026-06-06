extends Control

# Called when the node enters the scene tree for the first time.
# Commented out because I don't actually know what it does:
# func _ready() -> void:




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	$UIButtonConfirm.play()
	await get_tree().create_timer(0.3).timeout
	print("started game")
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_stats_button_pressed() -> void:
	$UIButtonConfirm.play()
	print("viewed stats")


func _on_encyclopedia_button_pressed() -> void:
	$UIButtonConfirm.play()
	print("opened duck encyclopedia")


func _on_options_button_pressed() -> void:
	$UIButtonConfirm.play()
	print("checked options")


func _on_exit_button_pressed() -> void:
	$UIButtonBack.play()
	await get_tree().create_timer(0.3).timeout
	print("exited game")
	get_tree().quit()


func _on_play_button_mouse_entered() -> void:
	$UIButtonHover.play()


func _on_stats_button_mouse_entered() -> void:
	$UIButtonHover.play()


func _on_encyclopedia_button_mouse_entered() -> void:
	$UIButtonHover.play()


func _on_options_button_mouse_entered() -> void:
	$UIButtonHover.play()
