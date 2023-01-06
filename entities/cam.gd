extends Camera2D


var target_offset: Vector2 = Vector2()


func _process(delta: float) -> void:
	offset = offset.linear_interpolate(target_offset, delta*5)
	if (offset - target_offset).length_squared() < 1:
		offset = target_offset
	
	#global_position = global_position.round()


func get_actual_position() -> Vector2:
	var halfsize = Vector2(256, 128)
	var pos = get_camera_position()
	
	pos.x = max(pos.x, get_limit(MARGIN_LEFT ) + halfsize.x)
	pos.x = min(pos.x, get_limit(MARGIN_RIGHT) - halfsize.x)
	
	pos.y = max(pos.y, get_limit(MARGIN_TOP   ) + halfsize.y)
	pos.y = min(pos.y, get_limit(MARGIN_BOTTOM) - halfsize.y)
	
	return pos
