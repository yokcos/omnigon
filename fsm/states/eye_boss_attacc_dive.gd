extends State


export (float) var charge_time = 1



func _enter():
	._enter()
	
	father.following_player = false
	father.velocity.y = 0

func _step(delta: float):
	._step(delta)
	
	charge_time = max(charge_time, 0.1) # prevent division by 0
	var downishness = -1 + age/charge_time
	father.pupil_target = Vector2(0, 24 * downishness)
	var acceleration: float = 6000 * downishness
	if downishness < 0:
		acceleration /= 30
	father.velocity.y += acceleration * delta
	
	if is_time_now(charge_time + 0.2, delta):
		father.set_dive_sprite(true)
	
	if father.is_on_floor():
		father.slam()
		set_state(auto_proceed)
		
		var new_sfx: SFX2D = GlobalSound.play_random_sfx_2d(GlobalSound.sfx_eyesaac_slam, father.global_position)
		new_sfx.max_distance = 600
	
	if father.check_for_mattresses():
		father.velocity.y *= -0.5
		set_state(auto_proceed)

func _exit():
	._exit()
	
	father.set_dive_sprite(false)
	father.following_player = true
