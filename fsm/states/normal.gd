extends State


export (String) var still_animation = "idle"
export (String) var run_animation = "run"


func _enter() -> void:
	._enter()

func _step(delta: float) -> void:
	._step(delta)
	
	move_normally(delta)

func _handle_input(event: InputEvent) -> void:
	if father.is_controlled:
		if event.is_action_pressed("jump") and father.is_grounded():
			father.coyote_enabled = false
			father.velocity.x *= 1.35
			father.jump()
			
			var new_sfx: SFX = GlobalSound.play_random_sfx(GlobalSound.sfx_jump)
			new_sfx.relative_volume = rand_range(0.4, 0.8)
		
		if event.is_action_pressed("attack"):
			set_state("attacc")
		
		if event.is_action_pressed("shift"):
			if Input.is_action_pressed("move_up") and PlayerStats.check_upgrade("arrow_ladder"):
				var arrow: Projectile = load("res://projectiles/arrow_ladder.tscn").instance()
				arrow.exceptions.append(father)
				Game.deploy_instance(arrow, father.global_position)
			else:
				if PlayerStats.eyes == PlayerStats.EYES_SHAPESHIFTER:
					set_state("shift")
		
		if event.is_action_pressed("move_up") or event.is_action_pressed("move_down"):
			#var ladder = father.get_overlapping_ladder()
			#if ladder:
			#	get_parent().states["climb"].ladder = ladder
			#	set_state("climb")
			father.cling_to_ladder()


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
