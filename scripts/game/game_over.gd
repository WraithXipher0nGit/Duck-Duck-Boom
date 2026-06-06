extends Control

@onready var final_score_label: Label = $CenterContainer/VBoxContainer/FinalScoreLabel


func _ready() -> void:
	final_score_label.text = "Score: %d" % GameManager.score


func _on_play_again_button_mouse_entered() -> void:
	$UIButtonHover.play()


func _on_back_to_menu_button_mouse_entered() -> void:
	$UIButtonHover.play()



func _on_play_again_button_pressed() -> void:
	$UIButtonConfirm.play()
	await get_tree().create_timer(0.3).timeout
	GameManager.reset()
	get_tree().change_scene_to_file("res://scenes/world.tscn")




func _on_back_to_menu_button_pressed() -> void:
	$UIButtonBack.play()
	await get_tree().create_timer(0.3).timeout
	GameManager.reset()
	get_tree().change_scene_to_file("res://scenes/menu/main.tscn")
