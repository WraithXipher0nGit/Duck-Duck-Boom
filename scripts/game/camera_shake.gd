extends Camera2D

@export var target: NodePath
@export var shake_intensity: float = 12.0
@export var shake_duration: float = 0.3

var _is_shaking: bool = false


func _process(_delta: float) -> void:
	var t = get_node_or_null(target)
	if t:
		global_position.y = t.global_position.y


func shake(intensity: float = -1.0, duration: float = -1.0) -> void:
	if _is_shaking:
		return
	
	# Use defaults if not specified
	if intensity < 0:
		intensity = shake_intensity
	if duration < 0:
		duration = shake_duration
	
	_is_shaking = true
	var elapsed = 0.0
	
	while elapsed < duration:
		offset = Vector2(
			randf_range(-intensity, intensity),
			randf_range(-intensity, intensity)
		)
		await get_tree().process_frame
		elapsed += get_process_delta_time()
	
	offset = Vector2.ZERO
	_is_shaking = false
