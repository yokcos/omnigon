extends Enemy


var target: Node2D = null
var pendulum_target: Vector2 = Vector2()

const obj_child = preload("res://entities/enemies/grandchilddrook.tscn")
const obj_pendulum = preload("res://projectiles/pendulum.tscn")
const target_sprites = [
	null,
	preload("res://fx/target0.png"),
	preload("res://fx/target1.png")
]
const target_frameses = [1, 6, 1]


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

func deploy_pendulum(where: Vector2):
	var new_pendulum = obj_pendulum.instance()
	new_pendulum.fulcrum = global_position + where + Vector2(0, -96)
	new_pendulum.distance = 96
	Game.deploy_instance(new_pendulum, global_position + where)

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
	
	Game.deploy_fx(load("res://fx/gfc_unjump.png"), global_position + Vector2(0, -70), 6)

func change_target_sprite(what: int):
	$target.texture = target_sprites[what]
	$target.hframes = target_frameses[what]

func move_target_toward(where: Vector2, delta: float, move_speed: float = 100):
	var diff: float = where.x - pendulum_target.x
	if abs(diff) > 8:
		var dir = sign(diff)
		pendulum_target.x += dir * move_speed * delta
	
	pendulum_target.y = lerp(pendulum_target.y, where.y, delta*8)
	
	$target.position = pendulum_target


func _on_front_detector_activated() -> void:
	$fsm/idle.set_state("bong")

func _on_idle_entered() -> void:
	$move_timer.start()

func _on_bong_activated() -> void:
	if $flippable/wall_detector.has_wall:
		$fsm.set_state_string("idle")
	else:
		$flippable/hurtbox0.pulse()

func _on_bong_exited() -> void:
	if flipped:
		velocity.x = -1
	else:
		velocity.x = 1

func _on_child_activated() -> void:
	deploy_child()

func _on_post_jump_entered() -> void:
	unjump()

func _on_pendulum_entered() -> void:
	change_target_sprite(1)

func _on_pendulum_exited() -> void:
	deploy_pendulum(pendulum_target)
	change_target_sprite(0)
	pendulum_target = Vector2()
	$target.position = pendulum_target


func _on_move_timer_timeout() -> void:
	var moves = ["child", "pre_jump", "pendulum"]
	var index = randi() % moves.size()
	var this_move = moves[index]
	
	$fsm/idle.set_state(this_move)
	$move_timer.stop()









