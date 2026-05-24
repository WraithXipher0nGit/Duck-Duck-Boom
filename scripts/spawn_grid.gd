extends Node2D

const COLS: int = 7
const ROWS_VISIBLE: int = 4
const TILE_SIZE: float = 1920.0 / 7.0  # ≈ 274

const GRID_ORIGIN: Vector2 = Vector2(-3.0 * TILE_SIZE, -1.5 * TILE_SIZE)

@export var debug_draw: bool = true
@export var draw_extent_rows: int = 6

var _occupancy: Dictionary = {}
var _safe_path: Dictionary = {}


func _ready() -> void:
	add_to_group("spawn_grid")



func is_tile_free(row: int, col: int) -> bool:
	if col < 0 or col >= COLS:
		return false
	
	return not _occupancy.has(Vector2i(row, col))


func occupy(row: int, col: int, entity: Node) -> void:
	_occupancy[Vector2i(row, col)] = entity


func vacate(row: int, col: int) -> void:
	_occupancy.erase(Vector2i(row, col))


func get_entity_at(row: int, col: int) -> Node:
	return _occupancy.get(Vector2i(row, col), null)



func tile_to_world(row: int, col: int) -> Vector2:
	return GRID_ORIGIN + Vector2(col * TILE_SIZE, row * TILE_SIZE)


func world_to_tile(world_pos: Vector2) -> Vector2i:
	var local = world_pos - GRID_ORIGIN
	return Vector2i(int(local.y / TILE_SIZE), int(local.x / TILE_SIZE))


func get_cols() -> int:
	return COLS


func generate_safe_path_for_rows(row_start: int, row_end: int, path_width: int = 1):
	var current_col = randi_range(0, COLS - 1)
	
	for row in range(row_start, row_end):
		current_col = clamp(current_col + randi_range(-1, 1), 0, COLS - 1)
		for w in range(path_width):
			var col = clamp(current_col + w, 0, COLS - 1)
			_safe_path[Vector2i(row, col)] = true


func is_safe_tile(row: int, col: int) -> bool:
	return _safe_path.has(Vector2i(row, col))


func _process(_delta: float) -> void:
	if debug_draw:
		queue_redraw()


func _draw() -> void:
	if not debug_draw:
		return
	
	var line_color = Color(1, 1, 1, 0.3)
	var occupied_color = Color(1, 0.5, 0.5, 0.4)
	var empty_color = Color(0.5, 1, 0.5, 0.1)
	var safe_color = Color(0.5, 0.5, 1, 0.2)
	
	var camera = get_viewport().get_camera_2d()
	var camera_row = 0
	if camera:
		camera_row = world_to_tile(camera.global_position).x
	
	for row in range(camera_row - draw_extent_rows, camera_row + draw_extent_rows + 1):
		for col in range(COLS):
			var tile_pos = tile_to_world(row, col) - global_position
			var rect = Rect2(
				tile_pos - Vector2(TILE_SIZE, TILE_SIZE) / 2,
				Vector2(TILE_SIZE, TILE_SIZE)
			)
			
			if _occupancy.has(Vector2i(row, col)):
				draw_rect(rect, occupied_color, true)
			elif _safe_path.has(Vector2i(row, col)):
				draw_rect(rect, safe_color, true)
			else:
				draw_rect(rect, empty_color, true)
			
			draw_rect(rect, line_color, false, 2.0)
			
			var label = "(%d, %d)" % [row, col]
			draw_string(
				ThemeDB.fallback_font,
				tile_pos + Vector2(-30, -50),
				label,
				HORIZONTAL_ALIGNMENT_LEFT,
				-1,
				14,
				Color(1, 1, 1, 0.5)
			)
