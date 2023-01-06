extends StaticBody2D


const obj_bullet = preload("res://projectiles/bullet.tscn")


func get_shifted():
	for i in range(8):
		var new_bullet = obj_bullet.instance()
		var dir = Vector2(1, 0).rotated(i * PI/4)
		
		new_bullet.acceleration = dir * 100
		
		Game.deploy_instance(new_bullet, global_position + dir * 8)
	
	GlobalSound.play_random_sfx_2d(GlobalSound.sfx_blap, global_position)
	GlobalSound.play_random_sfx_2d(GlobalSound.sfx_blap, global_position)
	GlobalSound.play_random_sfx_2d(GlobalSound.sfx_blap, global_position)
	
	queue_free()
