extends Being


var base_gravity: float = 1250
var gravity_multiplier: float = 1.5
var base_animation_speed: float = 1
var jet_power: float = 0
var current_bobber: Node2D = null
var combhat_height: float = -1
var total_hat_height: float = 0
var electromonocle_scale: float = 3

const obj_fx = preload("res://fx/fx_transient.tscn")
const obj_bobber = preload("res://entities/fishing_bobber.tscn")
const obj_bullet_combhat = preload("res://projectiles/bullet_combhat.tscn")
const obj_thrown_hat = preload("res://projectiles/thrown_hat.tscn")
const tex_shift = preload("res://fx/shift.png")
const scr_auto_sprite = preload("res://pieces/auto_sprite.gd")
const scr_effect_fished = preload("res://pieces/effects/effect_air_uncontrol.gd")

const base_hitbox_height: float = 12.0
const base_hitbox_position: float = 4.0
const base_shiftbox_size: Vector2 = Vector2(15, 15)


signal sitting_complete


func _ready() -> void:
	Game.camera = $cam
	must_breathe = true
	
	is_controlled = true
	fall_multiplier = 1
	gravity = base_gravity if Input.is_action_pressed("jump") else base_gravity*gravity_multiplier
	
	update_hp()
	velocity = PlayerStats.velocity
	set_flip(PlayerStats.flipped)
	
	if PlayerStats.check_pos == Vector2():
		PlayerStats.check_pos = global_position
	
	resolve_extra_data()
	apply_hat_visuals()
	apply_hats()
	call_deferred( "cling_to_ladder", true )
	
	var room_size = Rooms.get_room_size(Rooms.current_room)
	$cam.limit_right  = room_size.x * Rooms.room_size.x
	$cam.limit_bottom = room_size.y * Rooms.room_size.y
	
	if Game.gameholder:
		pass
		#$cam.limit_bottom += Game.gameholder.lower_border + Game.gameholder.upper_border
	
	$flippable/fistbox.effects.append(scr_effect_fished)
	
	add_to_group("players")
	
	PlayerStats.connect("hats_changed", self, "_on_hats_changed")

func _process(delta: float) -> void:
	var travel_direction: float = 0
	
	if Input.is_action_pressed("move_left"):
		travel_direction -= 1
	if Input.is_action_pressed("move_right"):
		travel_direction += 1
	
	#$debug.text = str((velocity/16).round())
	
	if $fsm.state_name == "normal" and $fsm/normal.time_since_movement > 8:
		set_state("tip")
	
	if GlobalSound.ear:
		GlobalSound.ear.position = global_position

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		gravity = base_gravity
	if event.is_action_released("jump"):
		gravity = base_gravity*gravity_multiplier
	
	if false and event.is_action_pressed("ui_cancel"):
		var new_thing = load("res://ui/artwork/continents.tscn").instance()
		Game.deploy_ui_instance(new_thing, Vector2())
		get_tree().paused = true
	
	if event.is_action_pressed("attack"):
		if is_instance_valid(current_bobber):
			recall_bobber()


func update_hp():
	max_hp = PlayerStats.max_hp
	hp = PlayerStats.hp
	poisoned = PlayerStats.poisoned

func is_submerged():
	var subm = .is_submerged()
	
	if !submerged and subm:
		AudioServer.set_bus_effect_enabled(2, 0, true)
		AudioServer.set_bus_effect_enabled(1, 0, true)
	if submerged and !subm:
		AudioServer.set_bus_effect_enabled(2, 0, false)
		AudioServer.set_bus_effect_enabled(1, 0, false)
	
	return subm

func collide_against(what: KinematicCollision2D):
	.collide_against(what)
	
	if what.normal.y < 0 and what.travel.y > 1:
		var new_sfx: SFX = GlobalSound.play_random_sfx(GlobalSound.sfx_land)
		new_sfx.relative_volume = 0.5 + min(what.travel.y, 20) / 40

func shift():
	for thing in $flippable/shiftbox.get_overlapping_bodies():
		if thing.has_method("get_shifted"):
			thing.get_shifted()
	
	for thing in $flippable/shiftbox.get_overlapping_areas():
		if thing.has_method("get_shifted"):
			thing.get_shifted()
	
	var fx = Game.deploy_fx(tex_shift, $flippable/shiftbox/hitbox.global_position, 8)
	var new_sfx: SFX = GlobalSound.play_random_sfx(GlobalSound.sfx_shift)
	var base_pitch = 0.8
	
	if PlayerStats.has_hat("electromonocle"):
		base_pitch -= 0.2
		fx.scale = Vector2(electromonocle_scale, electromonocle_scale)
	
	new_sfx.randomise_pitch(base_pitch, base_pitch + 0.4)
	new_sfx.relative_volume = 0.6

func take_damage(what: float, from: Being = null) -> float:
	var actual_damage = .take_damage(what, from)
	
	if PlayerStats.has_hat("revenge") and from:
		var relative = from.global_position - global_position
		from.take_damage(what, self)
		from.take_knockback(relative.normalized() * 200)
	
	GlobalSound.play_random_sfx(GlobalSound.sfx_player_hit)
	
	return actual_damage

