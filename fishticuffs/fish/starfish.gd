extends FishticuffsFish


const tex_bullet = preload("res://fishticuffs/projectiles/bullet_pointy.png")
const tex_bullet_hollow = preload("res://fishticuffs/projectiles/bullet_hollow.png")


func _ready() -> void:
	advance_timer($attacc, randf()*7)

func perform_attack(which: int):
	var dir = Vector2(0, -1).rotated( PI*2/5 * which )
	var angle_vec = dir
	angle_vec.x *= flip_int
	var angle = angle_vec.angle()
	
	var new_bullet
	new_bullet = deploy_bullet( dir*100, tex_bullet, dir*8 )
	new_bullet.rotation = angle
	new_bullet = deploy_bullet( dir*100, tex_bullet_hollow, dir*8 )
	new_bullet.acceleration = -angle_vec*100
	
	GlobalSound.play_random_sfx_2d( GlobalSound.sfx_fc_shoot, global_position )

func _on_attacc_timeout() -> void:
	$fsm/idle.set_state("attacc")

