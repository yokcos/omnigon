extends Projectile


const obj_ladder: PackedScene = preload("res://props/ladder.tscn")

var max_length: int = 4


func _ready() -> void:
	velocity = Vector2(0, -512)
	GlobalSound.play_random_sfx_2d( GlobalSound.sfx_arrow_ladder, global_position )


func get_length() -> int:
	var spacing: float = 32
	var length: int
	if $ray.is_colliding():
		length = ($ray.get_collision_point() - global_position).y
		length = int(length / spacing)
		length = int( min(length, max_length) )
	else:
		length = max_length
	return length


func _on_body_entered(body):
	._on_body_entered(body)
	
	if !body in exceptions:
		GlobalSound.play_random_sfx_2d( GlobalSound.sfx_arrow_ladder_reverse, global_position )
		
		var langth = get_length()
		var new_ladder = obj_ladder.instance()
		var pos = $ray.global_position
		pos = (pos/16).round() * 16
		new_ladder.length = langth
		new_ladder.decay_rate = 1
		Game.deploy_instance(new_ladder, pos)
		
		queue_free()
