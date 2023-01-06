class_name Being
extends Entity


# Speed for walking across the ground
export (float) var acceleration = 1000
export (float) var speed = 100

export (float) var jump_speed = 300
# Knockback is divided by this number
export (float) var knockback_resistance = 1

export (float) var max_hp = 3
onready var hp = max_hp setget set_hp

var invuln: float = 0
export (float) var invuln_duration = 0.2

var flash_material: bool = false

export (Vector2) var centre_offset = Vector2(0, -16)
export (bool) var saving_enabled = true

export (String) var boss_theme = ""


const obj_part_hit = preload("res://fx/part_hit.tscn")
const obj_part_stars = preload("res://fx/part_death_stars.tscn")
const obj_part_spirals = preload("res://fx/part_death_spirals.tscn")


signal damage_taken
signal hp_changed


func _ready() -> void:
	add_to_group("beings")
	set_collision_layer_bit(0, false)
	set_collision_layer_bit(1, true)
	
	set_collision_mask_bit(0, true)
	set_collision_mask_bit(1, true)
	set_collision_mask_bit(2, true)
	
	#var data = WorldSaver.load_data(spawn_position)
	
	#if !is_in_group("players"):
	#	get_loaded(data)
	
	if !material:
		material = preload("res://misc/mat_colouriser.tres").duplicate(true)
		material.set_shader_param( "colour", Color("f9a31b") )
		flash_material = true

func _process(delta: float) -> void:
	if invuln > 0:
		invuln -= delta
		if invuln <= 0 and flash_material:
			material.set_shader_param( "factor", 0 )


func get_loaded(data):
	if data:
		global_position = data["position"]
		
		if data["hp"] <= 0:
			queue_free()
		else:
			hp = data["hp"]

func calculate_friction():
	friction = acceleration / speed

func accelerate(direction: float, delta: float):
	velocity.x += direction * acceleration * delta

func jump(factor: float = 1):
	velocity.y = -jump_speed * factor
	velocity.y = min( velocity.y, -jump_speed * factor )

func take_knockback(knock: Vector2):
	velocity += knock / knockback_resistance

func take_damage(what: float, from: Being = null) -> float:
	# Returns the actual amount of damage dealt
	if invuln <= 0:
		set_hp(hp - what)
		
		invuln = invuln_duration
		if flash_material:
			material.set_shader_param( "factor", 1 )
		
		var new_part_hit = obj_part_hit.instance()
		Game.deploy_instance(new_part_hit, global_position + centre_offset)
		
		emit_signal("damage_taken", what)
		
		return what
	
	return 0.0

func set_hp(what: float):
	hp = what
	
	emit_signal("hp_changed", what)
	
	if hp <= 0:
		die()

func die():
	var new_part
	new_part = obj_part_spirals.instance()
	Game.deploy_instance(new_part, global_position + centre_offset)
	new_part = obj_part_stars.instance()
	Game.deploy_instance(new_part, global_position + centre_offset)
	
	WorldSaver.save_being(self)
	queue_free()
