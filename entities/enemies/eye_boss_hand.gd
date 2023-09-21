extends Enemy


var float_offset: Vector2 = Vector2()
var father: Entity = null
var angle: float = PI/2
var fulcrum: Node2D
var barrel: Node2D
var index: int = 0
var value: float = 25

var obj_chest = load("res://props/interactables/chest.tscn")

const obj_bullet = preload("res://projectiles/bullet.tscn")
const obj_particles = preload("res://fx/part_orangegreen_slam.tscn")


func _ready() -> void:
	add_to_group("saveables")
	
	fulcrum = $flippable/rotatable
	barrel = $flippable/rotatable/barrel

func _process(delta: float) -> void:
	if is_instance_valid(father):
		var target_position = father.global_position + float_offset
		velocity = (target_position - global_position) * speed / 20
	else:
		can_bounce = true
	
	fulcrum.rotation = lerp_angle(fulcrum.rotation, angle, delta * 5)


func get_saved() -> Dictionary:
	return {
		"value": value,
		"flipped": flipped,
		"index": index,
		"spawn_position": spawn_position,
	}

func get_loaded(what: Dictionary):
	value = what["value"]
	set_flip(what["flipped"])
	index = what["index"]
	spawn_position = what["spawn_position"]
	
	value -= WorldSaver.load_data(spawn_position)

func apply_index():
	if is_instance_valid(father):
		father.hands[index] = self

func shoot(speed: float, dir: float = 0):
	var new_bullet = obj_bullet.instance()
	
	Game.deploy_instance(new_bullet, barrel.global_position)
	new_bullet.velocity = barrel.global_transform.x.rotated(deg2rad(dir)) * speed

func deploy_particles():
	var new_particles = obj_particles.instance()
	
	Game.deploy_instance(new_particles, barrel.global_position)
	new_particles.rotation = barrel.global_rotation

func get_shifted():
	var new_chest = obj_chest.instance()
	new_chest.father = father
	new_chest.float_offset = float_offset
	new_chest.spawn_position = spawn_position
	new_chest.flipped = flipped
	new_chest.index = index
	new_chest.value = value
	
	for this_vertex in get_tree().get_nodes_in_group("vertices"):
		if this_vertex.source == self:
			this_vertex.source = new_chest
	
	Game.replace_instance(self, new_chest)
