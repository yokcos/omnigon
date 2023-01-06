extends Enemy


var float_offset: Vector2 = Vector2()
var father: Entity = null
var angle: float = PI/2
var fulcrum: Node2D
var barrel: Node2D

const obj_bullet = preload("res://projectiles/bullet.tscn")

const obj_particles = preload("res://fx/part_orangegreen_slam.tscn")


func _ready() -> void:
	fulcrum = $flippable/rotatable
	barrel = $flippable/rotatable/barrel
	
	saving_enabled = false

func _process(delta: float) -> void:
	if is_instance_valid(father):
		var target_position = father.global_position + float_offset
		velocity = (target_position - global_position) * speed / 20
	else:
		can_bounce = true
	
	fulcrum.rotation = lerp_angle(fulcrum.rotation, angle, delta * 5)


func shoot(speed: float, dir: float = 0):
	var new_bullet = obj_bullet.instance()
	
	Game.deploy_instance(new_bullet, barrel.global_position)
	new_bullet.velocity = barrel.global_transform.x.rotated(deg2rad(dir)) * speed

func deploy_particles():
	var new_particles = obj_particles.instance()
	
	Game.deploy_instance(new_particles, barrel.global_position)
	new_particles.rotation = barrel.global_rotation

