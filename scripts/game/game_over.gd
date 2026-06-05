extends Control

@onready var final_score_label: Label = $CenterContainer/VBoxContainer/FinalScoreLabel


func _ready() -> void:
	final_score_label.text = "Score: %d" % GameManager.score


func _on_play_again_button_pressed() -> void:
	GameManager.reset()
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_back_to_menu_button_pressed() -> void:
	GameManager.reset()
	get_tree().change_scene_to_file("res://scenes/menu/main.tscn")
