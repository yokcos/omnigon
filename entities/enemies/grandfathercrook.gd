extends Enemy


var target: Node2D = null

const obj_child = preload("res://entities/enemies/grandchilddrook.tscn")


func _process(delta: float) -> void:
	if !is_instance_valid(target):
		target = Game.get_player()
		if is_instance_valid(target):
			$fsm/idle.target = target


func deploy_child():
	var new_child = obj_child.instance()
	new_child.flipped = flipped
	var vel = Vector2(rand_range(200, 600), 0).rotated(rand_range(-0.9, 0.1))
	vel.x *= flip_int
	new_child.velocity = vel
	Game.deploy_instance(new_child, $flippable/spawnpoint.global_position)

func reposition():
	if !$flippable/wall_detector.has_wall:
		position += Vector2(flip_int*48, 0)
		$flippable/sprite.frame = 0

func unjump():
	var uhb = $underhurtbox
	
	uhb.pulse()
	
	for i in uhb.overlapping_bodies:
		if uhb.target_teams.has(i.team):
			var dir = sign(i.global_position.x - global_position.x)
			i.move_and_collide( $underhurtbox/hitbox.shape.extents.x*2 * Vector2(dir, 0) )
			i.velocity += 500 * Vector2(dir, -.3)
	
	move_and_collide( Vector2(0, 1000) )


func _on_front_detector_activated() -> void:
	$fsm/idle.set_state("bong")

func _on_idle_entered() -> void:
	$move_timer.start()

func _on_bong_activated() -> void:
	if $flippable/wall_detector.has_wall:
		$fsm.set_state_string("idle")
	else:
		$flippable/hurtbox0.pulse()

func _on_child_activated() -> void:
	deploy_child()

func _on_post_jump_entered() -> void:
	unjump()


func _on_move_timer_timeout() -> void:
	var moves = ["child", "pre_jump"]
	var index = randi() % moves.size()
	var this_move = moves[index]
	
	$fsm/idle.set_state(this_move)
	$move_timer.stop()




