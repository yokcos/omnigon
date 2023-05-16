extends FishticuffsFish


const tex_bullet = preload("res://fishticuffs/projectiles/bullet.png")


func _ready() -> void:
	advance_timer($attacc, randf()*2)

func _on_attacc_timeout() -> void:
	$fsm/idle.set_state("attacc")

func _on_attacc_activated() -> void:
	deploy_bullet( Vector2(150, 0), tex_bullet, $barrel.position )
	GlobalSound.play_random_sfx_2d( GlobalSound.sfx_fc_shoot, global_position )
