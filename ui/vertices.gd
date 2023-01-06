extends Label


var base_position: Vector2 = Vector2()
var has_repositioned: bool = false

const col_base = Color("df3e23")
const col_bright = Color("f9a31b")


func _ready() -> void:
	PlayerStats.connect("vertices_changed", self, "_on_vertices_changed")

func _process(delta: float) -> void:
	if !has_repositioned:
		has_repositioned = true
		base_position = rect_position
	
	rect_position = rect_position.linear_interpolate(base_position, delta*5)


func _on_vertices_changed(what: float):
	var value = round(what)
	var s_value: String = str(value)
	s_value = s_value.pad_zeros(4)
	text = s_value
	add_color_override("font_color", col_bright)
	rect_position += Vector2(10, 0).rotated(randf()*PI*2)
	$timer.start()


func _on_timer_timeout() -> void:
	add_color_override("font_color", col_base)
