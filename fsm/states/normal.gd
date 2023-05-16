extends State


export (String) var still_animation = "idle"
export (String) var run_animation = "run"

var has_ladder: bool = true
var time_since_movement: float = 0


func _enter() -> void:
	._enter()
	
	time_since_movement = 0

func _step(delta: float) -> void:
	._step(delta)
	
	time_since_movement += delta
	
	move_normally(delta)
	
	if Input.is_action_pressed("move_up"):
		if father.cling_to_ladder(true):
			has_ladder = true
	if Input.is_action_pressed("move_down"):
		if father.cling_to_ladder(false):
			has_ladder = true

func _handle_input(event: InputEvent) -> void:
	if father.is_controlled:
		if father.is_grounded():
			has_ladder = true
		else:
			time_since_movement = 0
		
		if event.is_action_pressed("jump"):
			if father.is_grounded():
				father.coyote_enabled = false
				father.velocity.x *= 1.35
				father.jump()
				
				var new_sfx: SFX = GlobalSound.play_random_sfx(GlobalSound.sfx_jump)
				new_sfx.relative_volume = rand_range(0.4, 0.8)
			if father.submerged:
				father.jump()
				
				var new_sfx: SFX = GlobalSound.play_random_sfx(GlobalSound.sfx_jump)
				new_sfx.randomise_pitch(.4, .6)
				new_sfx.relative_volume = rand_range(0.4, 0.5)
		
		if event.is_action_pressed("attack"):
			if PlayerStats.has_hat("fishing"):
				father.fish()
			else:
				set_state("attacc")
		
		if event.is_action_pressed("shift"):
			if Input.is_action_pressed("move_up") and PlayerStats.check_upgrade("arrow_ladder") and has_ladder:
				var arrow: Projectile = load("res://projectiles/arrow_ladder.tscn").instance()
				arrow.exceptions.append(father)
				Game.deploy_instance(arrow, father.global_position)
				father.velocity.y = min(father.velocity.y, 0)
				has_ladder = false
			else:
				if PlayerStats.eyes == PlayerStats.EYES_SHAPESHIFTER:
					set_state("shift")


func move_normally(delta: float):
	if father.is_controlled and !Game.popup_exists():
		player_tractutate(delta)
	else:
		auto_tractutate(delta)
	
	var animator = get_animator()
	if animator:
		if abs(father.velocity.x) > 10:
			animator.play(run_animation)
		else:
			animator.play(still_animation)

func auto_tractutate(delta: float):
	pass

func player_tractutate(delta: float):
	var move_direction: float = 0
	
	if Input.is_action_pressed("move_left"):
		move_direction -= 1
	if Input.is_action_pressed("move_right"):
		move_direction += 1
	
	if move_direction > 0:
		father.flipped = false
	if move_direction < 0:
		father.flipped = true
	father.accelerate(move_direction, delta)
	
	if move_direction != 0:
		time_since_movement = 0
