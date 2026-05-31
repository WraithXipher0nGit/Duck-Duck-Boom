extends Node

const STARTING_LIVES: int = 3
const STARTING_BULLETS: int = 5


var lives: int = STARTING_LIVES
var bullets: int = STARTING_BULLETS
var score: int = 0
var reload_time: float = 3

# TODO: implement these for HUD manager later on
signal lives_changed(new_lives: int)
signal score_changed(new_score: int)
signal bullets_changed(new_bullets: int)

func _ready() -> void:
	EventBus.duck_hit.connect(_on_duck_hit)
	EventBus.duck_missed.connect(_on_duck_missed)
	EventBus.obstacle_collided.connect(_on_obstacle_collided)
	EventBus.game_restarted.connect(reset)
	EventBus.player_shot.connect(_on_player_shot)
	

func _lose_life() -> void:
	lives -= 1
	lives_changed.emit(lives)
	if lives <= 0:
		EventBus.game_over.emit()

func _lose_bullet() -> void:
	if bullets <= 0:
		return
	bullets -=1
	bullets_changed.emit(bullets)

func _restore_bullets() -> void:
	bullets = 5
	bullets_changed.emit(bullets)

func reset() -> void:
	lives = STARTING_LIVES
	score = 0
	lives_changed.emit(lives)
	score_changed.emit(score)

func _on_duck_hit(_duck: Node) -> void:
	score += 1
	score_changed.emit(score)

func _on_duck_missed(_duck: Node):
	_lose_life()

func _on_obstacle_collided(_obstacle: Node):
	_lose_life()

func _on_player_shot(_origin: Vector2, direction: Vector2):
	_lose_bullet()
	if bullets <= 0:
		_reload()

func _reload():
	await get_tree().create_timer(reload_time).timeout
	_restore_bullets()
	EventBus.reloaded.emit()
