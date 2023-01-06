extends TextureRect


var room_position: Vector2 = Vector2() setget set_room_position
var target_position: Vector2 = Vector2()


func _process(delta: float) -> void:
	rect_position = rect_position.linear_interpolate(target_position, 10*delta)

func _gui_input(event: InputEvent) -> void:
	rect_position += Vector2(4, 0).rotated(randf()*2*PI)


func set_room_position(what: Vector2):
	room_position = what
	texture = Rooms.room_data[what]["image"]
	hint_tooltip = Rooms.room_data[what]["title"]
