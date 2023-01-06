extends "res://projectiles/bullet.gd"


const obj_particles = preload("res://fx/part_orangegreen_slam_narrow.tscn")


func _exit_tree() -> void:
	var new_particles = obj_particles.instance()
	var back_vector: Vector2 = -global_transform.x
	back_vector.y -= 0.3
	var dir: float = back_vector.angle()
	new_particles.rotation = dir
	
	Game.deploy_instance(new_particles, global_position + Vector2(0, -16))
