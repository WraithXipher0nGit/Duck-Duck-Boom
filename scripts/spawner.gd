extends Node

@export var obstacle_scene: PackedScene
@export var duck_scene: PackedScene

@export var wave_height_rows: int = 4
@export var look_ahead_rows: int = 8

@export var debug_mode: bool = true

var difficulty: float = 1.0
var difficulty_increase_rate: float = 0.05

@onready var grid: Node = get_tree().get_first_node_in_group("spawn_grid")
@onready var entities_container: Node = get_tree().get_first_node_in_group("entities")
@onready var camera: Camera2D = get_viewport().get_camera_2d()

var _last_spawn_row: int = 0


func _ready() -> void:
	if grid == null or entities_container == null:
		push_error("Spawner couldn't find required nodes")
		return
	
	_last_spawn_row = 0
	_check_and_spawn_ahead()


func _process(_delta: float) -> void:
	_check_and_spawn_ahead()


func _check_and_spawn_ahead() -> void:
	if camera == null:
		camera = get_viewport().get_camera_2d()
		if camera == null:
			return
	
	var camera_row = grid.world_to_tile(camera.global_position).x
	
	while _last_spawn_row > camera_row - look_ahead_rows:
		var next_start = _last_spawn_row - wave_height_rows
		_spawn_wave_at(next_start)
		_last_spawn_row = next_start
		_increase_difficulty()


func _spawn_wave_at(start_row: int) -> void:
	grid.generate_safe_path_for_rows(start_row, start_row + wave_height_rows, _path_width())
	
	var obstacle_count = int(clamp(2 + difficulty * 0.5, 2, 8))
	var duck_count = int(clamp(3 + difficulty * 0.4, 3, 8))
	
	if debug_mode:
		print("Wave at row=", start_row, " difficulty=", difficulty,
			  " obstacles=", obstacle_count, " ducks=", duck_count)
	
	_spawn_group_in_rows(obstacle_scene, obstacle_count, start_row,
						 start_row + wave_height_rows, false)
	_spawn_group_in_rows(duck_scene, duck_count, start_row,
						 start_row + wave_height_rows, true)


func _spawn_group_in_rows(scene: PackedScene, count: int, row_start: int,
						   row_end: int, allow_safe_path: bool) -> void:
	var spawned = 0
	var attempts = 0
	var max_attempts = 50
	
	while spawned < count and attempts < max_attempts:
		attempts += 1
		
		var row = randi_range(row_start, row_end - 1)
		var col = randi_range(0, grid.get_cols() - 1)
		
		if not grid.is_tile_free(row, col):
			continue
		if not allow_safe_path and grid.is_safe_tile(row, col):
			continue
		
		_spawn_entity(scene, row, col)
		spawned += 1


func _spawn_entity(scene: PackedScene, row: int, col: int) -> void:
	var obj = scene.instantiate()
	obj.grid_row = row
	obj.grid_col = col
	entities_container.add_child(obj)


func _path_width() -> int:
	return max(1, int(2 - difficulty * 0.1))


func _increase_difficulty() -> void:
	difficulty = min(difficulty + difficulty_increase_rate, 20.0)
