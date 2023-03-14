extends State


var dir: int = 0


func _enter():
	._enter()
	
	dir = father.flip_int

func _step(delta: float):
	._step(delta)
	
	if dir == 0:
		set_state(auto_proceed)
	else:
		father.accelerate(dir, delta)
