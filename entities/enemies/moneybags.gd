extends "res://entities/enemies/enemy.gd"


var attacks = ["attacc0", "attacc1", "attacc1b", "attacc2"]
var armed_states = ["idle", "attacc0", "attacc1", "attacc1b", "attacc2", "jump_pre", "jump"]
var unarmed_states = ["idle_b", "idle_u", "attacc_b0", "attacc_u0_pre", "attacc_u0", "attacc_u0_post"]

var phase: int = 0
var has_boomerang: bool = true

const obj_rocket = preload("res://projectiles/rocket.tscn")
const obj_stoppy = preload("res://projectiles/stoppy_rocket.tscn")
const obj_explosion = preload("res://fx/explosion.tscn")
const obj_explosion_wave = preload("res://projectiles/explosion_wave.tscn")
const obj_boomerang = preload("res://projectiles/boomerang.tscn")
const obj_extra_hp = preload("res://entities/extra_hp.tscn")
const scr_effect_uncontrol = preload("res://pieces/effects/effect_air_uncontrol.gd")
const anim_health = preload("res://animations/moneybags_health/moneybags_health.tscn")


func _ready() -> void:
	coyote_time = 0
	
	$fsm/attacc_u0.barrel_bac0  = $flippable/gun_barrels/bac0
	$fsm/attacc_u0.barrel_bac1  = $flippable/gun_barrels/bac1
	$fsm/attacc_u0.barrel_fore0 = $flippable/gun_barrels/fore0
	$fsm/attacc_u0.barrel_fore1 = $flippable/gun_barrels/fore1
	$fsm/attacc_u0.barrel_gun   = $flippable/gun_barrels/gun

func _process(delta: float) -> void:
	if !is_instance_valid($fsm/idle.target):
		$fsm/idle.target   = Game.get_player()
		$fsm/idle_b.target = Game.get_player()
		$fsm/idle_u.target = Game.get_player()
		Game.set_boss(self)


func take_damage(dmg: float, source: Being = null):
	var actual_dmg = .take_damage(dmg, source)
	
	if phase > 0:
		print("Moneybags taketh %s damage, down to %s HP" % [dmg, hp])
	if phase == 0 and hp <= 2:
		advance_phase()
	
	return actual_dmg

func shoot(what: PackedScene = obj_rocket):
	var dir: Vector2 = $flippable/barrel.global_transform.x.normalized()
	var rocket_speed: float = 40
	var rocket_acceleration: float = 400
	
	var new_rocket: Projectile = what.instance()
	new_rocket.velocity = rocket_speed * dir
	new_rocket.acceleration = rocket_acceleration * dir
	
	Game.deploy_instance(new_rocket, $flippable/barrel.global_position)
	return new_rocket

func random_attack():
	var these_attacks = attacks.duplicate()
	if hp > max_hp/2:
		these_attacks.append("jump_pre")
	
	these_attacks.shuffle()
	$fsm/idle.set_state(these_attacks.pop_front())
	
	var attacks_b = ["attacc_b0", "attacc_b1"]
	attacks_b.shuffle()
	$fsm/idle_b.set_state(attacks_b.pop_front())
	
	$fsm/idle_u.set_state("attacc_u0_pre")

func start_attack_timer(time: float = 0.75):
	$attacc_timer.start(time)

func face_player():
	var player = Game.get_player()
	if is_instance_valid(player):
		set_flip(player.global_position.x < global_position.x)
		velocity.x = abs(velocity.x) * flip_int

func get_shifted():
	if $fsm.state_name in armed_states:
		$fsm.set_state_string("idle_b")
		has_boomerang = true
	else:
		$fsm.set_state_string("idle")

