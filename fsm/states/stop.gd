extends State


func _step(delta: float) -> void:
	._step(delta)
	
	father.velocity -= father.velocity * delta*5
