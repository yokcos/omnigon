extends "res://projectiles/bullet.gd"


var father: Node2D = null
var retreating: bool = false
var return_range: float = 32

const obj_bullet = preload("res://projectiles/bullet.tscn")

signal returned


func _ready():
	penetrations = 1000000
	duration = 1000000
	thru_walls = true

func _process(delta: float) -> void:
	if retreating:
		retreat(delta)


func retreat(delta: float):
	if is_instance_valid(father):
		var acc = 500
		var relative = father.global_position - global_position
		var dir = relative.normalized()
		velocity += acc * dir * delta
		
		velocity -= velocity * delta
		
		if relative.length_squared() <= return_range*return_range:
			emit_signal("returned")
			queue_free()


func _on_timer_timeout() -> void:
	retreating = true

func _on_shoot_timer_timeout() -> void:
	var new_bullet = obj_bullet.instance()
	new_bullet.acceleration = Vector2(0, 25)
	Game.deploy_instance(new_bullet, global_position)
