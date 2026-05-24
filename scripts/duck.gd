extends Area2D
@onready var sprite: Sprite2D = $Sprite2D

@export var grid_row: int = 0
@export var grid_col: int = 0


# movement control
@export var tick_interval: float = 5            
@export var move_probability_per_tick: float = 0.15
@export var max_position_offset: float = 60.0
@export var min_position_offset: float = 30.0

@export var move_speed_min: float = 50.0
@export var move_speed_max: float = 60.0
var _move_speed: float = 55.0


@onready var grid: Node = get_tree().get_first_node_in_group("spawn_grid")
@onready var notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

var _move_timer: Timer
var _is_moving: bool = false
var _move_duration: float = 0
var _last_offset: Vector2 = Vector2.ZERO


func _ready() -> void:
	if grid == null:
		push_error("Duck couldn't find spawn_grid")
		return
	
	_move_speed = randf_range(move_speed_min, move_speed_max)
	
	add_to_group("ducks")
	notifier.screen_exited.connect(_on_screen_exited)
	
	grid.occupy(grid_row, grid_col, self)
	# last offset needed to calculate duck sprite hflip
	_last_offset = _random_tile_offset()
	global_position = grid.tile_to_world(grid_row, grid_col) + _last_offset
	
	_move_timer = Timer.new()
	_move_timer.one_shot = true
	_move_timer.timeout.connect(_consider_move)
	add_child(_move_timer)
	_schedule_next_move()


func _schedule_next_move() -> void:
	_move_timer.wait_time = tick_interval
	_move_timer.start()


func _consider_move() -> void:
	if _is_moving:
		_schedule_next_move()
		return
		
	if randf() > move_probability_per_tick:
		_schedule_next_move()
		return
	
	var directions = [Vector2i(-1, 0), Vector2i(1, 0), Vector2i(0, -1), Vector2i(0, 1)]
	directions.shuffle()
	
	for dir in directions:
		var new_row = grid_row + dir.x
		var new_col = grid_col + dir.y
		if grid.is_tile_free(new_row, new_col):
			_start_move(new_row, new_col)
			return
	
	_schedule_next_move()


func _start_move(new_row: int, new_col: int) -> void:
	_is_moving = true
	grid.occupy(new_row, new_col, self)
	
	var col_delta = new_col - grid_col
	var new_offset = _random_tile_offset()
	var target_pos = grid.tile_to_world(new_row, new_col) + new_offset
	
	if col_delta < 0:
		sprite.flip_h = true
	elif col_delta > 0:
		sprite.flip_h = false
	else:
		var offset_dx = new_offset.x - _last_offset.x
		if offset_dx < 0:
			sprite.flip_h = true
		elif offset_dx > 0:
			sprite.flip_h = false
	
	_last_offset = new_offset
	
	var distance = global_position.distance_to(target_pos)
	var duration = distance / _move_speed
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "global_position", target_pos, duration)
	tween.finished.connect(func(): _finish_move(new_row, new_col))


func _finish_move(new_row: int, new_col: int) -> void:
	grid.vacate(grid_row, grid_col)
	grid_row = new_row
	grid_col = new_col
	_is_moving = false
	_schedule_next_move()

func _random_tile_offset() -> Vector2:
	return Vector2(
		randf_range(min_position_offset, max_position_offset) * [-1, 1].pick_random(),
		randf_range(min_position_offset, max_position_offset) * [-1, 1].pick_random()
	)

func die() -> void:
	grid.vacate(grid_row, grid_col)
	queue_free()


func _on_screen_exited() -> void:
	grid.vacate(grid_row, grid_col)
	queue_free()
