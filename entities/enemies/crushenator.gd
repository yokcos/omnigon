extends Enemy


func get_shifted():
	var obj_enemy = load("res://entities/enemies/chandeloser.tscn")
	var new_enemy = obj_enemy.instance()
	Game.deploy_instance_instant(new_enemy, global_position)
	if new_enemy.has_node("fsm"):
		new_enemy.get_node("fsm").set_state_string($fsm.state_name)
	queue_free()


func _on_fallen_entered() -> void:
	$textor.highlight_distance = 0
	gravity_active = true
