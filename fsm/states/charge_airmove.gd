extends "res://fsm/states/charge.gd"


export (float) var air_speed = 0.5


func _step(delta: float):
	if air_speed > 0 and !father.is_grounded():
		var dir = get_move_direction()
		var this_target: float = dir * father.speed * air_speed
		
		var relative_velocity = this_target - father.velocity.x
		father.accelerate(sign(relative_velocity), delta)
	
	._step(delta)


func get_move_direction():
	var move_direction: float = 0
	
	if Input.is_action_pressed("move_left"):
		move_direction -= 1
	if Input.is_action_pressed("move_right"):
		move_direction += 1
	
	return move_direction
