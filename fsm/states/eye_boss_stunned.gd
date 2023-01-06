extends "res://fsm/states/stunned.gd"


func _enter():
	._enter()
	
	father.following_player = false

func _step(delta: float):
	._step(delta)
	
	father.pupil_target = Vector2(0, 24).rotated(age*6)

func _exit():
	._exit()
	
	father.following_player = true
