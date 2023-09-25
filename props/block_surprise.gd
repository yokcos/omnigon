extends StaticBody2D


export (PackedScene) var loot = null

export (Vector2) var launch_velocity = Vector2()
export (float) var launch_speed_range = 0
export (float) var launch_angle_range = 0

var injured: bool = false

const obj_particulation = preload("res://fx/part_woodflakes.tscn")


func _ready() -> void:
	hide()


func appear():
	show()
	$hitbox.disabled = false

func get_punched():
	if injured:
		die()

func die():
	var new_particulation = obj_particulation.instance()
	Game.deploy_instance(new_particulation, global_position)
	
	if loot:
		var new_loot = loot.instance()
		Game.deploy_instance(new_loot, global_position)
		
		if launch_velocity != Vector2():
			var base_speed = launch_velocity.length()
			var speed = rand_range( base_speed - launch_speed_range, base_speed + launch_speed_range )
			
			var base_angle = launch_velocity.angle()
			var angle_range = deg2rad(launch_angle_range)
			var angle = rand_range( base_angle - angle_range, base_angle + angle_range )
			
			var velocity = Vector2(speed, 0).rotated(angle)
			
			if new_loot is RigidBody2D:
				new_loot.apply_central_impulse(velocity)
			else:
				new_loot.velocity = velocity
	
	queue_free()


func get_shifted():
	injured = !injured
	
	$sprite.frame = 1 if injured else 0
	
	if injured:
		var new_particulation = obj_particulation.instance()
		Game.deploy_instance(new_particulation, global_position)

func _on_entity_detector_activated() -> void:
	appear()
