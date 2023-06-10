extends "res://projectiles/bullet.gd"


func _ready() -> void:
	target_teams = [1]
	duration = 20
	acceleration = Vector2(0, 50)

func _process(delta: float) -> void:
	for this_ray in [$ray0, $ray1, $ray2, $ray3]:
		if this_ray.is_colliding():
			bounce(-this_ray.cast_to.normalized())
	$sprite.flip_h = velocity.x < 0


func bounce(normal: Vector2):
	var speediness: float = velocity.dot(normal)
	if speediness < 0:
		velocity -= speediness * normal * 2
