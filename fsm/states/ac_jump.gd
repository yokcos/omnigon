extends State


func _step(delta: float):
	._step(delta)
	
	father.accelerate(father.flip_int, delta)
	
	if father.is_grounded():
		set_state(auto_proceed)
