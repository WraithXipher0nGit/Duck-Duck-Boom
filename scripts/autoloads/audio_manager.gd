extends Node

# Preload sounds at startup
@export var sounds: Dictionary = {
	"shoot": preload("res://assets/audio/sfx/PlayerFire.wav"),
	"duck_death": preload("res://assets/audio/sfx/DuckHit3.wav"),
	"player_take_damage": preload("res://dummies/audio/player_take_damage.wav"),
	"game_over": preload("res://dummies/audio/player_death.wav"),
	"reload": preload("res://assets/audio/sfx/Reload.wav")
}


func _ready() -> void:
	# Subscribe to gameplay events
	EventBus.player_shot.connect(_on_player_shot)
	EventBus.duck_hit.connect(_on_duck_hit)
	EventBus.obstacle_collided.connect(_on_obstacle_collided)
	EventBus.game_over.connect(_on_game_over)
	EventBus.reloaded.connect(_on_reload)


# === Event handlers ===

func _on_player_shot(_origin: Vector2, _direction: Vector2) -> void:
	play("shoot")


func _on_duck_hit(_duck: Node) -> void:
	play("duck_death")


func _on_obstacle_collided(_obstacle: Node) -> void:
	if GameManager.lives <= 1:
		return
	play("player_take_damage")


func _on_reload() -> void:
	play("reload")

func _on_game_over() -> void:
	play("game_over")

# === Playback ===

func play(sound_name: String) -> void:
	if not sounds.has(sound_name):
		push_warning("Sound not found: " + sound_name)
		return
	
	var player = AudioStreamPlayer.new()
	player.stream = sounds[sound_name]
	player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)
