extends "res://animations/animation_scene.gd"


var clouns = [
	preload("res://animations/tower_telescope/3_cloun0.png"),
	preload("res://animations/tower_telescope/3_cloun1.png"),
	preload("res://animations/tower_telescope/3_cloun2.png"),
	preload("res://animations/tower_telescope/3_cloun3.png"),
]
var rocks = [
	preload("res://animations/tower_telescope/3_rock0.png"),
	preload("res://animations/tower_telescope/3_rock1.png"),
	preload("res://animations/tower_telescope/3_rock2.png"),
	preload("res://animations/tower_telescope/3_rock3.png"),
]
var lands = [
	preload("res://animations/tower_telescope/3_land0.png"),
	preload("res://animations/tower_telescope/3_land1.png"),
	preload("res://animations/tower_telescope/3_land2.png"),
]

var centre = Vector2(288, 220)
var bits = []
var bit_speed: float = 4


func _process(delta: float) -> void:
	if randf()*3 < 1:
		deploy_cloun()
	if randf()*3 < 1:
		deploy_rock()
	
	move_pieces(delta)


func add_bit(what: Sprite, pos: Vector3, size: float = 1):
	bits.append({"piece": what, "position": pos, "id": randi(), "age": 0, "size": size})

func move_pieces(delta: float):
	var to_delete: Array = []
	
	for index in range(bits.size()):
		var this_thing: Dictionary = bits[index]
		this_thing["position"].z -= bit_speed*delta
		this_thing["age"] += delta
		position_piece(this_thing)
		
		var piece: Sprite = this_thing["piece"]
		var age: float = this_thing["age"]
		if age < .25:
			piece.modulate.a = age * 4
		if piece.scale.x > 1:
			piece.modulate.a = 2-piece.scale.x
		if piece.scale.x >= 2:
			piece.queue_free()
			to_delete.append(index)
	
	to_delete.sort()
	while to_delete.size() > 0:
		bits.remove( to_delete.pop_back() )

func position_piece(what: Dictionary):
	var piece: Sprite = what["piece"]
	var pos: Vector3 = what["position"]
	
	var power: float = pow(2, pos.z)
	var factor: float = (power-1) / power
	var size: float = 1.0 / power
	size *= what["size"]
	
	var base_position = Vector2(pos.x, pos.y)
	piece.position = base_position.linear_interpolate( centre, factor )
	piece.scale = Vector2(size, size)

func deploy_cloun():
	var index = randi() % clouns.size()
	var this_texture: Texture = clouns[index]
	
	var sprite = Sprite.new()
	sprite.texture = this_texture
	
	$bits.add_child(sprite)
	
	var x = rand_range(0 - 1000, 576 + 1000)
	var y = rand_range(0 - 500, 110)
	var z = rand_range(1, 4)
	
	add_bit(sprite, Vector3(x, y, z), rand_range(.2, 1))
	
	if randf()*2 < 1:
		sprite.flip_h = true

func deploy_rock():
	var index = randi() % rocks.size()
	var this_texture: Texture = rocks[index]
	
	var sprite = Sprite.new()
	sprite.texture = this_texture
	
	$bits.add_child(sprite)
	
	var x = rand_range(0 - 1000, 576 + 1000)
	var y = 440
	var z = rand_range(1, 4)
	
	add_bit(sprite, Vector3(x, y, z), rand_range(.3, .5))
	
	sprite.flip_h = true


func _on_land_changer_timeout() -> void:
	var index = randi() % lands.size()
	$land.texture = lands[index]
