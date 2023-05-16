extends FishticuffsFish


const tex_bullet = preload("res://fishticuffs/projectiles/bullet_pointy.png")


func _ready() -> void:
	advance_timer($attacc, randf()*3)

func _on_attacc_timeout() -> void:
	$fsm/idle.set_state("attacc")

func _on_attacc_activated() -> void:
	var new_bullet
	new_bullet = deploy_bullet( Vector2(0, 100), tex_bullet, Vector2(0, 8) )
	new_bullet.rotation = PI/2
	new_bullet = deploy_bullet( Vector2(0, -100), tex_bullet, Vector2(0, -8) )
	new_bullet.rotation = -PI/2
	GlobalSound.play_random_sfx_2d( GlobalSound.sfx_fc_shoot, global_position )
