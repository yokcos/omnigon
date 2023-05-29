extends Projectile


const obj_explosion = preload("res://fx/explosion.tscn")
const fx_smoke = preload("res://fx/smoke.tscn")


func _ready() -> void:
	damage = 0
	
	var new_smoke = fx_smoke.instance()
	add_child(new_smoke)

func _process(delta: float):
	if velocity.length_squared() > 10:
		var dir = velocity.angle()
		$sprite.rotation = dir


func hit(what: Being):
	.hit(what)
	
	explode()

func explode():
	var new_explosion = obj_explosion.instance()
	Game.deploy_instance(new_explosion, global_position)
	queue_free()


func _on_wall_detector_activated() -> void:
	explode()
