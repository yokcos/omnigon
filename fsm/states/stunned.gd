extends State


export (float) var duration = 1


func _step(delta: float):
	._step(delta)
	
	if age >= duration:
		set_state(auto_proceed)