func gain_hp():
	var ui = Game.get_ui()
	if !is_instance_valid(ui):
		print("Error: Attempting to spawn extra HP with no UI")
		return false
	
	var base_bar = ui.get_boss_bar()
	if !is_instance_valid(base_bar):
		print("Error: Attempting to spawn extra HP with no boss bar")
		return false
	
	base_bar = base_bar.get_bar()
	var all_bars = []
	
	for i in range(20):
		var new_bar = obj_extra_hp.instance()
		new_bar.base_bar = base_bar
		new_bar.target = self
		new_bar.pos = i
		all_bars.append(new_bar)
		Game.deploy_instance(new_bar, Vector2())
		new_bar.snap_to_base()
		
		set_hp( max_hp * (i + 2) )
	
	for this_bar in all_bars:
		this_bar.all_bars = all_bars

func advance_phase():
	match phase:
		0:
			var player = Game.get_player()
			if is_instance_valid(player):
				player.long_stun()
			
			$fsm.set_state_string("anim_health")
			
			var current_popup = Game.summon_popup_world(anim_health, "Witness the purchasing")
			if is_instance_valid(current_popup):
				current_popup.anchor = self
				current_popup.max_distance = 1000000
				current_popup.world.father = self
				current_popup.connect("world_slain", self, "_on_popup_slain")
			
			var cam = Game.camera
			if is_instance_valid(cam):
				cam.target_pos = Vector2(0, -60)
	
	phase += 1


func _on_attacc_timer_timeout() -> void:
	random_attack()

func _on_idle_entered() -> void:
	start_attack_timer()

func _on_idle_b_entered() -> void:
	start_attack_timer()

func _on_idle_u_entered() -> void:
	if has_boomerang:
		$fsm.set_state_string("idle_b")
	else:
		start_attack_timer(3)

func _on_attacc0_activated() -> void:
	shoot()

func _on_attacc1_activated() -> void:
	var new_rocket = shoot()
	new_rocket.velocity = new_rocket.velocity.normalized() * 200
	new_rocket.velocity.y -= 200
	new_rocket.acceleration.y = 600

func _on_attacc1b_activated() -> void:
	shoot(obj_stoppy)

func _on_attacc2_activated() -> void:
	$flippable/slam_hurtbox.pulse()
	
	if is_grounded():
		var wave_speed: float = 400
		var new_explosion_wave = obj_explosion_wave.instance()
		new_explosion_wave.velocity.x = wave_speed * flip_int
		Game.deploy_instance(new_explosion_wave, $flippable/wavesplosion.global_position)
	else:
		var new_explosion = obj_explosion.instance()
		Game.deploy_instance(new_explosion, $flippable/wavesplosion.global_position)

func _on_attacc_b0_activated() -> void:
	var bspeed: float = 300
	var new_boomerang = obj_boomerang.instance()
	new_boomerang.connect("returned", self, "_on_boomerang_returned")
	new_boomerang.father = self
	Game.deploy_instance(new_boomerang, $flippable/barrel.global_position)
	has_boomerang = false
	var player = Game.get_player()
	if is_instance_valid(player):
		var dir = (player.global_position - $flippable/barrel.global_position).normalized()
		new_boomerang.velocity = dir * bspeed

func _on_attacc_b1_activated() -> void:
	$flippable/spin_hurtbox.pulse()

func _on_attacc_u0_pre_entered() -> void:
	face_player()

func _on_jump_pre_exited() -> void:
	velocity.y -= 450
	velocity.x += flip_int * 300
	
	var new_effect = scr_effect_uncontrol.new()
	new_effect.duration = 2.5
	new_effect.multiplier = .1
	add_child(new_effect)
	
	var new_explosion = obj_explosion.instance()
	Game.deploy_instance(new_explosion, $flippable/footsplosion.global_position)

func _on_boomerang_returned():
	has_boomerang = true
	$fsm/idle_u.set_state("idle_b")


func _on_popup_slain():
	var player = Game.get_player()
	if is_instance_valid(player):
		player.set_state("normal")
	$fsm/anim_health.set_state($fsm/anim_health.auto_proceed)


