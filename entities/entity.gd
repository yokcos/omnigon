class_name Entity
extends KinematicBody2D


enum teams {
	ALLIES,
	ENEMIES,
}

var coyote_time: float = 0.1
var coyote_enabled: bool = true
var velocity: Vector2 = Vector2()
var recent_downyness: float = 0
var friction: float = 10
var gravity: float = 540
var fall_multiplier: float = 1
var is_controlled: bool = false
var air_time: float = 0
export (bool) var submergable = true
var submerged: bool = false
var spawn_position: Vector2 = Vector2()
var extra_data: Dictionary = {}
var age: float = 0
var pre_freeze_velocity: Vector2 = Vector2()
var timefreeze: float = 0
var timefreeze_fx = null
var prev_position: Vector2 = Vector2()


export (bool) var can_flip_by_default = true
export (bool) var never_flips = false
export (float) var air_friction_multiplier = 1
onready var can_flip: bool = can_flip_by_default
export (NodePath) var flip_path = "."
var flipped: bool = false setget set_flip
var flip_int: int = 1
onready var flip_node: Node2D = get_node(flip_path)
var bounce_speed: float = 300

export (int) var team = teams.ENEMIES
export (float) var inertia = 20
export (float) var bounciness = .9
export (bool) var gravity_active = true
export (bool) var can_be_bounced = true
export (bool) var can_bounce = true

export (String) var title = ""

const obj_part_bounce_stars = preload("res://fx/part_bounce_stars.tscn")
const fx_clock = preload("res://fx/clock.tscn")


func _ready() -> void:
	spawn_position = global_position
	prev_position = global_position
	add_to_group("entities")
	set_flip(flipped)

func _process(delta: float) -> void:
	if is_on_floor():
		velocity.y = min(velocity.y, 0)
		air_time = 0
	else:
		air_time += delta
	
	if submergable:
		submerged = is_submerged()
	
	flip()
	
	if velocity.y > recent_downyness:
		recent_downyness = velocity.y
	else:
		recent_downyness = lerp(recent_downyness, velocity.y, delta*30)
	
	age += delta

func _physics_process(delta: float) -> void:
	if timefreeze <= 0:
		prev_position = global_position
		velocity = move_and_slide(velocity, Vector2(0, -1), false, 4, PI/4, false)
		
		call_deferred("bounce_against_mattress")
		
		for i in get_slide_count():
			var hit = get_slide_collision(i)
			collide_against(hit)
			
			if hit.collider is RigidBody2D:
				hit.collider.apply_impulse( hit.position - hit.collider.position, -hit.normal * inertia )
			
			if hit.normal.y < 0:
				if hit.collider.is_in_group("entities"):
					# Bounce on stuff
					var other_thing = hit.collider
					if other_thing.can_be_bounced and can_bounce:
						if velocity.y >= 0:
							velocity.y = -bounce_speed
							
							var new_part = obj_part_bounce_stars.instance()
							Game.deploy_instance(new_part, hit.position)
				
				if air_time > 0:
					land()
				air_time = 0
			
			bounce_against(hit)
		
		frictutate(delta)
		if gravity_active:
			gravitate(delta)
	else:
		timefreeze -= delta
		if timefreeze <= 0:
			velocity = pre_freeze_velocity
			if is_instance_valid(timefreeze_fx):
				timefreeze_fx.queue_free()
				timefreeze_fx = null

func get_actual_velocity():
	return global_position - prev_position

func collide_against(hit: KinematicCollision2D):
	pass

func bounce_against(hit: KinematicCollision2D):
	var speed_in_dir: float = velocity.dot( -hit.normal )
	if speed_in_dir > 0:
		velocity += speed_in_dir * hit.normal * bounciness

func bounce_against_mattress(downyness: float = recent_downyness):
	if gravity_active and downyness > 200:
		if Game.is_instance_in_mattress(self):
			velocity.y = downyness * -0.5

func land():
	air_time = 0
	coyote_enabled = true

func frictutate(delta: float):
	if friction <= 0:
		return false
	
	var this_friction = friction * delta
	if !is_grounded():
		this_friction *= air_friction_multiplier
	velocity.x -= velocity.x * this_friction
	
	if submerged:
		velocity -= velocity * friction * delta

func gravitate(delta: float):
	var this_gravity = gravity * delta
	if submerged: this_gravity *= -.5
	
	if velocity.y > 0:
		velocity.y += this_gravity * fall_multiplier
	else:
		velocity.y += this_gravity

func is_grounded() -> bool:
	return air_time <= 0 or (air_time < coyote_time and coyote_enabled)

func is_submerged() -> bool:
	for i in get_tree().get_nodes_in_group("waters"):
		if i.get_overlapping_bodies().has(self):
			if !submerged:
				GlobalSound.play_random_sfx_2d( GlobalSound.sfx_splash, global_position )
			return true
	return false

func time_freeze(duration: float):
	timefreeze = duration
	pre_freeze_velocity = velocity
	
	var new_clock = fx_clock.instance()
	add_child(new_clock)
	timefreeze_fx = new_clock


func reset_flippability():
	can_flip = can_flip_by_default

func flip():
	if can_flip and flip_node:
		if velocity.x < 0:
			set_flip(true)
		if velocity.x > 0:
			flip_node.scale.x =  1
			set_flip(false)

func invert_flip():
	set_flip(!flipped)

func set_flip(what: bool):
	flipped = what
	
	if flip_node:
		if flipped and !never_flips:
			flip_node.scale.x = -1
			flip_int = -1
		else:
			flip_node.scale.x =  1
			flip_int = 1
