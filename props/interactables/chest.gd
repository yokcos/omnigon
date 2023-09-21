extends Node2D


var value: float = 25 setget set_value
var float_offset: Vector2 = Vector2()
var spawn_position: Vector2 = Vector2()
var father: Entity = null
var flipped: bool = false
var index: int = 0
var obj_hand = load("res://entities/enemies/eye_boss_hand.tscn")

const obj_vertex = preload("res://entities/vertex.tscn")


func _ready() -> void:
	add_to_group("saveables")
	call_deferred("descend")


func get_saved() -> Dictionary:
	return {
		"value": value,
		"flipped": flipped,
		"index": index,
		"spawn_position": spawn_position,
	}

func get_loaded(what: Dictionary):
	set_value(what["value"])
	flipped = what["flipped"]
	index = what["index"]
	spawn_position = what["spawn_position"]
	
	set_value(value - WorldSaver.load_data(spawn_position))

func descend():
	global_position.y -= 32
	$raycast.force_raycast_update()
	global_position = $raycast.get_collision_point() + Vector2(0, -16)
	$raycast.enabled = false

func open():
	for i in range(value):
		var new_vertex = obj_vertex.instance()
		var xspeed = 0
		if global_position.x < 100: xspeed += 75
		if global_position.y > 412: xspeed -= 75
		new_vertex.apply_central_impulse( Vector2(rand_range(xspeed-80, xspeed+80), rand_range(-600, -400)) )
		new_vertex.source = self
		Game.deploy_instance(new_vertex, $barrel.global_position)
	value = 0

func set_value(what: float):
	value = what
	
	if value <= 0:
		$sprite.frame = 7
		$interactable.active = false



func _on_interactable_activated() -> void:
	$interactable.active = false
	$animator.play("open")

func _on_shift() -> void:
	var new_hand = obj_hand.instance()
	print("Shapeshifted chest %s into a hand" % index)
	new_hand.father = father
	#new_hand.float_offset = float_offset
	new_hand.spawn_position = spawn_position
	new_hand.call_deferred("set_flip", flipped)
	new_hand.index = index
	new_hand.value = value
	new_hand.apply_index()
	
	for this_vertex in get_tree().get_nodes_in_group("vertices"):
		if this_vertex.source == self:
			this_vertex.source = new_hand
	
	Game.replace_instance(self, new_hand)

