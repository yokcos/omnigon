extends State


export (String) var idle_animation = ""
export (String) var walk_animation = ""

export (float) var pause_duration = 1
var pause_time = pause_duration
var target: Node2D = null
var direction: int = 0


func _enter():
	._enter()
	
	pause_time = pause_duration

func _step(delta: float):
	._step(delta)
	
	pause_time -= delta
	var roll = randf()
	
	var animator = get_animator()
	if animator:
		if pause_time <= 0:
			animator.play(walk_animation)
		else:
			animator.play(idle_animation)
	if is_instance_valid(target):
		var dir = sign(target.global_position.x - father.global_position.x)
		if dir == direction:
			if pause_time <= 0:
				father.accelerate(dir, delta)
		else:
			pause_time = pause_duration
			direction = dir
