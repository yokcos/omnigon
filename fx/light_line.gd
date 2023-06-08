extends Path2D


export (float) var dot_spacing = 6
export (float) var spacing = 24
export (Color) var dot_colour = Color("5b3138")

const obj_light = preload("res://fx/minor_light.tscn")


func activate():
	deploy_dots()
	deploy_lights()

func deploy_dots():
	var proggers: float = dot_spacing/2
	var length = curve.get_baked_length()
	
	while proggers < length:
		
		var new_dot = Polygon2D.new()
		add_child(new_dot)
		new_dot.polygon = PoolVector2Array([Vector2.LEFT, Vector2.DOWN, Vector2.RIGHT, Vector2.UP])
		new_dot.position = curve.interpolate_baked(proggers)
		new_dot.color = dot_colour
		
		proggers += dot_spacing

func deploy_lights():
	var proggers: float = spacing/2
	var length = curve.get_baked_length()
	
	var i: int = 0
	while proggers < length:
		
		var new_light = obj_light.instance()
		add_child(new_light)
		new_light.actual_frame = (i + get_index()) % 2
		new_light.position = curve.interpolate_baked(proggers)
		
		proggers += spacing
		i += 1
