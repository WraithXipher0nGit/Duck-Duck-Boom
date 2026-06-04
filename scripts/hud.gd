extends CanvasLayer

@export var heart_full: Texture2D
@export var heart_empty: Texture2D
@export var bullet_full: Texture2D
@export var bullet_empty: Texture2D

signal restart_requested

@onready var score_label: Label = $ScoreContainer/ScoreLabel

@onready var hearts = [
	$HeartsContainer/VBoxContainer/HBoxContainer/Heart1,
	$HeartsContainer/VBoxContainer/HBoxContainer/Heart2,
	$HeartsContainer/VBoxContainer/HBoxContainer/Heart3
]

@onready var bullets = [
	$HeartsContainer/VBoxContainer/HBoxContainer2/Bullet1,
	$HeartsContainer/VBoxContainer/HBoxContainer2/Bullet2,
	$HeartsContainer/VBoxContainer/HBoxContainer2/Bullet3,
	$HeartsContainer/VBoxContainer/HBoxContainer2/Bullet4,
	$HeartsContainer/VBoxContainer/HBoxContainer2/Bullet5
]

@onready var game_over_overlay: ColorRect = $GameOverOverlay
@onready var final_score_label: Label = $GameOverOverlay/CenterContainer/VBoxContainer/FinalScoreLabel

@onready var restart_button: Button = $Restart
@onready var quit_button: Button = $Quit

func _ready() -> void:
	# Allow UI to work while game is paused
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

	GameManager.score_changed.connect(_on_score_changed)
	GameManager.lives_changed.connect(_on_lives_changed)
	GameManager.bullets_changed.connect(_on_bullets_changed)
	EventBus.game_over.connect(_on_game_over)

	# Prevent duplicate signal connection errors
	if not restart_button.pressed.is_connected(_on_restart_pressed):
		restart_button.pressed.connect(_on_restart_pressed)

	if not quit_button.pressed.is_connected(_on_quit_pressed):
		quit_button.pressed.connect(_on_quit_pressed)

	_on_score_changed(GameManager.score)
	_on_lives_changed(GameManager.lives)
	_on_bullets_changed(GameManager.bullets)

	game_over_overlay.visible = false

func _on_score_changed(new_score: int) -> void:
	score_label.text = "Score: %d" % new_score

func _on_lives_changed(new_lives: int) -> void:
	for i in range(hearts.size()):
		hearts[i].texture = heart_full if i < new_lives else heart_empty

func _on_bullets_changed(new_bullets: int) -> void:
	for i in range(bullets.size()):
		bullets[i].texture = bullet_full if i < new_bullets else bullet_empty

func _on_game_over() -> void:
	final_score_label.text = "Score: %d" % GameManager.score
	game_over_overlay.visible = true
	get_tree().paused = true

func _on_restart_pressed() -> void:
	print("RESTART CLICKED")
	restart_requested.emit()

func _on_quit_pressed() -> void:
	print("QUIT CLICKED")
	get_tree().quit()
