extends Label


var duration: float = 3
var speed: float = 12


func _process(delta: float) -> void:
	rect_position.y -= speed * delta
	
	duration -= delta
	visible = !(duration < 1 and fmod(duration, 0.2) < 0.1)
	if duration <= 0 or text == "":
		queue_free()
