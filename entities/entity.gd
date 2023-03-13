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
var spawn_position: Vector2 = Vector2()
var extra_data: Dictionary = {}
var age: float = 0
var pre_freeze_velocity: Vector2 = Vector2()
var timefreeze: float = 0
var timefreeze_fx = null


export (bool) var can_flip_by_default = true
export (bool) var never_flips = false
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


func _ready() -> void:
	spawn_position = global_position
	add_to_group("entities")
	set_flip(flipped)

func _process(delta: float) -> void:
	if is_on_floor():
		velocity.y = min(velocity.y, 0)
		air_time = 0
	else:
		air_time += delta
	
	flip()
	
	if velocity.y > recent_downyness:
		recent_downyness = velocity.y
	else:
		recent_downyness = lerp(recent_downyness, velocity.y, delta*30)
	
	age += delta

func _physics_process(delta: float) -> void:
	if timefreeze <= 0:
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
	velocity.x -= velocity.x * friction * delta

func gravitate(delta: float):
	if velocity.y > 0:
		velocity.y += gravity * delta * fall_multiplier
	else:
		velocity.y += gravity * delta

func is_grounded() -> bool:
	return air_time < coyote_time and coyote_enabled

func time_freeze(duration: float):
	timefreeze = duration
	pre_freeze_velocity = velocity


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