func set_hp(what: float):
	.set_hp(what)
	PlayerStats.hp = what

func die():
	.die()
	
	var new_fx = obj_fx.instance()
	new_fx.texture = load("res://fx/playerdeath.png")
	new_fx.set_frames(20)
	new_fx.connect("finished", PlayerStats, "respawn")
	Game.deploy_instance(new_fx, global_position + Vector2(0, -32))
	
	var camera = $cam
	remove_child(camera)
	Game.deploy_instance(camera, global_position)
	
	GlobalSound.play_random_sfx(GlobalSound.sfx_player_death)
	PlayerStats.poisoned = false

func land():
	.land()
	coyote_enabled = true

func force_move(where: Vector2):
	$fsm/force_move.target_position = where
	$fsm.set_state($fsm/force_move)

func long_stun():
	set_stun_duration(1000000)
	set_state("stunned")

func set_stun_duration(what: float):
	$fsm/stunned.duration = what

func resolve_extra_data():
	var data = PlayerStats.extra_data
	
	for i in data:
		if i.begins_with("stt_"):
			var new_state = i.right(4)
			match new_state:
				"climb":
					yield(get_tree().create_timer(0.05), "timeout")
					cling_to_ladder()
				_:
					$fsm.set_state_string(new_state)
	
	PlayerStats.extra_data = []

func cling_to_ladder(up: bool = false):
	var ladder = get_overlapping_ladder(up)
	if ladder:
		$fsm.states["climb"].ladder = ladder
		$fsm.set_state_string("climb")
		return true
	return false

func get_overlapping_ladder(up: bool = false) -> Area2D:
	var best_offset: float = 1000000
	var best_ladder: Area2D = null
	var upper_margin: float = 32
	
	for ladder in get_tree().get_nodes_in_group("ladders"):
		if ladder is Area2D:
			if ladder.get_overlapping_bodies().has(self):
				if !up or ladder.global_position.y <= global_position.y + upper_margin:
					var this_offset: float = abs(ladder.global_position.x - global_position.x)
					if this_offset < best_offset:
						best_offset = this_offset
						best_ladder = ladder
	
	return best_ladder

func check_hat_viability(hat: Hat):
	var height = hat.height
	var obstruction: bool = false
	obstruction = test_move(transform, Vector2(0, -hat.height))
	
	return !obstruction

func reset_hat_visuals():
	var sprites = $flippable/hats.get_children()
	for i in sprites:
		i.queue_free()
	
	$hitbox.shape.extents.y = base_hitbox_height
	$hitbox.position.y = base_hitbox_position
	
	combhat_height = -1

func apply_hat_visuals():
	reset_hat_visuals()
	
	var total_height = 0
	var anvil_position: int = -1
	var anvil_crush_factor: float = 0.5
	
	for i in range( PlayerStats.hats.size() ):
		if PlayerStats.hats[i].id == "anvil":
			anvil_position = i
	
	for i in range( PlayerStats.hats.size() ):
		var hat = PlayerStats.hats[i] as Hat
		
		var new_sprite = Sprite.new()
		new_sprite.texture = hat.sprite
		new_sprite.hframes = hat.small_frames
		new_sprite.set_script(scr_auto_sprite)
		$flippable/hats.add_child(new_sprite)
		new_sprite.position.y = -total_height
		
		if i < anvil_position:
			new_sprite.scale.y = anvil_crush_factor
			new_sprite.position.y += hat.sprite.get_height() * (1 - anvil_crush_factor) / 2
		total_height += hat.height * anvil_crush_factor\
		if i < anvil_position else hat.height
		
		if hat.id == "combhat":
			combhat_height = -new_sprite.position.y
	
	var hitbox_height = total_height - 1
	$hitbox.shape.extents.y += hitbox_height/2
	$hitbox.position.y -= hitbox_height/2
	
	$flippable/shiftbox.position.x = 24
	$flippable/shiftbox/hitbox.shape.extents = base_shiftbox_size
	if PlayerStats.has_hat("electromonocle"):
		$flippable/shiftbox.position.x = 8 + 16 * electromonocle_scale
		$flippable/shiftbox/hitbox.shape.extents = base_shiftbox_size * electromonocle_scale
	
	total_hat_height = total_height

func apply_hats():
	float_speed = .5
	# Apply hat Yeet
	var this_knockback = Vector2(100, -45)
	if PlayerStats.has_hat("yeet"):
		this_knockback *= 4
	$flippable/fistbox.knockback = this_knockback
	
	# Apply hat Anvil
	if PlayerStats.has_hat("anvil"):
		jump_speed = 449.99
		float_speed = -.5
	else:
		jump_speed = 450

func finish_sitting():
	emit_signal("sitting_complete")

func set_state(what: String):
	$fsm.set_state_string(what)

