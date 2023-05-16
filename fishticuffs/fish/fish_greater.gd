extends FishticuffsFish


const tex_bullet = preload("res://fishticuffs/projectiles/bullet_pointy.png")


func _ready() -> void:
	advance_timer($attacc, randf()*3)

func _on_attacc_timeout() -> void:
	$fsm/idle.set_state("attacc")

func _on_attacc_activated() -> void:
	for x in [-1, 1]:
		for y in [-1, 1]:
			var vector = Vector2( 40*x, 100*y )
			var new_bullet = deploy_bullet( vector, tex_bullet, vector.normalized() * 8 )
			vector.x *= flip_int
			new_bullet.rotation = vector.angle()
	GlobalSound.play_random_sfx_2d( GlobalSound.sfx_fc_shoot, global_position )
