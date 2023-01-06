extends Sprite


export (float) var duration = 2
export (float) var flash_time = 1

export (Vector2) var velocity = Vector2(0, -64)
export (float) var friction = 3


func _process(delta: float) -> void:
	duration -= delta
	
	if duration <= flash_time:
		if fmod(duration, 0.2) < 0.1:
			hide()
		else:
			show()
	
	if duration <= 0:
		queue_free()
	
	
	position += velocity * delta
	velocity -= velocity * friction * delta
