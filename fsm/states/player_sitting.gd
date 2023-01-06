extends State


var flipped: bool = false

func _enter():
	._enter()
	
	father.can_flip = false

func _step(delta: float):
	._step(delta)
	
	father.set_flip(flipped)

func _exit():
	._exit()
	father.reset_flippability()
