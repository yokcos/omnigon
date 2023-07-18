extends "res://projectiles/bullet.gd"


var hat: Hat = null setget set_hat
var father: Entity = null
var rotation_speed = rand_range(-7, 7)
var break_script: GDScript = null

const obj_dropped_hat = preload("res://entities/dropped_hat.tscn")


func _process(delta: float) -> void:
	$sprite.rotation += rotation_speed * delta


func set_hat(what: Hat):
	hat = what
	
	$sprite.texture = what.sprite
	$sprite.hframes = what.small_frames
	damage = what.damage

func die():
	var new_dropped_hat = obj_dropped_hat.instance()
	new_dropped_hat.leap()
	new_dropped_hat.hat = hat
	Game.deploy_instance(new_dropped_hat, global_position - velocity * 0.02)
	
	.die()
