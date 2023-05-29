extends State


export (float) var duration = 5

var current_animation_time: float = -1
var prev_animation_time: float = -1

var barrel_bac0:  Node2D = null
var barrel_bac1:  Node2D = null
var barrel_fore0: Node2D = null
var barrel_fore1: Node2D = null
var barrel_gun:   Node2D = null

const obj_bullet = preload("res://projectiles/bullet.tscn")
const tex_coin = preload("res://projectiles/bullet_coin.png")


func _enter():
	._enter()
	
	prev_animation_time = -1

func _step(delta: float):
	._step(delta)
	
	var animator: AnimationPlayer = get_parent().animator
	current_animation_time = animator.current_animation_position
	
	shoot_at_time(0.5, barrel_bac0, Vector2(-100, -15), Vector2(200, 0))
	shoot_at_time(0.1, barrel_bac1, Vector2(-100,  15), Vector2(200, 0))
	
	var rotations = [-.1, 0, .1, 0]
	for i in range(4):
		shoot_at_time(i*0.2,       barrel_fore0, Vector2(400, 0).rotated(rotations[i]), Vector2(0,  200))
		shoot_at_time(i*0.2 + 0.1, barrel_fore1, Vector2(400, 0).rotated(rotations[i]), Vector2(0, -200))
	
	shoot_at_time(0, barrel_gun, Vector2(400, 0))
	
	prev_animation_time = current_animation_time
	if age > duration:
		set_state(auto_proceed)


func shoot_at_time(time: float, barrel: Node2D, velocity: Vector2, acceleration: Vector2 = Vector2()):
	if current_animation_time >= time:
		if prev_animation_time < time or prev_animation_time > current_animation_time:
			shoot(barrel, velocity, acceleration)

func shoot(barrel: Node2D, velocity: Vector2, acceleration: Vector2 = Vector2()):
	if is_instance_valid(barrel):
		velocity.x *= father.flip_int
		acceleration.x *= father.flip_int
		var new_bullet = obj_bullet.instance()
		new_bullet.set_sprite(tex_coin)
		new_bullet.set_animation_speed(20)
		new_bullet.velocity = velocity
		new_bullet.acceleration = acceleration
		
		Game.deploy_instance(new_bullet, barrel.global_position)
		return new_bullet
