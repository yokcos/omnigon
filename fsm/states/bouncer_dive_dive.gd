extends "res://fsm/states/charge.gd"


var speed: float = 800


func _enter():
	._enter()
	
	acceleration = 0
	father.gravity_active = false

func _exit():
	._exit()
	father.gravity_active = true

func _step(delta):
	._step(delta)
	
	if father.is_on_floor() and recovering:
		set_state(auto_proceed)


func activate():
	.activate()
	
	target_velocity = Vector2(0, speed)
	acceleration = 5
