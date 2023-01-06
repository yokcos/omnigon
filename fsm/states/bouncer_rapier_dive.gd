extends "res://fsm/states/charge.gd"


var speed: float = 400
var base_friction: float = 10


func _enter():
	._enter()
	
	acceleration = 0
	father.gravity_active = false
	base_friction = father.friction

func _exit():
	._exit()
	father.gravity_active = true
	father.friction = base_friction

func _step(delta):
	._step(delta)
	
	if father.is_on_floor() and recovering:
		set_state(auto_proceed)


func activate():
	.activate()
	
	father.friction = 0
	father.reset_flippability()
	var players: Array = get_tree().get_nodes_in_group("players")
	if players.size() > 0:
		var target: Being = players[0]
		
		var dir = (target.global_position - father.global_position).normalized()
		if dir.y < 0 or abs(dir.x) > abs(dir.y)*3:
			set_state("idle")
		else:
			target_velocity = dir * speed
			acceleration = 5
