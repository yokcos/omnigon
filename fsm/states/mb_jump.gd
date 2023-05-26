extends State


func _step(delta: float):
	._step(delta)
	
	if age > 0.1 and father.is_grounded():
		set_state(auto_proceed)
