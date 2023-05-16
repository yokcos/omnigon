class_name FishticuffsFish
extends Being


export (float) var value = 1
export (Texture) var corpse_sprite = null
export (Vector2) var target_velocity = Vector2(20, 0)
export (bool) var homeostatify_velocity = true

const obj_bullet = preload("res://projectiles/bullet.tscn")
const obj_corpse = preload("res://fishticuffs/fish/corpse.tscn")


func _ready() -> void:
	gravity = 0
	friction = 0
	can_bounce = false
	can_be_bounced = false
	
	set_collision_layer_bit(0, false)
	set_collision_layer_bit(1, true)
	
	set_collision_mask_bit(0, false)
	set_collision_mask_bit(4, true)
	
	material.set_shader_param( "colour", Color("73efe8") )
	
	obj_part_hit = preload("res://fishticuffs/decor/part_fish_hit.tscn")
	obj_part_stars = preload("res://fishticuffs/decor/part_fish_stars.tscn")
	obj_part_spirals = preload("res://fishticuffs/decor/part_fish_spirals.tscn")

func _process(delta: float) -> void:
	if homeostatify_velocity:
		var this_target = target_velocity
		this_target.x *= flip_int
		velocity = velocity.linear_interpolate( this_target, delta*2 )
	
	if global_position.x < -16 or global_position.x > 528:
		queue_free()


func take_damage(what: float, from: Being = null):
	var dmg = .take_damage(what, from)
	
	GlobalSound.play_random_sfx_2d( GlobalSound.sfx_fc_hook_hit, global_position )
	return dmg

func advance_timer(what: Timer, time: float):
	var original_time = what.wait_time
	what.start( original_time - time )
	what.wait_time = original_time

func die():
	var new_corpse = obj_corpse.instance()
	new_corpse.value = value
	new_corpse.texture = corpse_sprite
	Game.deploy_instance(new_corpse, global_position)
	
	GlobalSound.play_random_sfx_2d( GlobalSound.sfx_fc_fish_die, global_position )
	
	.die()

func deploy_bullet(this_velocity: Vector2, sprite: Texture, pos: Vector2, frames: int = 8):
	var new_bullet = obj_bullet.instance()
	new_bullet.set_sprite(sprite, frames)
	new_bullet.set_collision_mask_bit(1, false)
	new_bullet.velocity = this_velocity
	new_bullet.death_particles = preload("res://fishticuffs/decor/fish_bbreak.png")
	pos.x *= flip_int
	new_bullet.velocity.x *= flip_int
	Game.deploy_instance(new_bullet, global_position + pos)
	return new_bullet