func sit_at_art(what: Node2D):
	set_state("sitting")
	$fsm/sitting.flipped = what.global_position.x < global_position.x

func step():
	if is_grounded():
		var new_sfx: SFX = GlobalSound.play_random_sfx(GlobalSound.sfx_step)
		new_sfx.relative_volume = 0.8
		new_sfx.randomise_pitch(0.8, 1.2)

func climb_sfx():
	var new_sfx: SFX = GlobalSound.play_random_sfx(GlobalSound.sfx_climb)
	new_sfx.relative_volume = 0.6
	new_sfx.randomise_pitch(0.5, 0.8)

func set_poisoned(what: bool):
	.set_poisoned(what)
	
	PlayerStats.poisoned = what

func fish():
	if is_instance_valid(current_bobber):
		recall_bobber()
	else:
		$fsm/normal.set_state("fish")

func cast_bobber():
	var new_bobber = obj_bobber.instance()
	Game.deploy_instance(new_bobber, $flippable/fistbox.global_position)
	new_bobber.velocity = Vector2( 300*flip_int, -200 )
	new_bobber.source = self
	current_bobber = new_bobber
	
	if PlayerStats.has_hat("yeet"):
		new_bobber.knockback *= 4

func recall_bobber():
	if is_instance_valid(current_bobber.target):
		var relative = global_position - current_bobber.target.global_position
		var this_dir = sign(relative.x)
		var this_knockback: Vector2 = Vector2( 900*this_dir, -300 )
		if PlayerStats.has_hat("yeet"):
			this_knockback.x *= 2
		
		current_bobber.target.take_damage(.75)
		current_bobber.target.take_knockback( this_knockback )
		current_bobber.target.air_time += 1
		
		var new_effect = scr_effect_fished.new()
		current_bobber.target.add_child(new_effect)
	
	current_bobber.queue_free()
	current_bobber = null

func shoot_combhat():
	if combhat_height >= 0:
		var new_bullet = obj_bullet_combhat.instance()
		var angle = $flippable/hats.rotation
		new_bullet.velocity.x = flip_int * 100
		new_bullet.velocity = new_bullet.velocity.rotated(angle)
		
		var pos = $flippable/hats.global_position
		pos -= Vector2(0, combhat_height+2).rotated(angle)
		Game.deploy_instance(new_bullet, pos)

func throw_hat():
	var hat_count = PlayerStats.hats.size()
	if hat_count > 0:
		var final_hat: Hat = PlayerStats.hats[ hat_count - 1 ]
		
		PlayerStats.doff_hat( final_hat )
		
		var new_thrown_hat = obj_thrown_hat.instance()
		new_thrown_hat.hat = final_hat
		new_thrown_hat.velocity = Vector2(300*flip_int + velocity.x, 0)
		new_thrown_hat.acceleration = Vector2(0, 10)
		new_thrown_hat.father = self
		if final_hat.throw_script:
			var thrower = final_hat.throw_script.new()
			thrower.modify(new_thrown_hat)
		Game.deploy_instance(new_thrown_hat, global_position - Vector2(0, total_hat_height+8))

func disable_jetfist():
	gravity_active = true
	$fsm/attacc.target_velocity.x = 0
	$fsm/attacc.acceleration = 0

func pat_blademaster(what: Enemy):
	var head_x = what.global_position.x + 5*what.flip_int
	var target_x = head_x - 16*flip_int
	global_position.x = target_x
	$fsm.set_state_string("headpat")


func _on_attacc_activated() -> void:
	velocity.x += -200 if flipped else 200
	$flippable/fistbox.pulse(.4)
	
	for thing in $flippable/fistbox.get_overlapping_bodies():
		if thing.has_method("get_punched"):
			thing.get_punched()
	
	for thing in $flippable/fistbox.get_overlapping_areas():
		if thing.has_method("get_punched"):
			thing.get_punched()

func _on_attacc_entered() -> void:
	# Apply hat Fury Fist
	if PlayerStats.has_hat("furyfist"):
		$animator.playback_speed = 2
	
	# Apply hat Jetfist
	if PlayerStats.has_hat("jetfist"):
		var jet_speed: float = 400
		var jet_impulse: float = 400
		
		$fsm/attacc.target_velocity.x = jet_speed * flip_int
		$fsm/attacc.acceleration = acceleration
		gravity_active = false
		var new_timer = get_tree().create_timer(.3)
		new_timer.connect("timeout", self, "disable_jetfist")
		velocity.y = 0
		velocity.x += jet_impulse * flip_int
	else:
		$fsm/attacc.target_velocity.x = 0
		$fsm/attacc.acceleration = 0

func _on_attacc_exited() -> void:
	$animator.playback_speed = base_animation_speed
	calculate_friction()

func _on_shift_activated() -> void:
	shift()

func _on_fish_activated() -> void:
	cast_bobber()

func _on_hats_changed(new_hats: Array):
	apply_hat_visuals()
	apply_hats()

func _on_timer_combhat_timeout() -> void:
	shoot_combhat()
