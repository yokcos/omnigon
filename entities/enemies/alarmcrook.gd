extends Enemy


var target: Being = null


var obj_gfc = load("res://entities/enemies/grandfathercrook.tscn")
const obj_bell = preload("res://entities/enemies/bell.tscn")


func _process(delta: float) -> void:
	if !is_instance_valid(target):
		target = Game.get_player()
		if is_instance_valid(target):
			$fsm/idle.target = target


func get_shifted():
	var new_gfc = obj_gfc.instance()
	new_gfc.hp = hp
	Game.replace_instance(self, new_gfc)


func _on_entity_detector_activated() -> void:
	$fsm/idle.set_state("attacc")

func _on_attack_timer_timeout() -> void:
	var attacks = ["pre_ring", "charge", "jump"]
	var index = randi() % attacks.size()
	var this_attack = attacks[index]
	
	$fsm/idle.set_state(this_attack)
	$attack_timer.stop()

func _on_wall_detector_activated() -> void:
	$fsm/charge.set_state("dazed")


func _on_idle_entered() -> void:
	$attack_timer.start()

func _on_attacc_activated() -> void:
	$flippable/hurtbox.pulse()

func _on_ring_entered() -> void:
	$ringbox.activate()

func _on_ring_exited() -> void:
	$ringbox.active = false

func _on_charge_entered() -> void:
	$flippable/chargebox.activate()

func _on_charge_exited() -> void:
	$flippable/chargebox.active = false

func _on_dazed_entered() -> void:
	velocity += Vector2(-400 * flip_int, -200)

func _on_jump_entered() -> void:
	var new_bell = obj_bell.instance()
	Game.deploy_instance(new_bell, global_position)
	
	var dir = Vector2(flip_int, -1).normalized()
	velocity += dir * 300
	move_and_collide(dir*32)
