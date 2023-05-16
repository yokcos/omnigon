extends FishticuffsFish


var shooting: bool = false

const tex_bullet = preload("res://fishticuffs/projectiles/bullet_square.png")


func _ready() -> void:
	advance_timer($attacc, randf()*5)


func _on_attacc_timeout() -> void:
	$fsm/idle.set_state("pre_attacc")

func _on_attacc_entered() -> void:
	shooting = true
	
	GlobalSound.play_random_sfx_2d( GlobalSound.sfx_fc_angler, global_position )

func _on_attacc_exited() -> void:
	shooting = false

func _on_shoot_timeout() -> void:
	if shooting:
		var vel = Vector2(0, -150).rotated( 0.3*sin(age*4) )
		var new_bullet = deploy_bullet( vel, tex_bullet, $barrel.position )
		new_bullet.acceleration = Vector2(0, 100)
