extends Label


var base_position: Vector2 = Vector2()
var has_repositioned: bool = false
var target_vertices = 0
var display_vertices = 0
var scroll_speed: float = 20

const col_base = Color("df3e23")
const col_bright = Color("f9a31b")


func _ready() -> void:
	PlayerStats.connect("vertices_changed", self, "_on_vertices_changed")
	target_vertices = PlayerStats.vertices
	set_value(PlayerStats.vertices)
	
	Events.connect("instant_money_change", self, "_on_instant_money_change")

func _process(delta: float) -> void:
	if !has_repositioned:
		has_repositioned = true
		base_position = rect_position
	
	rect_position = rect_position.linear_interpolate(base_position, delta*5)
	rect_rotation = lerp(rect_rotation, 0, delta*5)
	
	if display_vertices != target_vertices:
		var diff = target_vertices - display_vertices
		var dir = sign(diff)
		var this_change = scroll_speed * delta
		
		display_vertices += dir * this_change
		set_value(display_vertices)
		shake()
		
		if abs(diff) <= this_change:
			display_vertices = target_vertices
			$timer.stop()
			$timer.start()


func set_value(what: float):
	var value = round(what)
	if what <= 0 and what > -.5:
		value = abs(value)
	var s_value: String = str(value)
	s_value = s_value.pad_zeros(4)
	text = s_value
	display_vertices = what

func shake():
	add_color_override("font_color", col_bright)
	rect_position += Vector2(5, 0).rotated(randf()*PI*2)
	rect_rotation += rand_range(-10, 10)


func _on_vertices_changed(what: float):
	target_vertices = what

func _on_timer_timeout() -> void:
	add_color_override("font_color", col_base)

func _on_instant_money_change():
	display_vertices = PlayerStats.vertices
	target_vertices = PlayerStats.vertices
