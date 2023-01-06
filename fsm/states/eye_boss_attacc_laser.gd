extends State


export (float) var charge_time = 1
export (float) var duration = 5

var sfx: SFX2D = null


func _enter():
	._enter()
	
	father.position_hands([0, 1], Vector2(56, -16))
	father.rotate_hands([0, 1], 1)
	father.following_player = false
	father.flashing_pupil = true
	father.pupil_target = Vector2(0, 24)
	
	var new_sfx: SFX2D = GlobalSound.play_random_sfx_2d(GlobalSound.sfx_eyesaac_charge, father.global_position)
	new_sfx.max_distance = 600

func _step(delta: float):
	._step(delta)
	
	if father.target:
		var target_velocity: Vector2 = Vector2()
		
		var relative: float = father.target.global_position.x - father.global_position.x
		target_velocity.x = sign(relative) * 80
		father.velocity = father.velocity.linear_interpolate(target_velocity, delta * 5)
	
	if is_time_now(charge_time, delta):
		father.shoot_laser()
		
		sfx = GlobalSound.play_random_sfx_2d(GlobalSound.sfx_eyesaac_laser, father.global_position)
		sfx.max_distance = 600
		var new_sfx: SFX2D = GlobalSound.play_random_sfx_2d(GlobalSound.sfx_eyesaac_laser_shoot, father.global_position)
		new_sfx.max_distance = 600
	
	if age >= duration:
		set_state(auto_proceed)

func _exit():
	._exit()
	
	father.reset_hands()
	father.cull_laser()
	father.following_player = true
	father.flashing_pupil = false
	
	if sfx:
		sfx.queue_free()
		sfx = null
