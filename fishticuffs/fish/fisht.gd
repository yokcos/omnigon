extends FishticuffsFish


var target: Node2D = null

const tex_bullet = preload("res://fishticuffs/projectiles/bullet.png")


func _process(delta: float) -> void:
	if !is_instance_valid(target):
		identify_target()
	follow_target(delta)


func identify_target():
	var hooks = get_tree().get_nodes_in_group("hooks")
	if hooks.size() > 0 and !PlayerStats.has_hat("binlid"):
		target = hooks[0]
		homeostatify_velocity = false
	else:
		target = null
		homeostatify_velocity = true

func follow_target(delta: float):
	if is_instance_valid(target):
		var dir = ( target.global_position - global_position ).normalized()
		var target_velocity = dir*speed
		var relative_velocity = target_velocity - velocity
		velocity += relative_velocity.normalized() * acceleration*delta


func _on_attacc_activated() -> void:
	$fistbox.pulse()

func _on_entity_detector_activated() -> void:
	$fsm/idle.set_state("attacc")
