extends "res://fsm/states/stunned.gd"


var pendulum_height: float = 48
var move_speed: float = 100


func _enter():
	._enter()
	
	move_speed = 100

func _step(delta: float):
	._step(delta)
	
	if is_instance_valid(father.target):
		var relative_x = father.target.global_position.x - father.global_position.x
		var target: Vector2 = Vector2(relative_x, -pendulum_height)
		father.move_target_toward(target, delta, move_speed)
	
	if age >= duration * 0.75:
		father.change_target_sprite(2)
		move_speed = 5
