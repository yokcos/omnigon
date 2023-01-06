extends Sprite


export (float) var animation_speed = 10

var current_frame: float = 0

signal finished


func _process(delta: float) -> void:
	current_frame += delta*animation_speed
	
	if current_frame >= hframes*vframes:
		emit_signal("finished")
		queue_free()
	else:
		frame = int(current_frame)


func set_frames(what: int):
	hframes = what
