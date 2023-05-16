extends Sprite

var next = null
var prev = null
var spacing = Vector2(0, -10)
var max_speed = 60


var tex_normal = preload("res://fishticuffs/chain.png")


func _process(delta):
	delta = min(delta, 0.1)
	
	if is_instance_valid(next) and delta > 0:
		var target_pos = next.global_position + spacing
		
		global_position.x = lerp(global_position.x, target_pos.x, delta*12)
		global_position.y = lerp(global_position.y, target_pos.y, delta*12)
