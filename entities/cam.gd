extends Camera2D


var target_offset: Vector2 = Vector2()
var target_pos: Vector2 = Vector2()
var previous_pos: Vector2 = Vector2()
var target_global_pos: Vector2 = Vector2()
var global_pos_weight: float = 0
var base_zoom: Vector2 = Vector2(.5, .5)
var extra_zoom: float = 1
var extra_zoom_target: float = 1
var max_speed: float = 800


func _ready() -> void:
	if is_instance_valid(Game.gameholder):
		Game.gameholder.connect("screen_scale_changed", self, "_on_screen_scale_changed")
		var screen_scale = 1/Game.gameholder.screen_scale
		zoom = Vector2( screen_scale, screen_scale )

func _process(delta: float) -> void:
	if is_instance_valid(Game.get_player()):
		if global_pos_weight > 0:
			var parent_pos = get_parent().global_position
			target_pos = lerp(Vector2(), target_global_pos - parent_pos, global_pos_weight)
		
		var velocity: Vector2 = Vector2()
		var this_target: Vector2 = position.linear_interpolate(target_pos, delta*5)
		
		velocity = this_target - position
		var delta_speed: float = max_speed*delta
		if velocity.length_squared() > delta_speed*delta_speed:
			velocity = velocity.normalized() * delta_speed
		
		position += velocity
		
		if (position - target_pos).length_squared() < 1:
			position = target_pos
		
		
		offset = offset.linear_interpolate(target_offset, delta*2)
	
	if abs(extra_zoom - extra_zoom_target) > .001:
		set_extra_zoom( lerp( extra_zoom, extra_zoom_target, delta*5 ) )


func get_actual_position() -> Vector2:
	if is_inside_tree():
		var gh = Game.gameholder
		var halfsize = get_viewport().size/2/gh.screen_scale
		var pos = get_camera_position()
		
		pos.x = max(pos.x, get_limit(MARGIN_LEFT ) + halfsize.x)
		pos.x = min(pos.x, get_limit(MARGIN_RIGHT) - halfsize.x)
		
		pos.y = max(pos.y, get_limit(MARGIN_TOP   ) + halfsize.y)
		pos.y = min(pos.y, get_limit(MARGIN_BOTTOM) - halfsize.y)
		
		previous_pos = pos
		return pos
	return previous_pos

func get_visible_rect():
	var gh: Node2D = Game.gameholder
	var vp: Viewport = get_viewport()
	
	if gh:
		var actual_size = vp.size / gh.screen_scale
		return Rect2(get_actual_position() - actual_size/2, actual_size)


func set_extra_zoom(what: float):
	extra_zoom = what
	zoom = base_zoom * extra_zoom


func _on_screen_scale_changed(what: float):
	var screen_scale = 1/what
	zoom = Vector2( screen_scale, screen_scale )
