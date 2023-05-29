extends "res://projectiles/rocket.gd"


const obj_rocket = preload( "res://projectiles/rocket.tscn" )


func launch_rocket( target: Node2D = null, offset_degrees: float = 0 ):
	var rocket_speed = 40
	var rocket_acceleration = 300
	var dir: Vector2 = target.global_position - global_position
	dir = dir.normalized()
	dir = dir.rotated( deg2rad(offset_degrees) )
	
	var new_rocket = obj_rocket.instance()
	new_rocket.velocity = dir * rocket_speed
	new_rocket.acceleration = dir * rocket_acceleration
	Game.deploy_instance( new_rocket, global_position )


func _on_stop_timer_timeout() -> void:
	velocity = Vector2()
	acceleration = Vector2()
	$relaunch_timer.start()

func _on_relaunch_timer_timeout() -> void:
	var player = Game.get_player()
	if is_instance_valid(player):
		for i in [-1, 0, 1]:
			launch_rocket( player, i*20 )
	explode()
