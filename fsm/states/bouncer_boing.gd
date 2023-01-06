extends State


export (Vector2) var force = Vector2(100, -200)


func _enter():
	._enter()
	
	if !father.is_on_floor():
		set_state("idle")
		return false
	
	father.can_flip = false
	
	var target: Being = null
	var players = get_tree().get_nodes_in_group("players")
	if players.size() > 0:
		target = players[0]
	
	if target:
		father.flipped = target.global_position.x < father.global_position.x
	
	father.velocity.x += force.x * father.flip_int
	father.velocity.y += force.y

func _exit():
	._exit()
	
	father.reset_flippability()

func _step(delta):
	._step(delta)
	
	father.accelerate(father.flip_int, delta)
	
	if father.is_on_floor() and age > 0.1:
		set_state(auto_proceed)
