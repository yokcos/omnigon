extends Being


var base_gravity: float = 1250
var gravity_multiplier: float = 1.5
var base_animation_speed: float = 1
var jet_power: float = 0
var current_bobber: Node2D = null

const obj_fx = preload("res://fx/fx_transient.tscn")
const obj_bobber = preload("res://entities/fishing_bobber.tscn")
const tex_shift = preload("res://fx/shift.png")
const scr_auto_sprite = preload("res://pieces/auto_sprite.gd")

const base_hitbox_height: float = 12.0
const base_hitbox_position: float = 4.0
const base_shiftbox_size: Vector2 = Vector2(15, 15)


signal sitting_complete


func _ready() -> void:
	Game.camera = $cam
	
	is_controlled = true
	fall_multiplier = 1
	gravity = base_gravity if Input.is_action_pressed("jump") else base_gravity*gravity_multiplier
	
	max_hp = PlayerStats.max_hp
	hp = PlayerStats.hp
	velocity = PlayerStats.velocity
	poisoned = PlayerStats.poisoned
	set_flip(PlayerStats.flipped)
	
	if PlayerStats.check_pos == Vector2():
		PlayerStats.check_pos = global_position
	
	resolve_extra_data()
	apply_hats()
	
	var room_size = Rooms.get_room_size(Rooms.current_room)
	$cam.limit_right  = room_size.x * Rooms.room_size.x
	$cam.limit_bottom = room_size.y * Rooms.room_size.y
	
	if Game.gameholder:
		pass
		#$cam.limit_bottom += Game.gameholder.lower_border + Game.gameholder.upper_border
	
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
		fx.scale = Vector2(1.25, 1.25)
	
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

func reset_hats():
	var sprites = $flippable/hats.get_children()
	for i in sprites:
		i.queue_free()
	
	$hitbox.shape.extents.y = base_hitbox_height
	$hitbox.position.y = base_hitbox_position

func apply_hats():
	reset_hats()
	
	var total_height = 0
	
	for i in PlayerStats.hats:
		var hat = i as Hat
		
		var new_sprite = Sprite.new()
		new_sprite.texture = hat.sprite
		new_sprite.hframes = hat.small_frames
		new_sprite.set_script(scr_auto_sprite)
		$flippable/hats.add_child(new_sprite)
		new_sprite.position.y = -total_height
		
		total_height += hat.height
	
	$hitbox.shape.extents.y += total_height/2
	$hitbox.position.y -= total_height/2
	
	$flippable/shiftbox/hitbox.shape.extents = base_shiftbox_size
	if PlayerStats.has_hat("electromonocle"):
		$flippable/shiftbox/hitbox.shape.extents = base_shiftbox_size * 1.25

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

func recall_bobber():
	if is_instance_valid(current_bobber.target):
		var relative = global_position - current_bobber.target.global_position
		var this_dir = sign(relative.x)
		current_bobber.target.velocity += Vector2( 900*this_dir, -400 )
	
	current_bobber.queue_free()
	current_bobber = null


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
	apply_hats()

