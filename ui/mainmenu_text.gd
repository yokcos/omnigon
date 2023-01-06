extends Label


var speed = 50


func _process(delta: float) -> void:
	rect_position.x -= speed * delta
	if margin_right < 0:
		queue_free()
