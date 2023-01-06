extends Enemy


func _process(delta: float) -> void:
	position_anchor()


func position_anchor():
	if $anchorfinder.is_colliding():
		$anchor.global_position = $anchorfinder.get_collision_point()

func fall():
	$floorfinder.enabled = true
	
	$floorfinder.force_raycast_update()
	if $floorfinder.is_colliding():
		global_position = $floorfinder.get_collision_point() + Vector2(0, -16)
		$fsm.set_state_string("fallen")
	
	$floorfinder.enabled = false
	
	Game.shake_cam_random(8)

func get_shifted():
	var obj_enemy = load("res://entities/enemies/crushenator.tscn")
	var new_enemy = obj_enemy.instance()
	Game.deploy_instance_instant(new_enemy, global_position)
	if new_enemy.has_node("fsm"):
		new_enemy.get_node("fsm").set_state_string($fsm.state_name)
	queue_free()


func _on_timer_timeout() -> void:
	if $fsm.state_name == "idle":
		fall()

func _on_fallen_entered() -> void:
	gravity_active = true
