extends RigidBody2D


var obj_bullet: PackedScene = load("res://projectiles/bullet.tscn")


func get_shifted():
	var new_bullet = obj_bullet.instance()
	new_bullet.velocity = Vector2(0, -32).rotated(rand_range(-PI/2, PI/2))
	Game.replace_instance(self, new_bullet)
