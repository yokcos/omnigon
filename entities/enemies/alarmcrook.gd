extends Enemy


var target: Being = null


var ring_sfx: SFX2D = null
var obj_gfc = load("res://entities/enemies/grandfathercrook.tscn")
const obj_bell = preload("res://entities/enemies/bell.tscn")


func _ready() -> void:
	connect("tree_exiting", self, "_on_slain")

func _process(delta: float) -> void:
	if !is_instance_valid(target):
		target = Game.get_player()
		if is_instance_valid(target):
			$fsm/idle.target = target


func get_shifted():
	var new_gfc = obj_gfc.instance()
	new_gfc.hp = hp
	Game.set_boss(new_gfc)
	Game.replace_instance(self, new_gfc)

func cull_sfx():
	if is_instance_valid(ring_sfx):
		ring_sfx.queue_free()
		ring_sfx = null

func launch_random_attack(attacks: Array):
	var index = randi() % attacks.size()
	var this_attack = attacks[index]
	
	$fsm/idle.set_state(this_attack)
	$attack_timer.stop()


func _on_entity_detector_activated() -> void:
	if randf()*4 < 3:
		$fsm/idle.set_state("attacc")
	else:
		var attacks = ["pre_ring", "jump"]
		launch_random_attack(attacks)

func _on_attack_timer_timeout() -> void:
	var attacks = ["pre_ring", "charge", "jump"]
	launch_random_attack(attacks)

func _on_wall_detector_activated() -> void:
	$fsm/charge.set_state("dazed")


func _on_idle_entered() -> void:
	$attack_timer.start()

func _on_attacc_entered() -> void:
	GlobalSound.play_random_sfx_2d(GlobalSound.sfx_tick, global_position)

func _on_attacc_activated() -> void:
	$flippable/hurtbox.pulse()
	GlobalSound.play_random_sfx_2d(GlobalSound.sfx_tock, global_position)

func _on_ring_entered() -> void:
	$ringbox.activate()
	
	ring_sfx = GlobalSound.play_random_sfx_2d(GlobalSound.sfx_ring, global_position)

func _on_ring_exited() -> void:
	$ringbox.active = false
	cull_sfx()
	GlobalSound.play_random_sfx_2d(GlobalSound.sfx_ring_end, global_position)

func _on_charge_entered() -> void:
	$flippable/chargebox.activate()
	
	var new_sfx = GlobalSound.play_random_sfx_2d(GlobalSound.sfx_whoosh, global_position)
	new_sfx.randomise_pitch(0.4, 0.6)

func _on_charge_exited() -> void:
	$flippable/chargebox.active = false

func _on_dazed_entered() -> void:
	velocity += Vector2(-400 * flip_int, -200)
	var new_sfx = GlobalSound.play_random_sfx_2d(GlobalSound.sfx_fart, global_position)

func _on_jump_entered() -> void:
	var new_bell = obj_bell.instance()
	Game.deploy_instance(new_bell, global_position)
	
	var dir = Vector2(flip_int, -1).normalized()
	velocity += dir * 300
	move_and_collide(dir*32)
	
	var new_sfx = GlobalSound.play_random_sfx_2d(GlobalSound.sfx_jump, global_position)
	new_sfx.randomise_pitch(0.4, 0.6)


func _on_slain():
	cull_sfx()
