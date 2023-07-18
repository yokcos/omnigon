class_name Being
extends Entity


# Speed for walking across the ground
export (float) var acceleration = 1000
export (float) var speed = 100

export (float) var jump_speed = 300
# Knockback is divided by this number
export (float) var knockback_resistance = 1

export (bool) var hp_overflow = false
export (float) var max_hp = 3
var hp: float = -1 setget set_hp
var poisoned: bool = false setget set_poisoned

var must_breathe: bool = false
var max_air: float = 10 # in seconds
var air: float = max_air
var drown_damage_interval: float = 2

var invuln: float = 0
export (float) var invuln_duration = 0.2

var flash_material: bool = false

export (Vector2) var centre_offset = Vector2(0, -16)
export (bool) var saving_enabled = true

export (String) var boss_theme = ""


var obj_part_hit = preload("res://fx/part_hit.tscn")
var obj_part_stars = preload("res://fx/part_death_stars.tscn")
var obj_part_spirals = preload("res://fx/part_death_spirals.tscn")


signal damage_taken
signal hp_changed


func _ready() -> void:
	if hp < 0:
		hp = max_hp
	
	add_to_group("beings")
	
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
	
	if poisoned and randf() * 1000 < 1:
		take_damage(1)
	
	if submerged and must_breathe:
		var prev_air: float = air
		air -= delta
		
		if air <= -drown_damage_interval:
			if fposmod(air, drown_damage_interval) > fposmod(prev_air, drown_damage_interval):
				take_damage(1)
	else:
		air = max_air


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
	if !hp_overflow:
		hp = min(hp, max_hp)
	
	set_hp(hp - what)
	
	if invuln <= 0 and what > 0:
		invuln = invuln_duration
		if flash_material:
			material.set_shader_param( "factor", 1 )
		
		if is_instance_valid(Game.world):
			var new_part_hit = obj_part_hit.instance()
			Game.deploy_instance(new_part_hit, global_position + centre_offset)
		
		emit_signal("damage_taken", what)
		
		return what
	
	return 0.0

func set_hp(what: float):
	hp = what
	if !hp_overflow:
		hp = min(hp, max_hp)
	
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

func set_poisoned(what: bool):
	poisoned = what
