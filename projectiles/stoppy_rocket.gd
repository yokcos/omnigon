extends "res://projectiles/rocket.gd"



func _on_stop_timer_timeout() -> void:
	velocity = Vector2()
	acceleration = Vector2()
	$relaunch_timer.start()

func _on_relaunch_timer_timeout() -> void:
	var player = Game.get_player()
	if is_instance_valid(player):
		var rocket_speed = 40
		var rocket_acceleration = 400
		var dir: Vector2 = player.global_position - global_position
		dir = dir.normalized()
		
		velocity = dir * rocket_speed
		acceleration = dir * rocket_acceleration
