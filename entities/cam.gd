extends Camera2D


var target_offset: Vector2 = Vector2()


func _ready() -> void:
	Game.gameholder.connect("screen_scale_changed", self, "_on_screen_scale_changed")
	var screen_scale = 1/Game.gameholder.screen_scale
	zoom = Vector2( screen_scale, screen_scale )

func _process(delta: float) -> void:
	offset = offset.linear_interpolate(target_offset, delta*5)
	if (offset - target_offset).length_squared() < 1:
		offset = target_offset
	
	#global_position = global_position.round()


func get_actual_position() -> Vector2:
	var halfsize = get_viewport().size/2
	var pos = get_camera_position()
	
	pos.x = max(pos.x, get_limit(MARGIN_LEFT ) + halfsize.x)
	pos.x = min(pos.x, get_limit(MARGIN_RIGHT) - halfsize.x)
	
	pos.y = max(pos.y, get_limit(MARGIN_TOP   ) + halfsize.y)
	pos.y = min(pos.y, get_limit(MARGIN_BOTTOM) - halfsize.y)
	
	return pos


func _on_screen_scale_changed(what: float):
	var screen_scale = 1/what
	zoom = Vector2( screen_scale, screen_scale )
