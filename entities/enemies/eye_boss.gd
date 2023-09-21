extends Enemy


export (float) var target_height = 64

var target: Entity = null
# Left first
var reserved_hands: Array = []
var hands: Array = []
var hand_positions: Array = []
var hand_rotations: Array = []
var current_laser: Area2D = null

var following_player: bool = true
var pupil_target: Vector2 = Vector2()
var flashing_pupil: bool = false

var value: float = 1
var hand_count: int = 2


const obj_hand = preload("res://entities/enemies/eye_boss_hand.tscn")
const obj_laser = preload("res://projectiles/laser.tscn")
const obj_shockwave = preload("res://projectiles/shockwave.tscn")

const obj_parts_wide = preload("res://fx/part_orangegreen_slam_wide.tscn")
const obj_parts_normal = preload("res://fx/part_orangegreen_slam.tscn")
const obj_parts_narrow = preload("res://fx/part_orangegreen_slam_narrow.tscn")

const obj_vertex = preload("res://entities/vertex.tscn")

const tex_base_normal = preload("res://entities/enemies/eye_boss_base.png")
const tex_base_dive = preload("res://entities/enemies/eye_boss_dive.png")

const tex_pupil_normal = preload("res://entities/enemies/eye_boss_pupil.png")
const tex_pupil_green = preload("res://entities/enemies/eye_boss_pupil_green.png")


func _ready() -> void:
	setup_arrays()
	grab_existing_hands()
	spawn_hands()
	
	Game.set_boss(self)

func _process(delta: float) -> void:
	if following_player:
		look_at_player(delta)
	else:
		look_at_point(pupil_target, delta)
	
	if flashing_pupil:
		var modulo = fmod(age, 0.2)
		if modulo < 0.1:
			$pupil.texture = tex_pupil_green
		else:
			$pupil.texture = tex_pupil_normal
	else:
		if $pupil.texture != tex_pupil_normal:
			$pupil.texture = tex_pupil_normal
	
	if is_instance_valid(current_laser):
		current_laser.global_position = $barrel.global_position.round()


func look_at_player(delta: float):
	if target:
		var dist: float = 24
		var dir: float = (target.global_position - global_position).angle()
		var target_pos: Vector2 = Vector2(dist, 0).rotated(dir)
		
		look_at_point(target_pos, delta)

func look_at_point(where: Vector2, delta: float):
	$pupil.position = $pupil.position.linear_interpolate(where, delta*5)


func setup_arrays():
	reserved_hands = []
	hands = []
	hand_positions = []
	hand_rotations = []
	
	for i in range(hand_count):
		reserved_hands.append(null)
		hands.append(null)
		hand_positions.append(Vector2(64, 0))
		hand_rotations.append(PI/2)

func grab_existing_hands():
	for i in get_tree().get_nodes_in_group("eye_boss_hands"):
		i.father = self
		
		print("Found hand: index %s, is_hand: %s" % [i.index, i is Enemy])
		
		reserved_hands[i.index] = i
		if i is Enemy:
			hands[i.index] = i

func spawn_hands():
	var new_hand
	for i in [0, 1]:
		if !has_reserved_hand(i):
			var new_flip_int = -1 if i == 0 else 1
			new_hand = obj_hand.instance()
			new_hand.father = self
			new_hand.float_offset = Vector2(64*new_flip_int, 0)
			new_hand.spawn_position = Vector2(64*new_flip_int, 0)
			new_hand.call_deferred("set_flip", i == 0)
			new_hand.index = i
			
			devalue_hand(new_hand)
			Game.deploy_instance(new_hand, global_position + new_hand.float_offset)
			
			hands[i] = new_hand
			hand_positions[i] = Vector2(64, 0)
			hand_rotations[i] = PI/2
			
			print("Creating new hand. i: %s pos: %s" % [i, new_hand.float_offset])
			
			call_deferred("teleport_hand", i)

func devalue_hand(what: Enemy):
	what.value -= WorldSaver.load_data(what.spawn_position)
	for this_vertex in get_tree().get_nodes_in_group("vertices"):
		if this_vertex.source == what.spawn_position:
			what.value -= this_vertex.value

