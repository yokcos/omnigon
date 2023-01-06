extends "res://fsm/states/bouncer_boing.gd"


func _step(delta):
	._step(delta)
	
	if father.velocity.y > 0:
		set_state(auto_proceed)
