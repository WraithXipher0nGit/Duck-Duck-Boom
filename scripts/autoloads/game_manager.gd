extends Node

const STARTING_LIVES: int = 3


var lives: int = STARTING_LIVES
var score: int = 0

# TODO: implement these for HUD manager later on
signal lives_changed(new_lives: int)
signal score_changed(new_score: int)

func _ready() -> void:
	EventBus.duck_hit.connect(_on_duck_hit)
	EventBus.duck_missed.connect(_on_duck_missed)
	EventBus.obstacle_collided.connect(_on_obstacle_collided)
	EventBus.game_restarted.connect(reset)
	

func _lose_life() -> void:
	lives -= 1
	lives_changed.emit(lives)

func reset() -> void:
	lives = STARTING_LIVES
	score = 0
	lives_changed.emit(lives)
	score_changed.emit(score)

func _on_duck_hit() -> void:
	score += 1
	score_changed.emit(score)

func _on_duck_missed(_duck: Node):
	_lose_life()

func _on_obstacle_collided(_obstacle: Node):
	_lose_life()
