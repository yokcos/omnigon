extends "res://fsm/states/patrol_air.gd"


export (float) var attack_period = 3

var attack_time = attack_period


func _enter():
	._enter()
	
	attack_time = attack_period

func _step(delta: float):
	._step(delta)
	
	attack_time -= delta
	if attack_time <= 0:
		attack_time = attack_period
		perform_action(attack_state)
