extends CanvasLayer

@export var heart_full: Texture2D
@export var heart_empty: Texture2D
@export var bullet_full: Texture2D
@export var bullet_empty: Texture2D

@onready var score_label: Label = $ScoreContainer/ScoreLabel
@onready var hearts: Array = [
	$HeartsContainer/VBoxContainer/HBoxContainer/Heart1,
	$HeartsContainer/VBoxContainer/HBoxContainer/Heart2,
	$HeartsContainer/VBoxContainer/HBoxContainer/Heart3,
]

@onready var bullets: Array = [
	$HeartsContainer/VBoxContainer/HBoxContainer2/Bullet1,
	$HeartsContainer/VBoxContainer/HBoxContainer2/Bullet2,
	$HeartsContainer/VBoxContainer/HBoxContainer2/Bullet3,
	$HeartsContainer/VBoxContainer/HBoxContainer2/Bullet4,
	$HeartsContainer/VBoxContainer/HBoxContainer2/Bullet5,
]


func _ready() -> void:
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.lives_changed.connect(_on_lives_changed)
	GameManager.bullets_changed.connect(_on_bullets_changed)
	EventBus.game_over.connect(_on_game_over)
	_on_score_changed(GameManager.score)
	_on_lives_changed(GameManager.lives)
	_on_bullets_changed(GameManager.bullets)


func _on_score_changed(new_score: int) -> void:
	score_label.text = "Score: %d" % new_score

func _on_lives_changed(new_lives: int) -> void:
	for i in hearts.size():
		if i < new_lives:
			hearts[i].texture = heart_full
		else:
			hearts[i].texture = heart_empty

func _on_game_over() -> void:
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/ui/game_over.tscn")

func _on_bullets_changed(new_bullets: int) -> void:
	for i in bullets.size():
		if i < new_bullets:
			bullets[i].texture = bullet_full
		else:
			bullets[i].texture = bullet_empty