func shoot(speed: float, angle: float = 0, these_hands: Array = [0, 1]):
	for i in these_hands:
		if has_hand(i):
			hands[i].shoot(speed, angle)

func recoil_hands(these_hands: Array = [0, 1], angle: float = 90):
	for i in these_hands:
		if has_hand(i):
			hands[i].fulcrum.rotation -= deg2rad(angle)

func particulate_hands(these_hands: Array = [0, 1]):
	for i in these_hands:
		if has_hand(i):
			hands[i].deploy_particles()

func rotate_hands(these_hands: Array = [0, 1], angle: float = PI/2):
	for i in these_hands:
		hand_rotations[i] = angle
		if has_hand(i):
			hands[i].angle = angle

func position_hands(these_hands: Array = [0, 1], pos: Vector2 = Vector2(64, 0)):
	# This position will be automatically flipped for the left hand
	for i in these_hands:
		hand_positions[i] = pos
		if has_hand(i):
			var this_hand = hands[i]
			var this_pos = pos
			if this_hand.flipped: this_pos.x *= -1
			this_hand.float_offset = this_pos

func reset_hands():
	rotate_hands()
	position_hands()

func teleport_hands():
	for i in range(hands.size()):
		teleport_hand(i)

func teleport_hand(which: int):
	if has_hand(which):
		var this_hand = hands[which]
		this_hand.global_position = global_position + this_hand.float_offset
		
		var loc = this_hand.float_offset.round()
		var glob = (global_position + this_hand.float_offset).round()
		print("Teleporting hand to loc: %s, glob: %s" % [loc, glob])


func cull_laser():
	if current_laser:
		current_laser.queue_free()
		current_laser = null

func shoot_laser():
	cull_laser()
	
	var new_laser = obj_laser.instance()
	new_laser.rotation = PI/2
	add_child(new_laser)
	new_laser.global_position = $barrel.global_position.round()
	
	current_laser = new_laser

func set_dive_sprite(diving: bool):
	if diving:
		$base.texture = tex_base_dive
	else:
		$base.texture = tex_base_normal

func slam():
	var new_parts: CPUParticles2D
	var hit_pos = global_position + Vector2(0, 32)
	
	$dive_hurtbox.pulse(0.1)
	new_parts = obj_parts_wide.instance()
	new_parts.rotation = -PI/2
	Game.deploy_instance(new_parts, hit_pos)
	new_parts = obj_parts_normal.instance()
	new_parts.rotation = -PI/2
	Game.deploy_instance(new_parts, hit_pos)
	new_parts = obj_parts_narrow.instance()
	new_parts.rotation = -PI/2
	Game.deploy_instance(new_parts, hit_pos)
	
	for i in [-1, 1]:
		var new_shockwave = obj_shockwave.instance()
		new_shockwave.scale.x = i
		new_shockwave.velocity.x = 200 * i
		Game.deploy_instance(new_shockwave, hit_pos)
	
	Game.shake_cam_random(16)

func has_hand(index: int) -> bool:
	return hands.size() >= index+1 and is_instance_valid(hands[index])

func has_reserved_hand(index: int) -> bool:
	return reserved_hands.size() >= index+1 and is_instance_valid(reserved_hands[index])

func get_shifted():
	for i in hands:
		if is_instance_valid(i):
			i.queue_free()
	
	var obj_eye = load("res://props/eye.tscn")
	Game.set_boss(null)
	Game.replace_instance(self, obj_eye.instance())

func die():
	.die()
	
	for i in range(value):
		var new_vertex = obj_vertex.instance()
		new_vertex.apply_central_impulse( Vector2(0, -rand_range(40, 600)).rotated(rand_range(-0.5, 0.5)) )
		new_vertex.source = Vector2()
		Game.deploy_instance(new_vertex, global_position)

func check_for_mattresses() -> bool:
	return Game.is_instance_in_mattress($mattress_detector)


func _on_entity_detector_updated(what: Array) -> void:
	if what.size() > 0:
		target = what[0]
	else:
		target = null
