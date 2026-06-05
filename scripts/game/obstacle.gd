extends Area2D

var grid_row: int = 0
var grid_col: int = 0

@onready var grid: Node = get_tree().get_first_node_in_group("spawn_grid")
@onready var notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D


func _ready() -> void:
	if grid == null:
		push_error("Obstacle couldn't find spawn_grid")
		return
	
	add_to_group("obstacles")
	notifier.screen_exited.connect(_on_screen_exited)
	
	grid.occupy(grid_row, grid_col, self)
	global_position = grid.tile_to_world(grid_row, grid_col)


func _on_screen_exited() -> void:
	grid.vacate(grid_row, grid_col)
	queue_free()
