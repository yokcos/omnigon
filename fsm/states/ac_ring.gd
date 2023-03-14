extends "res://fsm/states/stunned.gd"


var fx_zapfront = preload("res://fx/zapfront.tscn")


func _enter():
	._enter()
	
	for i in range(6):
		deploy_zapfront()

func _step(delta: float):
	._step(delta)
	
	if randf() * 6 < 1:
		deploy_zapfront()


func deploy_zapfront():
	if is_instance_valid(father):
		var new_zapfront = fx_zapfront.instance()
		new_zapfront.rotation = randf() * 2*PI
		var size = rand_range(1, 1.2)
		new_zapfront.scale = Vector2(size, size)
		Game.deploy_instance(new_zapfront, father.global_position)
