extends Projectile


const obj_ladder: PackedScene = preload("res://props/ladder.tscn")

var max_length: int = 4


func _ready() -> void:
	velocity = Vector2(0, -512)


func get_length() -> int:
	var spacing: float = 32
	var length: int = ($ray.get_collision_point() - global_position).y
	length = int(length / spacing)
	length = min(length, max_length)
	return length


func _on_body_entered(body):
	._on_body_entered(body)
	
	if !body in exceptions:
		var langth = get_length()
		var new_ladder = obj_ladder.instance()
		var pos = global_position
		pos.y += 8
		pos = (pos/16).round() * 16
		new_ladder.length = langth
		new_ladder.decay_rate = 1
		Game.deploy_instance(new_ladder, pos)
		
		queue_free()
