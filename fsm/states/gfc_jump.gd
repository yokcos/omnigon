extends State


export (float) var duration = 3
export (float) var freeze_time = 2
export (float) var target_height = 128
var frozen: bool = false


func _enter():
	._enter()
	father.gravity_active = false
	frozen = false

func _step(delta: float):
	._step(delta)
	
	var diff = target_height - father.global_position.y
	father.global_position.y += diff * delta * 2
	
	if is_instance_valid(father.target):
		if !frozen and age >= freeze_time:
			frozen = true
			father.target.time_freeze(duration - freeze_time)
		
		var endpoint = 0.5 * (freeze_time + duration)
		var ratio = 1 - (age / endpoint)
		ratio = clamp(ratio, 0, 1)
		if ratio > 0:
			ratio = pow(ratio, .5)
		var dir = sign(father.target.global_position.x - father.global_position.x)
		father.accelerate(dir, delta*2*ratio)
	
	if age >= duration:
		set_state(auto_proceed)

func _exit():
	._exit()
	father.gravity_active = true
