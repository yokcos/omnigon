extends Enemy


var obj_bullet = preload("res://projectiles/bullet.tscn")
var obj_shockwave = preload("res://projectiles/shockwave.tscn")
var obj_googlyspring = preload("res://props/googlyspring.tscn")



func _ready() -> void:
	if WorldSaver.load_data("bosses_defeated") > 0:
		queue_free()
	else:
		connect("tree_exiting", self, "_on_tree_exiting")

func _process(delta: float) -> void:
	if $dangersword.visible:
		$dangersword.rotation = velocity.angle()

func is_health_low() -> bool:
	return hp < max_hp/2

func take_damage(dmg: float, source: Being = null):
	var prev_low = is_health_low()
	var output = .take_damage(dmg, source)
	var post_low = is_health_low()
	if post_low and !prev_low:
		enter_second_stage()
	
	if $fsm.state_name == "prelude":
		$fsm.set_state_string("idle")
	
	return output

func enter_second_stage():
	$fsm/rapier_dive.auto_proceed = "attacc0"
	$fsm/dive_dive.auto_proceed = "idle"
	
	$fsm/idle.options.append("big_jump")
	$fsm/idle.weights.append(1)
	$fsm/idle.options.append("dive_jump")
	$fsm/idle.weights.append(1)

func enter_first_stage():
	if $fsm/idle.options.has("big_jump"):
		$fsm/idle.options.erase("big_jump")
		$fsm/idle.options.erase("dive_jump")
		$fsm/idle.weights.pop_back()
		$fsm/idle.weights.pop_back()
		
		$fsm/rapier_dive.auto_proceed = "boing"
		$fsm/dive_dive.auto_proceed = "dive_recover"

func play_bounce_sfx(volume: float = 1):
	var new_sfx: SFX2D = GlobalSound.play_random_sfx_2d(GlobalSound.sfx_bouncer_bounce, global_position)
	new_sfx.randomise_pitch(0.8, 1.2)
	new_sfx.relative_volume = volume

func get_shifted():
	Game.replace_instance(self, obj_googlyspring.instance())


func _on_postattacc0_entered() -> void:
	$flippable/hurtbox0.pulse(0.1)
	if is_health_low():
		var new_shockwave = obj_shockwave.instance()
		new_shockwave.scale.x = flip_int
		new_shockwave.velocity.x = 200 * flip_int
		Game.deploy_instance(new_shockwave, global_position + Vector2(0, 8))
		
		var new_sfx: SFX2D
		new_sfx = GlobalSound.play_random_sfx_2d(GlobalSound.sfx_whoosh, global_position)
		new_sfx.pitch_scale = 0.8
		new_sfx.relative_volume = 0.6
		new_sfx = GlobalSound.play_random_sfx_2d(GlobalSound.sfx_whoosh, global_position)
		new_sfx.pitch_scale = 1.6
		new_sfx.relative_volume = 0.6
	else:
		var new_sfx: SFX2D = GlobalSound.play_random_sfx_2d(GlobalSound.sfx_whoosh, global_position)
		new_sfx.pitch_scale = 0.8


func _on_rapier_dive_entered() -> void:
	var new_sfx: SFX2D = GlobalSound.play_random_sfx_2d(GlobalSound.sfx_whoosh_charge, global_position)
	new_sfx.randomise_pitch(0.8, 1.2)
	new_sfx.relative_volume = 0.7
	new_sfx.max_distance = 500

func _on_rapier_dive_activated() -> void:
	$dangersword.show()
	$flippable/hurtbox0.activate()
	
	var new_sfx: SFX2D = GlobalSound.play_random_sfx_2d(GlobalSound.sfx_whoosh_bang, global_position)
	new_sfx.randomise_pitch(0.8, 1.2)
	new_sfx.relative_volume = 0.7
	new_sfx.max_distance = 500

func _on_rapier_dive_exited() -> void:
	$dangersword.hide()
	$flippable/hurtbox0.active = false
	$underfoot.pulse(0.1)


func _on_dive_dive_exited() -> void:
	$underfoot.pulse(0.1)
	for i in range(10):
		var new_bullet = obj_bullet.instance()
		new_bullet.velocity = Vector2(0, rand_range(-300, -100)).rotated(rand_range(-0.5, 0.5))
		new_bullet.acceleration = Vector2(0, 200)
		Game.deploy_instance(new_bullet, global_position)


func _on_big_jump_exited() -> void:
	var base_vector = Vector2(flip_int, -3).normalized()
	if $fsm/big_jump.age > 0.1:
		for i in range(5):
			var new_bullet = obj_bullet.instance()
			new_bullet.velocity = base_vector.rotated(rand_range(-0.2, 0.2)) * rand_range(150, 250)
			new_bullet.acceleration = Vector2(0, 200)
			Game.deploy_instance(new_bullet, global_position)

func _on_idle_entered() -> void:
	Game.set_boss(self)
	GlobalSound.play_temp_music("entrydenied")

func _on_rapier_jump_entered() -> void:
	play_bounce_sfx()

func _on_dive_jump_entered() -> void:
	play_bounce_sfx()

func _on_boing_entered() -> void:
	play_bounce_sfx(0.6)

func _on_attacc0_entered() -> void:
	play_bounce_sfx(0.6)

func _on_tree_exiting():
	enter_first_stage()
